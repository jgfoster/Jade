import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;

class GciError extends StateError {
  late final error;
  GciError(Map<String, dynamic> gciError)
      : error = gciError,
        super(gciError['message']);
}

class JadeServer {
  final _buffer = <Map<String, dynamic>>[];
  var _isInitialized = false;
  late final _channel;

  JadeServer(var host, var port) {
    _initialize(host, port);
  }

  Future<void> _initialize(var host, var port) async {
    var uri = Uri.parse('ws://localhost:8888/webSocket.gs');
    _channel = WebSocketChannel.connect(uri);
    _channel.stream.listen(
      _onData,
      onDone: _onDone,
      onError: _onError,
    );
    _isInitialized = true;
  }

  void _onData(dynamic data) async {
    var obj = jsonDecode(data);
    print('_onData() - $obj');
    _buffer.add(obj);
  }

  void _onDone() {
    print('_onDone()');
    _channel.sink.close();
  }

  void _onError(var error) {
    print('_onError() - $error');
    _channel.sink.close();
  }

  Future<void> _write(var map) async {
    await waitForInitialization();
    _channel.sink.add(jsonEncode(map));
  }

  void close() {
    print('JadeServer().close();');
    _channel.sink.close();
  }

  Future<String> getGciVersion() async {
    _write({'request': 'getGciVersion'});
    while (_buffer.isEmpty) {
      await Future.delayed(Duration(milliseconds: 10));
    }
    var data = _buffer.removeAt(0);
    return data['version'];
  }

  Future<void> login(String username, String password) async {
    print('login($username, $password)');
    _write({
      'request': 'login',
      'username': username,
      'password': password,
    });
    while (_buffer.isEmpty) {
      print('wait');
      await Future.delayed(Duration(milliseconds: 200));
    }
    var data = _buffer.removeAt(0);
    if (data['error'] == 4051) {
      throw GciError(data);
    }
    print('login() - $data');
  }

  Future<void> waitForInitialization() async {
    while (!_isInitialized) {
      await new Future.delayed(new Duration(milliseconds: 50));
    }
  }
}
