import 'package:flutter/material.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/login.dart';
import 'package:jade/model/login_list.dart';

class Jade with ChangeNotifier {
  static final Jade _jade = Jade._internal();
  final LoginList loginList = LoginList();
  JadeModel? _selectedModel;

  factory Jade() => _jade;

  Jade._internal() {
    // let the constructor finish so that _jade is assigned
    // otherwise we end up in an endless loop!
    Future.microtask(() => newLogin());
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
