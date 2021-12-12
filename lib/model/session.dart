import 'package:flutter/material.dart';
import 'package:jade/model/current_sessions.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/jade_server.dart';

class Session extends JadeModel {
  late String _session;
  late JadeServer _server;
  final String _address;
  final String _username;
  var _password = '?';
  var _version = '?';
  var _isLoggedIn = false;
  final _children = <JadeModel>[];
  late Stream<String> serverEvents;

  get address => _address;
  get isLoggedIn => _isLoggedIn;
  @override
  get mayRemoveFromParent => false;
  get title => const Text('Transcript');
  get username => _username;
  get version => _version;
  get children => _children;

  Session(this._address, this._username, this._password) {
    _server = JadeServer(_address);
    serverEvents = _server.stream;
  }

  Future<void> doLogin(var client) async {
    client('${DateTime.now()} - Initiating connection to server');
    _version = await _server.getGciVersion();
    client('${DateTime.now()} - Server version = $_version');
    try {
      _session = await _server.login(_username, _password);
      _password = '?';
      _isLoggedIn = true;
    } catch (ex) {
      _isLoggedIn = false;
    }
    _children.add(this);
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
