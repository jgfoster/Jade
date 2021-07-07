import 'package:flutter_test/flutter_test.dart';

import 'package:jade/jade_server.dart';

void main() {
  final server = JadeServer('localhost', 8888);

  test('connect', () async {
    await server.getGciVersion();
    expect(true, isTrue);
  });
}
