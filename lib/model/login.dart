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

class LoginList with ChangeNotifier {
  final List<Login> _list = [];

  void add(Login login) {
    _list.add(login);
    notifyListeners();
  }

  bool any(bool Function(Login) test) {
    for (Login element in _list) {
      if (test(element)) return true;
    }
    return false;
  }

  get first => _list.first;
  get last => _list.last;
  get length => _list.length;

  void forEach(void Function(Login) predicate) {
    for (Login each in _list) {
      predicate(each);
    }
    notifyListeners();
  }

  Iterable<T> map<T>(T Function(Login) toElement) sync* {
    for (var value in _list) {
      yield toElement(value);
    }
  }

  void remove(Login login) {
    _list.remove(login);
    notifyListeners();
  }

  Login operator [](int index) {
    return _list[index];
  }

  void operator []=(int index, Login login) {
    _list[index] = login;
    notifyListeners();
  }
}
