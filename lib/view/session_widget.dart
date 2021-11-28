// SessionWidget displays a single session

import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/session.dart';
import 'package:provider/provider.dart';

class SessionWidget extends StatefulWidget {
  final Session _session;
  const SessionWidget(this._session, {Key? key}) : super(key: key);

  @override
  _SessionWidget createState() {
    return _SessionWidget();
  }
}

class _SessionWidget extends State<SessionWidget> {
  final _formKey = GlobalKey<FormState>();
  final _queryController = TextEditingController();
  var _expression = '2 + 3.';

  Widget _topRow(Session session) {
    return Row(
      children: [
        Text('${session.username} on ${session.address} '
            '(${session.version.split(' ')[0]})'),
        IconButton(
          icon: const Icon(Icons.photo_camera),
          tooltip: 'Commit transaction',
          onPressed: () {
            // print('pressed commit button');
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Abort transaction',
          onPressed: () {
            // print('pressed abort button');
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () {
            Jade().doLogout(session);
          },
        ),
      ],
    );
  }

  Widget _queryWidget(Session session) {
    _queryController.text = _expression;
    _queryController.addListener(() {
      _expression = _queryController.text;
    });
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.account_circle),
        hintText: '2 + 3',
        labelText: 'Smalltalk Expression',
      ),
      controller: _queryController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an expression';
        }
        return null;
      },
      onFieldSubmitted: (_) => session.execute(_expression),
      onSaved: (value) => _expression = value!,
    );
  }

  Widget _resultWidget(Session session) {
    return Text('Result: ${session.result}');
  }

  Widget _builder(var context, var session, var child) {
    return Form(
      key: _formKey,
      child: Container(
        width: 490,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: <Widget>[
            _topRow(session),
            _queryWidget(session),
            _resultWidget(session),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget._session,
      child: Consumer<Session>(builder: _builder),
    );
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }
}
