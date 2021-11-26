import 'package:flutter/material.dart';
import 'package:jade/model/login.dart';
import 'package:jade/model/login_list.dart';

class Jade with ChangeNotifier {
  static final Jade _jade = Jade._internal();
  final LoginList loginList = LoginList();
  Login? _selectedLogin;

  factory Jade() => _jade;

  Jade._internal() {
    // let the constructor finish so that _jade is assigned
    // otherwise we end up in an endless loop!
    Future.microtask(() => newLogin());
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
      var priorSelection = _selectedLogin;
      _selectedLogin = login;
      priorSelection?.selectionStatusChanged();
      _selectedLogin?.selectionStatusChanged();
      if (_selectedLogin == null && loginList.isNotEmpty) {
        loginList.last.beSelected(); // this will come back to us!
      } else {
        notifyListeners();
      }
    }
  }
}
