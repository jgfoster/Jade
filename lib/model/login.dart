import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';

class Login with ChangeNotifier {
  late int id;
  String _address = 'localhost:50378';
  String _username = 'DataCurator';
  String _password = 'swordfish';

  Login(this.id);

  get address => _address;

  set address(var aString) {
    _address = aString;
    notifyListeners();
  }

  get username => _username;

  set username(var aString) {
    _username = aString;
    notifyListeners();
  }

  get password => _password;

  set password(var aString) {
    _password = aString;
    notifyListeners();
  }

  get isSelected => Jade().selectedLogin == this;

  void beSelected() {
    Jade().selectedLogin = this;
  }

  void beNotSelected() {
    if (Jade().selectedLogin == this) {
      Jade().selectedLogin = null;
    }
  }

  void selectionStatusChanged() {
    notifyListeners();
  }

  @override
  int get hashCode {
    return (_address + _username + _password).hashCode;
  }

  @override
  bool operator ==(Object other) {
    return other.runtimeType == Login && id == (other as Login).id;
  }
}
