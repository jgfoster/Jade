import 'package:flutter_test/flutter_test.dart';

import 'package:jade/jade_server.dart';

/*
Log instance logTypes: #(#'startup' #'debug' #'request' #'warning' #'error').
Log instance haltOnError: true.
GciLibraryApp run.
*/

void main() {
  final server = JadeServer('localhost', 8888);
  num session1 = 0;
  num session2 = 0;

// pre-login
  test('getGciVersion', () async {
    var version = await server.getGciVersion();
    expect(version, startsWith('3.6.1'));
  });

  test('encrypt', () async {
    var encrypted = await server.encrypt('swordfish');
    expect(encrypted, equals('GT543NBVJJUQK7ICC7CZTWAHPE'));
  });

  test('oopIsSpecial', () async {
    expect(await server.oopIsSpecial(0x0000000000000014), true); // nil
    expect(await server.oopIsSpecial(0x000000000000010C), true); // true
    expect(await server.oopIsSpecial(0x0000000000000002), true); // 0
    expect(await server.oopIsSpecial(0x000000000000611C), true); // $a
    expect(await server.oopIsSpecial(0x7F40000000000006), true); // 1.25
    expect(await server.oopIsSpecial(0x000000080000022C), true); // 1/2
    expect(await server.oopIsSpecial(45070593), false); // Object new
  });

  test('fetchSpecialClass', () async {
    expect(await server.fetchSpecialClass(0x0000000000000014), 0x12A01); // nil
    expect(await server.fetchSpecialClass(0x000000000000010C), 0x10A01); // true
    expect(await server.fetchSpecialClass(0x0000000000000002), 0x12201); // 0
    expect(await server.fetchSpecialClass(0x000000000000611C), 0x10B01); // $a
    expect(await server.fetchSpecialClass(0x7F40000000000006), 0x1DA01); // 1.25
    expect(await server.fetchSpecialClass(0x000000080000022C), 0x26201); // 1/2
  });

  test('oopToChar', () async {
    expect(await server.oopToChar(0x0014), -0x1); // nil
    expect(await server.oopToChar(0x411C), 0x41); // $A
    expect(await server.oopToChar(0x7A1C), 0x7A); // $z
  });

  test('charToOop', () async {
    expect(await server.charToOop(0x41), 0x411C); // $A
    expect(await server.charToOop(0x7A), 0x7A1C); // $z
  });

  test('doubleToSmallDouble', () async {
    expect(await server.doubleToSmallDouble(1.25),
        9169328841326329862.0); // 0x7F40000000000006
    expect(await server.doubleToSmallDouble(0.00), 6);
    expect(await server.doubleToSmallDouble(-3.5),
        9277415232383222000.0); // 0x80C000000000000Ed
  });

  test('i32ToOop', () async {
    expect(await server.i32ToOop(0x7FFFFFFF), 0x3FFFFFFFA);
    expect(await server.i32ToOop(0), 2);
    expect(await server.i32ToOop(-0x80000000),
        18446744056529682434.0); // 0xFFFFFFFC00000002
  });

// login
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

// while logged in
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

// logout
  test('logout session 1', () async {
    expect(await server.logout(session1), isTrue);
  });

  test('logout session 2', () async {
    expect(await server.logout(session2), isTrue);
  });

// after logout
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
