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

  get address => _address;
  get username => _username;
  get version => _version;
  get isLoggedIn => _isLoggedIn;

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
      print('about to try to login to ${login.address}');
      _session = await _server.login(login.username, login.password);
      _isLoggedIn = true;
      print('successful login of $_session');
    } catch (ex) {
      _isLoggedIn = true;
      print('exception on login: $ex');
    }
    notifyListeners();
  }

  void logout() async {
    await _server.logout(_session);
    print('Returned from _server.logout()');
    notifyListeners();
  }

  @override
  void selectionStatusChanged() {
    notifyListeners();
  }
}
