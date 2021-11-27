import 'package:flutter/material.dart';
import 'package:jade/model/login.dart';

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
  get isEmpty => _list.isEmpty;
  get isNotEmpty => _list.isNotEmpty;
  get last => _list.last;
  get length => _list.length;

  void forEach(void Function(Login) predicate) {
    for (Login each in _list) {
      predicate(each);
    }
  }

  Iterable<T> map<T>(T Function(Login) toElement) sync* {
    for (var value in _list) {
      yield toElement(value);
    }
  }

  void remove(Login login) {
    _list.remove(login);
    login.beNotSelected();
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
