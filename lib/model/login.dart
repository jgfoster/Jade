import 'package:flutter/material.dart';

class Login with ChangeNotifier {
  late int id;
  String _address = 'localhost:50378';
  String _username = 'DataCurator';
  String _password = 'swordfish';
  bool _isSelected = false;

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

  get isSelected => _isSelected;
  set isSelected(var aString) {
    _isSelected = aString;
    notifyListeners();
  }

  @override
  int get hashCode {
    return (_address + _username + _password).hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType == Login) {
      var rhs = other as Login;
      return _address == rhs.address &&
          _username == rhs.username &&
          _password == rhs.password;
    }
    return false;
  }
}
