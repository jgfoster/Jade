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

  Future<Map<String, dynamic>> _read() async {
    while (_buffer.isEmpty) {
      await Future.delayed(Duration(milliseconds: 10));
    }
    return _buffer.removeAt(0);
  }

  Future<void> _write(var map) async {
    await waitForInitialization();
    _channel.sink.add(jsonEncode(map));
  }

  Future<bool> abort(int session) async {
    _write({'request': 'abort', 'session': session});
    var data = await _read();
    return data['result'] == 1;
  }

  Future<bool> begin(int session) async {
    _write({'request': 'begin', 'session': session});
    var data = await _read();
    return data['result'] == 1;
  }

  void close() {
    print('JadeServer().close();');
    _channel.sink.close();
  }

  Future<bool> commit(int session) async {
    _write({'request': 'commit', 'session': session});
    var data = await _read();
    return data['result'] == 1;
  }

  // 'break' is a reserved word!
  Future<bool> doBreak(int session, bool isHard) async {
    _write({'request': 'break', 'session': session, 'isHard': isHard});
    var data = await _read();
    return data['result'] == 1;
  }

  Future<String> getGciVersion() async {
    _write({'request': 'getGciVersion'});
    var data = await _read();
    return data['version'];
  }

  Future<int> login(String username, String password) async {
    _write({
      'request': 'login',
      'username': username,
      'password': password,
    });
    var data = await _read();
    if ((data['error'] ?? 0) > 0) {
      throw GciError(data);
    }
    return data['result'];
  }

  Future<void> waitForInitialization() async {
    while (!_isInitialized) {
      await new Future.delayed(new Duration(milliseconds: 50));
    }
  }
}
