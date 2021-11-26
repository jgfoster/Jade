import 'package:flutter/material.dart';
import 'package:jade/model/login.dart';

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
  var _isInLogin = false;
  final _addressController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _doLogin() {
    if (_isInLogin | !_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isInLogin = true;
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Login to ${_login.address} as ${_login.username} with ${_login.password.length}'),
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
      onFieldSubmitted: _isInLogin ? null : (_) => _doLogin(),
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
      onFieldSubmitted: _isInLogin ? null : (_) => _doLogin(),
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
      onFieldSubmitted: _isInLogin ? null : (_) => _doLogin(),
      onSaved: (value) => _login.password = value!,
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
    _login = widget._login;
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
