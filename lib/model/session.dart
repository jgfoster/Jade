import 'package:jade/model/jade_model.dart';
import 'package:jade/model/jade_server.dart';
import 'package:jade/model/login.dart';

class Session extends JadeModel {
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
    return _session.hashCode;
  }

  @override
  void selectionStatusChanged() {
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return other.runtimeType == Session &&
        _session == (other as Session).session;
  }
}
