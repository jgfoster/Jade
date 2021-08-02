import 'package:flutter_test/flutter_test.dart';

import 'package:jade/jade_server.dart';

/*
Log instance logTypes: #(#'startup' #'debug' #'request' #'warning' #'error').
Log instance haltOnError: true.
GciLibraryApp run.
*/

void main() {
  final server = JadeServer('localhost', 8888);
  int session1 = 0;
  int session2 = 0;

  test('getGciVersion', () async {
    var version = await server.getGciVersion();
    expect(version, startsWith('3.6.1'));
  });

  test('encrypt', () async {
    var encrypted = await server.encrypt('swordfish');
    expect(encrypted, equals('GT543NBVJJUQK7ICC7CZTWAHPE'));
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
    expect(await server.doBreak(session1, true), isTrue);
  });

  test('softBreak', () async {
    expect(await server.doBreak(session1, false), isTrue);
  });

  test('abort', () async {
    expect(await server.abort(session1), isTrue);
  });

  test('begin', () async {
    expect(await server.begin(session1), isTrue);
  });

  test('commit', () async {
    expect(await server.commit(session1), isTrue);
  });

  test('sessionIsRemote', () async {
    expect(await server.sessionIsRemote(session1), isTrue);
  });

  test('logout session 1', () async {
    expect(await server.logout(session1), isTrue);
  });

  test('logout session 2', () async {
    expect(await server.logout(session2), isTrue);
  });

  test('logout second time should fail', () async {
    expect(await server.logout(session2), isFalse);
  });

  test('hardBreak after logout', () async {
    expect(await server.doBreak(session1, true), isFalse);
  });

  test('softBreak after logout', () async {
    expect(await server.doBreak(session1, false), isFalse);
  });

  test('sessionIsRemote after logout', () async {
    expect(await server.sessionIsRemote(session1), isFalse);
  });
}
