import 'package:flutter_test/flutter_test.dart';

import 'package:jade/model/jade.dart';

void main() {
  test('default login', () {
    var login = Jade().logins[0];
    expect(login.id, 1);
    expect(login.address, 'localhost:50378');
    expect(login.username, 'DataCurator');
    expect(login.password, 'swordfish');
  });

  test('new login', () {
    var login = Jade().newLogin();
    expect(login.id, 2);
    expect(login.address, 'localhost:50378');
    expect(login.username, 'DataCurator');
    expect(login.password, 'swordfish');
  });
}
