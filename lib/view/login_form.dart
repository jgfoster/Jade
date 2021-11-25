import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  var _address = '';
  var _username = '';
  var _password = '';
  var _isInLogin = false;

  void _doLogin() {
    if (_isInLogin | !_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isInLogin = true;
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Login to $_address as $_username with ${_password.length}'),
        ),
      );
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isInLogin = false;
      });
    });
  }

  Widget _addressWidget() {
    return TextFormField(
      enabled: !_isInLogin,
      decoration: const InputDecoration(
        icon: Icon(Icons.storage),
        hintText: 'localhost:50378',
        labelText: 'Host:port *',
      ),
      controller: TextEditingController()..text = 'localhost:50378',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        var pieces = value.split(':');
        if (pieces.length != 2) {
          return 'Please enter hostname:port (including a single \':\' as separator)';
        }
        var host = pieces[0];
        var validIpAddressRegex = RegExp(
            '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\$');
        var validHostnameRegex = RegExp(
            '^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])\$');
        if (!(validIpAddressRegex.hasMatch(host) |
            validHostnameRegex.hasMatch(host))) {
          return 'Please enter a valid IP address or host name';
        }
        return null;
      },
      onFieldSubmitted: _isInLogin ? null : (_) => _doLogin(),
      onSaved: (value) => _address = value!,
    );
  }

  Widget _usernameWidget() {
    return TextFormField(
      enabled: !_isInLogin,
      decoration: const InputDecoration(
        icon: Icon(Icons.account_circle),
        hintText: 'DataCurator',
        labelText: 'Username *',
      ),
      controller: TextEditingController()..text = 'DataCurator',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a GemStone user';
        }
        return null;
      },
      onFieldSubmitted: _isInLogin ? null : (_) => _doLogin(),
      onSaved: (value) => _username = value!,
    );
  }

  Widget _passwordWidget() {
    return TextFormField(
      enabled: !_isInLogin,
      decoration: const InputDecoration(
        icon: Icon(Icons.password),
        labelText: 'Password *',
      ),
      obscureText: true,
      controller: TextEditingController()..text = 'swordfish',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid password';
        }
        return null;
      },
      onFieldSubmitted: _isInLogin ? null : (_) => _doLogin(),
      onSaved: (value) => _password = value!,
    );
  }

  Widget _loginButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: _isInLogin ? null : () => _doLogin(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(Icons.login),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonRow() {
    return Container(
      // width: 500,
      height: 45,
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        itemExtent: 120.0,
        children: [
          _loginButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: 490,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: <Widget>[
            _addressWidget(),
            _usernameWidget(),
            _passwordWidget(),
            _buttonRow(),
          ],
        ),
      ),
    );
  }
}
