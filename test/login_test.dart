import 'package:flutter_test/flutter_test.dart';

import 'package:jade/model/jade.dart';
import 'package:jade/model/login.dart';

void main() {
  test('default login', () async {
    var logins = Jade().loginList;
    expect(logins.length, 1);
    var login = logins[0];
    expect(login.address, 'localhost:50378');
    expect(login.username, 'DataCurator');
    expect(login.password, 'swordfish');
  });

  test('new login', () {
    var logins = Jade().loginList;
    expect(logins.length, 1);
    Jade().addLogin(Login());
    expect(logins.length, 2);
    var login = logins[1];
    expect(login.address, 'localhost:50378');
    expect(login.username, 'DataCurator');
    expect(login.password, 'swordfish');
  });
}
