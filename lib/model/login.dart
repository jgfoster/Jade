import 'package:flutter/material.dart';
import 'package:jade/model/jade_model.dart';

class Login extends JadeModel {
  static Widget getIcon() => const Icon(Icons.login_outlined);
  static String getTitle() => 'Login';

  String _address = 'localhost:50378';
  final _log = StringBuffer();
  String _password = 'swordfish';
  String _username = 'DataCurator';

  get address => _address;

  set address(var aString) {
    if (_address != aString) {
      _address = aString;
      notifyListeners();
    }
  }

  String getLog() => _log.toString();

  void addToLog(String str) {
    _log.writeln(str);
    notifyListeners();
  }

  get title => getTitle();

  get password => _password;

  set password(var aString) {
    if (_password != aString) {
      _password = aString;
      notifyListeners();
    }
  }

  get username => _username;

  set username(var aString) {
    if (_username != aString) {
      _username = aString;
      notifyListeners();
    }
  }
}
