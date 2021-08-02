import 'package:flutter_test/flutter_test.dart';

import 'package:jade/jade_server.dart';

/*
Log instance logTypes: #(#'startup' #'debug' #'request' #'warning' #'error').
Log instance haltOnError: true.
GciLibraryApp run.
*/

void main() {
  final server = JadeServer('localhost', 8888);

  test('getGciVersion', () async {
    var version = await server.getGciVersion();
    expect(version, startsWith('3.6.1'));
  });

  test('login with invalid password', () async {
    var flag = false;
    try {
      await server.login('DataCurator', 'spearfish');
    } on GciError catch (e) {
      expect(e.error['error'], equals(4051));
      flag = true;
    }
    expect(flag, isTrue);
  });
}
