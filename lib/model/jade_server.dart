import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class GciError extends StateError {
  late final Map<String, dynamic> error;
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
  characters by using Base64 encoding, but that seems unnecessary.)
 */

class JadeServer {
  final _buffer = <Map<String, dynamic>>[];
  var _isInitialized = false;
  late final WebSocketChannel _channel;

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
    _buffer.add(jsonDecode(data));
  }

  void _onDone() {
    // print('_onDone()');
    _channel.sink.close();
  }

  void _onError(var error) {
    // print('_onError() - $error');
    _channel.sink.close();
  }

  Future<Map<String, dynamic>> _read() async {
    while (_buffer.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
    return _buffer.removeAt(0);
  }

  Future<void> _write(var map) async {
    await _waitForInitialization();
    _channel.sink.add(jsonEncode(map));
  }

  void close() {
    // print('JadeServer().close();');
    _channel.sink.close();
  }

  Future<void> _waitForInitialization() async {
    while (!_isInitialized) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

// Public API

  Future<bool> abort(String session) async {
    _write({'request': 'abort', 'session': session});
    var data = await _read();
    return data['result'];
  }

  Future<bool> begin(String session) async {
    _write({'request': 'begin', 'session': session});
    var data = await _read();
    return data['result'];
  }

// 'break' is a reserved word!
  Future<bool> doBreak(String session, bool isHard) async {
    _write({'request': 'break', 'session': session, 'isHard': isHard});
    var data = await _read();
    return data['result'];
  }

  Future<String> charToOop(int anOop) async {
    _write({'request': 'charToOop', 'char': anOop});
    return (await _read())['oop'];
  }

  Future<bool> commit(String session) async {
    _write({'request': 'commit', 'session': session});
    var data = await _read();
    return data['result'];
  }

  Future<String> doubleToOop(String session, double value) async {
    _write({'request': 'doubleToOop', 'session': session, 'double': value});
    return (await _read())['oop'];
  }

  Future<String> doubleToSmallDouble(double value) async {
    _write({'request': 'doubleToSmallDouble', 'double': value});
    return (await _read())['oop'];
  }

  Future<String> encrypt(String password) async {
    _write({'request': 'encrypt', 'password': password});
    return (await _read())['result'];
  }

  Future<bool> execute(String session, String code) async {
    _write({'request': 'execute', 'session': session, 'string': code});
    return (await _read())['result'];
  }

  Future<String> fetchSpecialClass(String anOop) async {
    _write({'request': 'fetchSpecialClass', 'oop': anOop});
    return (await _read())['oop'];
  }

  Future<String> fetchUnicode(String session, String anOop) async {
    _write({'request': 'fetchUnicode', 'session': session, 'oop': anOop});
    return (await _read())['result'];
  }

  Future<List<String>> getFreeOops(String session, int count) async {
    _write({'request': 'getFreeOops', 'session': session, 'count': count});
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
    return (await _read())['oop'];
  }

  Future<String> i64ToOop(String session, BigInt value) async {
    _write({
      'request': 'i64ToOop',
      'i64': value.toRadixString(16),
      'session': session
    });
    return (await _read())['oop'];
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
    return data['result'] ?? false;
  }

  Future<Map<String, dynamic>> nbResult(String session,
      [int timeoutMs = 0]) async {
    _write({
      'request': 'nbResult',
      'session': session,
      'timeout': timeoutMs,
    });
    return await _read();
  }

  Future<String> newByteArray(String session, List<int> bytes) async {
    _write({
      'request': 'newByteArray',
      'bytes': base64Encode(bytes),
      'session': session
    });
    return (await _read())['oop'];
  }

  Future<String> newObj(String session, String classOop) async {
    _write({'request': 'newObj', 'session': session, 'class': classOop});
    return (await _read())['oop'];
  }

  Future<String> newString(String session, String string) async {
    _write({'request': 'newString', 'session': session, 'string': string});
    return (await _read())['oop'];
  }

  Future<String> newSymbol(String session, String string) async {
    _write({'request': 'newSymbol', 'session': session, 'string': string});
    return (await _read())['oop'];
  }

  Future<String> newUnicodeString(String session, var bytes) async {
    // GciTs returns UTF-16 but Dart only supports UTF-8
    // so we just give back the base64 encoded sequence
    _write({
      'request': 'newUnicodeString',
      'bytes': base64Encode(bytes),
      'session': session
    });
    return (await _read())['oop'];
  }

  Future<String> newUtf8String(String session, var bytes) async {
    _write({
      'request': 'newUtf8String',
      'bytes': base64.encode(bytes),
      'session': session
    });
    return (await _read())['oop'];
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
    _write({'request': 'oopToDouble', 'session': session, 'oop': anOop});
    return (await _read())['result'];
  }

  Future<BigInt> oopToI64(String session, String anOop,
      [String symbolList = '14']) async {
    _write({'request': 'oopToI64', 'session': session, 'oop': anOop});
    var data = await _read();
    return BigInt.parse(data['result']);
  }

  Future<String> resolveSymbol(String session, String symbol,
      [String symbolList = '14']) async {
    _write({
      'request': 'resolveSymbol',
      'symbol': symbol,
      'symbolList': symbolList,
      'session': session,
    });
    return (await _read())['oop'];
  }

  Future<String> resolveSymbolObj(String session, String anOop,
      [String symbolList = '14']) async {
    _write({
      'request': 'resolveSymbolObj',
      'oop': anOop,
      'symbolList': symbolList,
      'session': session,
    });
    return (await _read())['oop'];
  }

  Future<bool> sessionIsRemote(String session) async {
    _write({'request': 'sessionIsRemote', 'session': session});
    var data = await _read();
    return data['result'];
  }
}
