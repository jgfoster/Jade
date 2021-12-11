import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/login.dart';
import 'unused.dart' if (dart.library.html) 'dart:html' as html;

class LoginForm extends StatefulWidget {
  final Login _login;
  const LoginForm(this._login, {Key? key}) : super(key: key);

  @override
  _LoginForm createState() {
    return _LoginForm();
  }
}

class _LoginForm extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late Login _login;
  final _addressController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _doLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _formKey.currentState!.save();
        Jade().doLogin(_login);
      });
    }
  }

  void _doOpen() {
    // var url = Uri.base.path;
    var features = 'width=800,height=600';
    html.window.open('https://www.google.com/', 'new browser', features);
  }

  Widget _addressWidget() {
    _addressController.text = _login.address;
    _addressController.addListener(() {
      _login.address = _addressController.text;
    });
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.storage),
        hintText: 'localhost:50378',
        labelText: 'Host:port *',
      ),
      controller: _addressController,
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
      onFieldSubmitted: (_) => _doLogin(),
      onSaved: (value) => _login.address = value!,
    );
  }

  Widget _usernameWidget() {
    _usernameController.text = _login.username;
    _usernameController.addListener(() {
      _login.username = _usernameController.text;
    });
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.account_circle),
        hintText: 'DataCurator',
        labelText: 'Username *',
      ),
      controller: _usernameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a GemStone user';
        }
        return null;
      },
      onFieldSubmitted: (_) => _doLogin(),
      onSaved: (value) => _login.username = value!,
    );
  }

  Widget _passwordWidget() {
    _passwordController.text = _login.password;
    _passwordController.addListener(() {
      _login.password = _passwordController.text;
    });
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.password),
        labelText: 'Password *',
      ),
      obscureText: true,
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid password';
        }
        return null;
      },
      onFieldSubmitted: (_) => _doLogin(),
      onSaved: (value) => _login.password = value!,
    );
  }

  Widget _loginButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () => _doLogin(),
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

  Widget _openButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () => _doOpen(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(Icons.open_in_new),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('Open'),
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
          if (kIsWeb) _openButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _login = widget._login;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Form(
        key: _formKey,
        child: Column(
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

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _addressController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
