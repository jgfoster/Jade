import 'package:flutter/material.dart';
import 'package:jade/model/code_model.dart';
import 'package:jade/model/current_sessions.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/jade_server.dart';
import 'package:jade/model/jade_server_abstract.dart';

class Session extends JadeModel {
  static Widget getIcon() => const Icon(Icons.person_outline);
  static String getTitle() => 'Transcript';

  late String _session;
  late JadeServer _server;
  final String _address;
  final String _username;
  final String _password;
  late String _version;
  var _isLoggedIn = false;
  final _children = <JadeModel>[];

  get address => _address;
  get isLoggedIn => _isLoggedIn;
  get username => _username;
  get version => _version;
  get children => _children;

  Session(this._address, this._username, this._password) {
    _server = JadeServer(_address);
  }

  Future<void> doLogin(var client) async {
    client('${DateTime.now()} - Initiating connection to server');
    _version = await _server.getGciVersion();
    client('${DateTime.now()} - Server version = ${_version.split(' ')[0]}');
    _session = await _server.login(_username, _password);
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() async {
    try {
      await _server.logout(_session);
    } on GciError {
      // ignore this!
    }

    Jade().removeSession(this);
    notifyListeners();
  }

  @override
  void updateState() {
    // notifyListeners();
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
      Jade().selectModel(this);
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

  void openCodeBrowser() {
    late JadeModel model;
    model = CodeModel(this);
    _children.add(model);
    model.beSelected();
    notifyListeners();
  }
}
