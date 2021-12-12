import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/login.dart';
import 'package:jade/model/session.dart';
import 'unused.dart' if (dart.library.html) 'dart:html' as html;

class LoginForm extends StatefulWidget {
  final Login _login;
  const LoginForm(this._login, {Key? key}) : super(key: key);

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late Login _login;
  get login => _login;
  final _addressController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isInLogin = false;

  @override
  Widget build(BuildContext context) {
    _login = widget._login;
    return Form(
      key: _formKey,
      child: Column(
        // each child is offered an infinite height
        children: <Widget>[
          _addressWidget(),
          _usernameWidget(),
          _passwordWidget(),
          _buttonRow(),
        ],
      ),
    );
  }

  Widget _addressWidget() {
    _addressController.text = _login.address;
    _addressController.addListener(() {
      _login.address = _addressController.text;
    });
    return TextFormField(
      enabled: !_isInLogin,
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
      enabled: !_isInLogin,
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
      enabled: !_isInLogin,
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
        onPressed: _isInLogin ? null : () => _doLogin(),
        child: Row(
          // each child is offered an infinite width
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
          // each child is offered an infinite width
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

  void _doLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isInLogin = true;
      });
      _formKey.currentState!.save();
      var session = Session(_login.address, _login.username, _login.password);
      session.serverEvents.listen((event) {
        print(event);
      });
      await session.doLogin((status) {
        print(status);
      });
      // await Future.delayed(const Duration(milliseconds: 2000));
      setState(() {
        _isInLogin = false;
      });
      Jade().addSession(session);
    }
  }

  void _doOpen() {
    // var url = Uri.base.path;
    var features = 'width=800,height=600';
    html.window.open('https://www.google.com/', 'new browser', features);
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
