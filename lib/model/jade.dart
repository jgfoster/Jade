import 'package:flutter/material.dart';
import 'package:jade/model/login.dart';

class Jade with ChangeNotifier {
  static final Jade _jade = Jade._internal();
  final LoginList loginList = LoginList();
  Login? _selectedLogin;

  factory Jade() => _jade;

  Jade._internal() {
    newLogin();
  }

  void newLogin() {
    var id = 1;
    while (loginList.any((each) => each.id == id)) {
      ++id;
    }
    var login = Login(id);
    loginList.add(login);
  }

  Login? get selectedLogin => _selectedLogin;
  set selectedLogin(Login? login) {
    if (_selectedLogin != login) {
      loginList.forEach((each) {
        if (each != login) {
          each.isSelected = false;
        }
      });
      _selectedLogin = login;
      notifyListeners();
    }
  }
}
