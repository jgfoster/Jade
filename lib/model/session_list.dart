import 'package:flutter/material.dart';
import 'package:jade/model/session.dart';

class SessionList with ChangeNotifier {
  final List<Session> _list = [];

  void add(Session session) {
    _list.add(session);
    notifyListeners();
  }

  bool any(bool Function(Session) test) {
    for (Session element in _list) {
      if (test(element)) return true;
    }
    return false;
  }

  get first => _list.first;
  get isEmpty => _list.isEmpty;
  get isNotEmpty => _list.isNotEmpty;
  get last => _list.last;
  get length => _list.length;

  void forEach(void Function(Session) predicate) {
    for (Session each in _list) {
      predicate(each);
    }
  }

  Iterable<T> map<T>(T Function(Session) toElement) sync* {
    for (var value in _list) {
      yield toElement(value);
    }
  }

  void remove(Session session) {
    _list.remove(session);
    session.beNotSelected();
    notifyListeners();
  }

  Session operator [](int index) {
    return _list[index];
  }

  void operator []=(int index, Session session) {
    _list[index] = session;
    notifyListeners();
  }
}
