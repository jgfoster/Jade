import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class JadeServer {
  var _isInitialized = false;
  late final _socket;

  JadeServer(var host, var port) {
    initialize(host, port);
  }

  // Future<Map<String, dynamic>> _read() async {}

  Future<void> _write(var map) async {
    await waitForInitialization();
    var data = jsonEncode(map);
    var byteList = Uint8List(5);
    var byteData = ByteData.view(byteList.buffer);
    byteData.setUint8(0, 1);
    byteData.setUint32(1, data.length);
    await _socket.add(byteList);
    await _socket.write(data);
  }

  Future<void> initialize(var host, var port) async {
    _socket = await SecureSocket.connect(host, port);
    _isInitialized = true;
  }

  getGciVersion() async {
    await _write({'request': 'getGciVersion'});
  }

  Future<void> waitForInitialization() async {
    while (!_isInitialized) {
      await new Future.delayed(new Duration(milliseconds: 50));
    }
  }
}
