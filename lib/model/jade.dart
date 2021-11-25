import 'package:flutter/material.dart';
import 'package:jade/model/login.dart';
import 'package:jade/model/change_notifier_list.dart';

class Jade with ChangeNotifier {
  static final Jade _jade = Jade._internal();
  final ChangeNotifierList<Login> loginList = ChangeNotifierList<Login>();

  factory Jade() => _jade;

  Jade._internal() {
    newLogin();
    loginList[0].isSelected = true;
  }

  void newLogin() {
    var id = 1;
    while (loginList.any((each) => each.id == id)) {
      ++id;
    }
    var login = Login(id);
    loginList.add(login);
  }
}
