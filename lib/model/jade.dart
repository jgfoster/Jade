import 'package:flutter/material.dart';
import 'package:jade/model/login.dart';

class Jade with ChangeNotifier {
  static final Jade _jade = Jade._internal();
  List<Login> logins = [];

  factory Jade() => _jade;

  Jade._internal() {
    newLogin();
  }

  Login newLogin() {
    var id = 1;
    while (logins.any((each) => each.id == id)) {
      ++id;
    }
    var login = Login(id);
    logins.add(login);
    notifyListeners();
    return login;
  }
}
