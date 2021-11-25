import 'package:flutter_test/flutter_test.dart';

import 'package:jade/model/jade.dart';

void main() {
  test('default login', () {
    var login = Jade().loginList[0];
    expect(login.id, 1);
    expect(login.address, 'localhost:50378');
    expect(login.username, 'DataCurator');
    expect(login.password, 'swordfish');
  });

  test('new login', () {
    var logins = Jade().loginList;
    expect(logins.length, 1);
    Jade().newLogin();
    expect(logins.length, 2);
    var login = logins[1];
    expect(login.id, 2);
    expect(login.address, 'localhost:50378');
    expect(login.username, 'DataCurator');
    expect(login.password, 'swordfish');
  });
}
