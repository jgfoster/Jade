import 'package:flutter/material.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/login.dart';
import 'package:jade/model/login_list.dart';
import 'package:jade/model/session.dart';
import 'package:jade/model/session_list.dart';

class Jade with ChangeNotifier {
  static Jade? _jade;
  final LoginList loginList = LoginList();
  final SessionList sessionList = SessionList();
  JadeModel? _selectedModel;

  factory Jade() {
    if (_jade == null) {
      // assign variable before proceeding so that
      // subsequent calls find something
      _jade ??= Jade._();
      _jade!.newLogin();
    }
    return _jade!;
  }

  Jade._();

  void doLogin(Login login) {
    var session = Session(login);
    sessionList.add(session);
    session.beSelected();
  }

  void newLogin() {
    loginList.add(Login());
  }

  JadeModel? get selectedModel => _selectedModel;

  set selectedModel(JadeModel? login) {
    if (_selectedModel != login) {
      var priorSelection = _selectedModel;
      _selectedModel = login;
      priorSelection?.selectionStatusChanged();
      _selectedModel?.selectionStatusChanged();
      if (_selectedModel == null && loginList.isNotEmpty) {
        loginList.last.beSelected(); // this will come back to us!
      } else {
        notifyListeners();
      }
    }
  }
}
