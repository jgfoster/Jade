import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

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
    _buffer.add(obj);
  }

  void _onDone() {
    print('_onDone()');
    _channel.sink.close();
  }

  void _onError(var error) {
    print(error);
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
    return data['gciVersion'];
  }

  Future<void> waitForInitialization() async {
    while (!_isInitialized) {
      await new Future.delayed(new Duration(milliseconds: 50));
    }
  }
}
