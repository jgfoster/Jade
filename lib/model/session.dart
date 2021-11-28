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
  var _result = '??';

  get address => _address;
  get username => _username;
  get version => _version;
  get isLoggedIn => _isLoggedIn;
  get result => _result;

  Session(Login login) {
    _initialize(login);
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
      _isLoggedIn = true;
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

  void execute(String string) async {
    await _server.execute(_session, string);
    var result = await _server.nbResult(_session);
    _result = result.toString();
    notifyListeners();
  }
}
