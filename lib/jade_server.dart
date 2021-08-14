import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class GciError extends StateError {
  late final error;
  GciError(Map<String, dynamic> gciError)
      : error = gciError,
        super(gciError['message']);
}
/*
  Because of the difficulty of representing a true 64-bit integer
  in Dart/JavaScript, we treat a Session ID and an OOP as a
  string representing the hex digits of the actual integer.
  This should be fine since all client code should treat these
  as opaque objects. (We could cut this down to a maximum of eleven
  characters by using Base64 encoding, but that seems needless.)
 */

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
    var result = _buffer.removeAt(0);
    if (result['error'] != null) {
      print(result);
    }
    return result;
  }

  Future<void> _write(var map) async {
    await _waitForInitialization();
    _channel.sink.add(jsonEncode(map));
  }

  void close() {
    print('JadeServer().close();');
    _channel.sink.close();
  }

  Future<void> _waitForInitialization() async {
    while (!_isInitialized) {
      await new Future.delayed(new Duration(milliseconds: 50));
    }
  }

// Public API

  Future<bool> abort(String session) async {
    _write({'request': 'abort', 'session': session});
    var data = await _read();
    return data['result'] == 1;
  }

  Future<bool> begin(String session) async {
    _write({'request': 'begin', 'session': session});
    var data = await _read();
    return data['result'] == 1;
  }

// 'break' is a reserved word!
  Future<bool> doBreak(String session, bool isHard) async {
    _write({'request': 'break', 'session': session, 'isHard': isHard});
    var data = await _read();
    return data['result'] == 1;
  }

  Future<String> charToOop(int anOop) async {
    _write({'request': 'charToOop', 'char': anOop});
    return (await _read())['result'];
  }

  Future<bool> commit(String session) async {
    _write({'request': 'commit', 'session': session});
    var data = await _read();
    return data['result'] == 1;
  }

  Future<String> doubleToOop(String session, double value) async {
    _write({'request': 'doubleToOop', 'double': value, 'session': session});
    return (await _read())['result'];
  }

  Future<String> doubleToSmallDouble(double value) async {
    _write({'request': 'doubleToSmallDouble', 'double': value});
    return (await _read())['result'];
  }

  Future<String> encrypt(String password) async {
    _write({'request': 'encrypt', 'password': password});
    return (await _read())['result'];
  }

  Future<String> fetchSpecialClass(String anOop) async {
    _write({'request': 'fetchSpecialClass', 'oop': anOop});
    return (await _read())['result'];
  }

  Future<String> fetchUnicode(String session, String anOop) async {
    _write({'request': 'fetchUnicode', 'session': session, 'oop': anOop});
    return (await _read())['result'];
  }

  Future<List<String>> getFreeOops(String session, int count) async {
    _write({'request': 'getFreeOops', 'count': count, 'session': session});
    List<String> result = [];
    ((await _read())['result']).forEach((each) {
      result.add(each as String);
    });
    return result;
  }

  Future<String> getGciVersion() async {
    _write({'request': 'getGciVersion'});
    var data = await _read();
    return data['version'];
  }

  Future<String> i32ToOop(int value) async {
    _write({'request': 'i32ToOop', 'int': value});
    return (await _read())['result'];
  }

  Future<String> i64ToOop(String session, BigInt value) async {
    _write({
      'request': 'i64ToOop',
      'i64': value.toRadixString(16),
      'session': session
    });
    return (await _read())['result'];
  }

  Future<String> login(String username, String password) async {
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

  Future<bool> logout(String session) async {
    _write({'request': 'logout', 'session': session});
    var data = await _read();
    return data['result'] == 1;
  }

  Future<String?> nbResult(String session, int socket,
      [int timeout = 0]) async {
    _write({
      'request': 'nbResult',
      'session': session,
      'socket': socket,
      'timeout': timeout,
    });
    return (await _read())['result'];
  }

  Future<String> newByteArray(String session, List<int> bytes) async {
    _write({
      'request': 'newByteArray',
      'bytes': base64.encode(bytes),
      'session': session
    });
    return (await _read())['result'];
  }

  Future<String> newObj(String session, String classOop) async {
    _write({'request': 'newObj', 'class': classOop, 'session': session});
    return (await _read())['result'];
  }

  Future<String> newString(String session, String string) async {
    _write({'request': 'newString', 'string': string, 'session': session});
    return (await _read())['result'];
  }

  Future<String> newSymbol(String session, String string) async {
    _write({'request': 'newSymbol', 'string': string, 'session': session});
    return (await _read())['result'];
  }

  Future<String> newUnicodeString(String session, var bytes) async {
    _write({
      'request': 'newUnicodeString',
      'bytes': base64.encode(bytes),
      'session': session
    });
    return (await _read())['result'];
  }

  Future<String> newUtf8String(String session, var bytes) async {
    _write({
      'request': 'newUtf8String',
      'bytes': base64.encode(bytes),
      'session': session
    });
    return (await _read())['result'];
  }

  Future<bool> oopIsSpecial(String anOop) async {
    _write({'request': 'oopIsSpecial', 'oop': anOop});
    return (await _read())['result'];
  }

  Future<int> oopToChar(String anOop) async {
    _write({'request': 'oopToChar', 'oop': anOop});
    return (await _read())['result'];
  }

  Future<num> oopToDouble(String session, String anOop) async {
    _write({'request': 'oopToDouble', 'oop': anOop, 'session': session});
    return (await _read())['result'];
  }

  Future<BigInt> oopToI64(String session, String anOop,
      [String symbolList = '14']) async {
    _write({'request': 'oopToI64', 'oop': anOop, 'session': session});
    var data = await _read();
    return BigInt.parse(data['result'], radix: 16);
  }

  Future<String> resolveSymbol(String session, String symbol,
      [String symbolList = '14']) async {
    _write({
      'request': 'resolveSymbol',
      'symbol': symbol,
      'symbolList': symbolList,
      'session': session,
    });
    return (await _read())['result'];
  }

  Future<String> resolveSymbolObj(String session, String anOop,
      [String symbolList = '14']) async {
    _write({
      'request': 'resolveSymbolObj',
      'oop': anOop,
      'symbolList': symbolList,
      'session': session,
    });
    return (await _read())['result'];
  }

  Future<bool> sessionIsRemote(String session) async {
    _write({'request': 'sessionIsRemote', 'session': session});
    var data = await _read();
    return data['result'] == 1;
  }

  Future<int> socket(String session) async {
    _write({'request': 'socket', 'session': session});
    return (await _read())['result'];
  }
}
