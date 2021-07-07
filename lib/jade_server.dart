import 'dart:convert';
import 'dart:typed_data';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class JadeServer {
  var _isInitialized = false;
  late final _channel;

  JadeServer(var host, var port) {
    initialize(host, port);
  }

  Future<Map<String, dynamic>> _read() async {
    var stream = _channel.stream;
    var version = stream.take(1).first;
    print(version);
    return {};
  }

  Future<void> _write(var map) async {
    await waitForInitialization();
    var data = jsonEncode(map);
    var byteList = Uint8List(5);
    var byteData = ByteData.view(byteList.buffer);
    byteData.setUint8(0, 1);
    byteData.setUint32(1, data.length);
    await _channel.sink.add(byteList);
    await _channel.sink.add(data);
  }

  Future<void> initialize(var host, var port) async {
    var uri = Uri(scheme: 'wss', host: host, port: port);
    _channel = WebSocketChannel.connect(uri);
    _isInitialized = true;
  }

  getGciVersion() async {
    await _write({'request': 'getGciVersion'});
    await _read();
  }

  Future<void> waitForInitialization() async {
    while (!_isInitialized) {
      await new Future.delayed(new Duration(milliseconds: 50));
    }
  }
}
