import 'package:flutter_test/flutter_test.dart';

import 'package:jade/gci_session.dart';

void main() {
  final gci = GciSession('http://localhost:8888/');

  test('isCallInProgress', () async {
    expect(await gci.isCallInProgress(), isFalse);
  });

  test('nbEnd with no result', () async {
    final response = await gci.nbEnd();
    expect(response['progress'], equals(2)); // GCI_RESULT_READY
    expect(response['result'], equals(0));
  });

  test('nbExecuteStr', () async {
    await gci.nbExecuteStr('2 + 3');
  });

  test('nbEnd with result of 5', () async {
    final response = await gci.nbEnd();
    expect(response['progress'], equals(2)); // GCI_RESULT_READY
    expect(response['result'], equals(42));
  });
}
