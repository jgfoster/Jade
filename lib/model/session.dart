import 'package:flutter/material.dart';
import 'package:jade/model/current_sessions.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/jade_server.dart';
import 'package:jade/model/login.dart';

class Session extends JadeModel {
  late String _session;
  late JadeServer _server;
  var _address = '?';
  var _username = '?';
  var _version = '?';
  var _isLoggedIn = false;
  final _children = <JadeModel>[];

  get address => _address;
  get isLoggedIn => _isLoggedIn;
  @override
  get mayRemoveFromParent => false;
  get title => const Text('Transcript');
  get username => _username;
  get version => _version;
  get children => _children;

  Session(Login login) {
    _initialize(login);
    _children.add(this);
  }

  void _initialize(Login login) async {
    _address = login.address;
    _username = login.username;
    _server = JadeServer(login.address);
    _version = await _server.getGciVersion();
    notifyListeners();
    try {
      _session = await _server.login(login.username, login.password);
      _isLoggedIn = true;
    } catch (ex) {
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  void logout() async {
    await _server.logout(_session);
    notifyListeners();
  }

  @override
  void selectionStatusChanged() {
    notifyListeners();
  }

  Future<Map<String, dynamic>> abort() async {
    return execute(
        'System abortTransaction; commitRecordPageForSessionId: System session');
  }

  Future<Map<String, dynamic>> begin() async {
    return execute(
        'System beginTransaction; commitRecordPageForSessionId: System session');
  }

  Future<Map<String, dynamic>> commit() async {
    return execute(
        'System commit; commitRecordPageForSessionId: System session');
  }

  Future<Map<String, dynamic>> execute(String string) async {
    await _server.execute(_session, string);
    return _server.nbResult(_session);
  }

  void removeChild(var child) {
    if (child.isSelected) {
      child.beNotSelected();
      beSelected();
    }
    _children.remove(child);
    notifyListeners();
  }

  void showSessionList() {
    int index =
        _children.indexWhere((each) => each.runtimeType == CurrentSessions);
    late JadeModel model;
    if (index >= 0) {
      model = _children[index];
    } else {
      model = CurrentSessions(this);
      _children.add(model);
    }
    model.beSelected();
    notifyListeners();
  }
}
