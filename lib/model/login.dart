import 'package:jade/model/jade.dart';
import 'package:jade/model/jade_model.dart';

class Login extends JadeModel {
  String _address = 'localhost:50378';
  String _username = 'DataCurator';
  String _password = 'swordfish';

  get address => _address;

  set address(var aString) {
    if (_address != aString) {
      _address = aString;
      notifyListeners();
    }
  }

  get username => _username;

  set username(var aString) {
    if (_username != aString) {
      _username = aString;
      notifyListeners();
    }
  }

  get password => _password;

  set password(var aString) {
    if (_password != aString) {
      _password = aString;
      notifyListeners();
    }
  }

  @override
  void removeFromParent() {
    Jade().loginList.remove(this);
  }
}
