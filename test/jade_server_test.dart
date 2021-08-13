import 'package:flutter_test/flutter_test.dart';

import 'package:jade/jade_server.dart';

/*
Log instance logTypes: #(#'startup' #'debug' #'request' #'warning' #'error').
Log instance haltOnError: true.
GciLibraryApp run.
*/

void main() {
  final server = JadeServer('localhost', 8888);
  String session1 = '0';
  String session2 = '0';
  int socket = 0;

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
    expect(await server.oopIsSpecial('0000000000000014'), true); // nil
    expect(await server.oopIsSpecial('000000000000010C'), true); // true
    expect(await server.oopIsSpecial('0000000000000002'), true); // 0
    expect(await server.oopIsSpecial('000000000000611C'), true); // $a
    expect(await server.oopIsSpecial('7F40000000000006'), true); // 1.25
    expect(await server.oopIsSpecial('000000080000022C'), true); // 1/2
    expect(await server.oopIsSpecial('0000000002AFB901'), false); // Object new
  });

  test('fetchSpecialClass', () async {
    expect(await server.fetchSpecialClass('0000000000000014'), '12A01'); // nil
    expect(await server.fetchSpecialClass('000000000000010C'), '10A01'); // true
    expect(await server.fetchSpecialClass('0000000000000002'), '12201'); // 0
    expect(await server.fetchSpecialClass('000000000000611C'), '10B01'); // $a
    expect(await server.fetchSpecialClass('7F40000000000006'), '1DA01'); // 1.25
    expect(await server.fetchSpecialClass('000000080000022C'), '26201'); // 1/2
  });

  test('oopToChar', () async {
    expect(await server.oopToChar('0014'), -0x1); // nil
    expect(await server.oopToChar('411C'), 0x41); // $A
    expect(await server.oopToChar('7A1C'), 0x7A); // $z
  });

  test('charToOop', () async {
    expect(await server.charToOop(0x41), '411C'); // $A
    expect(await server.charToOop(0x7A), '7A1C'); // $z
  });

  test('doubleToSmallDouble', () async {
    expect(await server.doubleToSmallDouble(1.25), '7F40000000000006');
    expect(await server.doubleToSmallDouble(0.00), '6');
    expect(await server.doubleToSmallDouble(-3.5), '80C000000000000E');
  });

  test('i32ToOop', () async {
    expect(await server.i32ToOop(0x7FFFFFFF), '3FFFFFFFA');
    expect(await server.i32ToOop(0), '2');
    expect(await server.i32ToOop(-0x80000000), 'FFFFFFFC00000002');
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
    expect(session1, isA<String>());
  });

  test('second login should succeed', () async {
    session2 = await server.login('DataCurator', 'swordfish');
    expect(session2, isA<String>());
    expect(session1, isNot(session2));
  });

// while logged in
  test('socket', () async {
    socket = await server.socket(session1);
    expect(socket, isA<int>());
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

  test('doubleToOop', () async {
    expect(await server.doubleToOop(session1, 1.25), '7F40000000000006');
    expect(await server.doubleToOop(session1, 0.00), '6');
    expect(await server.doubleToOop(session1, -3.5), '80C000000000000E');
  });

  test('oopToDouble', () async {
    expect(await server.oopToDouble(session1, '7F40000000000006'), 1.25);
    expect(await server.oopToDouble(session1, '6'), 0.00);
    expect(await server.oopToDouble(session1, '80C000000000000E'), -3.5);
  });

  test('i64ToOop', () async {
    var x = await server.i64ToOop(session1, BigInt.from(0x0FFFFFFFFFFFFFFF));
    expect(x, '7FFFFFFFFFFFFFFA');
    x = await server.i64ToOop(session1, BigInt.from(0x1000000000000000));
    expect(x, isA<String>()); // LargeInteger, so generic OOP
  });

  test('oopToI64', () async {
    var x;
    x = await server.oopToI64(session1, '2A');
    expect(x, equals(BigInt.from(5)));
    x = await server.oopToI64(session1, '07FFFFFFFFFFFFFA');
    expect(x, equals(BigInt.from(0x0FFFFFFFFFFFFFF)));
    x = await server.oopToI64(session1, '7FFFFFFFFFFFFFFA');
    expect(x, equals(BigInt.from(0xFFFFFFFFFFFFFFF)));
  });

  test('resolveSymbol', () async {
    var x;
    x = await server.resolveSymbol(session1, 'Array');
    expect(x, '10501');
    x = await server.resolveSymbol(session1, 'size');
    expect(x, '1');
  });

  test('resolveSymbolObj', () async {
    var x;
    // look for #'Array' in current SymbolList
    x = await server.resolveSymbolObj(session1, '1C6401');
    expect(x, '10501');
    // look for #'Array' in DataCurator's SymbolList
    x = await server.resolveSymbolObj(session1, '1C6401', '28C001');
    expect(x, '10501');
    x = await server.resolveSymbolObj(session1, '2A9701'); // #'size'
    expect(x, '1');
  });

  test('nbResult with nothing', () async {
    var x = await server.nbResult(session1, socket, 0);
    expect(x, isNull);
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
