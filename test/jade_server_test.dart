import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jade/jade_server.dart';

/*
Log instance logTypes: #(#'startup' #'debug' #'request' #'warning' #'error').
Log instance haltOnError: true.
GciLibraryApp run.
*/

void main() {
  final server = JadeServer('localhost', 8888);
  late int session1;
  late int session2;

  test('getGciVersion', () async {
    var version = await server.getGciVersion();
    expect(version, startsWith('3.6.1'));
  });

  test('login with invalid password', () async {
    var flag = false;
    try {
      session1 = await server.login('DataCurator', 'spearfish');
    } on GciError catch (e) {
      expect(e.error['error'], equals(4051));
      flag = true;
    }
    expect(flag, isTrue);
  });

  test('login with valid password', () async {
    session1 = await server.login('DataCurator', 'swordfish');
    expect(session1, isA<int>());
  });

  test('second login should succeed', () async {
    session2 = await server.login('DataCurator', 'swordfish');
    expect(session2, isA<int>());
    expect(session1, isNot(session2));
  });

  test('hardBreak', () async {
    var result = await server.doBreak(session1, true);
    print(result);
  });

  test('softBreak', () async {
    var result = await server.doBreak(session1, false);
    print(result);
  });
}
