import 'package:flutter/material.dart';
import 'package:jade/model/jade_server.dart';
import 'package:jade/model/login.dart';

class Session with ChangeNotifier {
  late String _session;
  late JadeServer _server;

  Session(Login login) {
    _initialize(login);
  }

  void _initialize(Login login) async {
    _server = JadeServer(login.address);
    try {
      _session = await _server.login(login.username, login.password);
    } catch (ex) {
      // print(ex);
    }
  }

  get session => _session;

  @override
  int get hashCode {
    return session.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType == Session) {
      var rhs = other as Session;
      return session == rhs.session;
    }
    return false;
  }
}
