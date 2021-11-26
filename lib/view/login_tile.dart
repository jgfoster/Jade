// LoginTile shows the name of a login, its selected state,
// and allows for selecting and removing of the Login

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/login.dart';

class LoginTile extends ListTile {
  final Login _login;
  const LoginTile(this._login, {Key? key}) : super(key: key);

  Widget _loginTile(context, login, child) {
    return ListTile(
      dense: true,
      selected: login.isSelected,
      leading: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          Jade().loginList.remove(login);
        },
      ),
      title: Text('${_login.username} at ${login.address}'),
      onTap: () {
        login.beSelected();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _login,
      child: Consumer<Login>(
        builder: _loginTile,
      ),
    );
  }
}
