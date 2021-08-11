import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

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
    // print('_onData() - $obj');
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

  Future<bool> abort(num session) async {
    _write({'request': 'abort', 'session': session});
    var data = await _read();
    return data['result'] == 1;
  }

  Future<bool> begin(num session) async {
    _write({'request': 'begin', 'session': session});
    var data = await _read();
    return data['result'] == 1;
  }

  Future<num> charToOop(int anOop) async {
    _write({'request': 'charToOop', 'char': anOop});
    var data = await _read();
    return data['result'];
  }

  void close() {
    print('JadeServer().close();');
    _channel.sink.close();
  }

  Future<bool> commit(num session) async {
    _write({'request': 'commit', 'session': session});
    var data = await _read();
    return data['result'] == 1;
  }

  // 'break' is a reserved word!
  Future<bool> doBreak(num session, bool isHard) async {
    _write({'request': 'break', 'session': session, 'isHard': isHard});
    var data = await _read();
    return data['result'] == 1;
  }

  Future<num> doubleToSmallDouble(double value) async {
    _write({'request': 'doubleToSmallDouble', 'double': value});
    var data = await _read();
    return data['result'];
  }

  Future<String> encrypt(String password) async {
    _write({'request': 'encrypt', 'password': password});
    var data = await _read();
    return data['result'];
  }

  Future<num> fetchSpecialClass(int anOop) async {
    _write({'request': 'fetchSpecialClass', 'oop': anOop});
    var data = await _read();
    return data['result'];
  }

  Future<String> getGciVersion() async {
    _write({'request': 'getGciVersion'});
    var data = await _read();
    return data['version'];
  }

  Future<num> i32ToOop(int value) async {
    _write({'request': 'i32ToOop', 'int': value});
    var data = await _read();
    return data['result'];
  }

  Future<num> login(String username, String password) async {
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

  Future<bool> logout(num session) async {
    _write({'request': 'logout', 'session': session});
    var data = await _read();
    return data['result'] == 1;
  }

  Future<bool> oopIsSpecial(int anOop) async {
    _write({'request': 'oopIsSpecial', 'oop': anOop});
    var data = await _read();
    return data['result'];
  }

  Future<int> oopToChar(int anOop) async {
    _write({'request': 'oopToChar', 'oop': anOop});
    var data = await _read();
    return data['result'];
  }

  Future<bool> sessionIsRemote(num session) async {
    _write({'request': 'sessionIsRemote', 'session': session});
    var data = await _read();
    return data['result'] == 1;
  }

  Future<void> waitForInitialization() async {
    while (!_isInitialized) {
      await new Future.delayed(new Duration(milliseconds: 50));
    }
  }
}
