import 'package:flutter/material.dart';
import 'package:jade/model/contact.dart';
import 'package:jade/model/contact_list.dart';
import 'package:jade/model/current_sessions.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/jade_server.dart';
import 'package:jade/model/login.dart';

class Session extends JadeModel {
  late String _sessionID;
  late JadeServer _server;
  var _address = '?';
  var _username = '?';
  var _version = '?';
  var _isLoggedIn = false;
  final _children = <JadeModel>[];

  get address => _address;
  get isLoggedIn => _isLoggedIn;
  get title => const Text('Actions, Transcript, and Workspace');
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
      _sessionID = await _server.login(login.username, login.password);
      _isLoggedIn = true;
    } catch (ex) {
      // print(ex);
    }
    notifyListeners();
  }

  void logout() async {
    waitTillReady();
    await _server.logout(_sessionID);
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
    waitTillReady();
    await _server.execute(_sessionID, string);
    return _server.nbResult(_sessionID);
  }

  void newContact() {
    var model = Contact(this);
    _children.add(model);
    model.beSelected();
    notifyListeners();
  }

  void showContactList() {
    int index = _children.indexWhere((each) => each.runtimeType == ContactList);
    late JadeModel model;
    if (index >= 0) {
      model = _children[index];
    } else {
      model = ContactList(this);
      _children.add(model);
    }
    model.beSelected();
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

  void waitTillReady() async {
    while (!_isLoggedIn) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
    while (await _server.isCallInProgress(_sessionID)) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }
}
