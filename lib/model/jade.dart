import 'package:flutter/material.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/login.dart';
import 'package:jade/model/session.dart';

class Jade with ChangeNotifier {
  static Jade? _jade;
  final _loginList = <Login>[];
  final _sessionList = <Session>[];
  JadeModel? _selectedModel;
  bool _isShowingNavigation = true;

  // Singleton
  factory Jade() {
    if (_jade == null) {
      // assign variable before proceeding so that
      // subsequent calls find something
      _jade ??= Jade._();
      _jade!.addLogin(Login());
    }
    return _jade!;
  }

  Jade._();

  get loginList => _loginList;
  get sessionList => _sessionList;

  void addLogin(login) {
    _loginList.add(login);
    _selectedModel = login;
    notifyListeners();
  }

  void addSession(Session session) {
    _sessionList.add(session);
    _selectedModel = session;
    notifyListeners();
  }

  get isShowingNavigation => _isShowingNavigation;

  void removeLogin(login) {
    _loginList.remove(login);
    if (_selectedModel == login) {
      _selectedModel = null;
    }
    notifyListeners();
  }

  void removeSession(session) {
    _sessionList.remove(session);
    if (_selectedModel == session) {
      _selectedModel = null;
    }
    notifyListeners();
  }

  JadeModel? get selectedModel => _selectedModel;

  void selectModel(JadeModel? model) {
    if (_selectedModel != model) {
      _selectedModel = model;
      if (_selectedModel != null) {
        _selectedModel?.updateState();
      }
      notifyListeners();
    }
  }

  void toggleIsShowingNavigation() {
    // don't close the drawer if we aren't showing anything!
    if (_isShowingNavigation && _selectedModel == null) {
      return;
    }
    _isShowingNavigation = !_isShowingNavigation;
    notifyListeners();
  }
}
