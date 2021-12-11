// TranscriptWidget is displayed when a session is selected
// and displays a row of action buttons (commit, open session list, ...)
// followed by a transcript and a workspace

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/session.dart';
import 'package:provider/provider.dart';

class TranscriptWidget extends StatefulWidget {
  final Session _session;
  const TranscriptWidget(this._session, {Key? key}) : super(key: key);

  @override
  _TranscriptWidget createState() {
    // ignore: no_logic_in_create_state
    return _TranscriptWidget(_session);
  }
}

class _TranscriptWidget extends State<TranscriptWidget> {
  final Session _session;
  final _formKey = GlobalKey<FormState>();
  final _queryController = TextEditingController();
  var _expression = 'System session';
  String _result = '';

  _TranscriptWidget(this._session);

  Widget _infoLine() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        '${_session.username} on ${_session.address} '
        '(${_session.version.split(' ')[0]})',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _buttonRow() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.photo_camera_outlined),
          tooltip: 'Commit transaction',
          onPressed: () async {
            var result = await _session.commit();
            setState(() {
              _result =
                  'After commit current commit record = ${result['result'].toString()}';
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.format_list_numbered),
          tooltip: 'Show session list',
          onPressed: () {
            _session.showSessionList();
          },
        ),
        IconButton(
          icon: Transform.rotate(
            angle: 270 * pi / 180,
            child: const Icon(Icons.view_sidebar_outlined),
          ),
          tooltip: 'Open code browser',
          onPressed: () {
            // print('pressed commit button');
          },
        ),
        IconButton(
          icon: const Icon(Icons.article_outlined),
          tooltip: 'Open workspace',
          onPressed: () {
            // print('pressed commit button');
          },
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.delete_outlined),
              tooltip: 'Abort transaction',
              onPressed: () async {
                var result = await _session.abort();
                setState(() {
                  _result =
                      'After abort current commit record = ${result['result'].toString()}';
                });
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () {
            Jade().doLogout(_session);
          },
        ),
      ],
    );
  }

  Widget _transcriptWidget() {
    return const TextField(
      minLines: null,
      maxLines: null,
      readOnly: false,
    );
  }

  Widget _queryWidget() {
    _queryController.text = _expression;
    _queryController.addListener(() {
      _expression = _queryController.text;
    });
    return TextFormField(
      decoration: const InputDecoration(
        hintText: '2 + 3',
        labelText: 'Transcript show:',
      ),
      controller: _queryController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an expression';
        }
        return null;
      },
      onFieldSubmitted: (_) async {
        var map = await _session.execute(_expression);
        setState(() {
          _result = map.toString();
        });
      },
      onSaved: (value) => _expression = value!,
    );
  }

  Widget _builder(var context, var session, var child) {
    return Form(
      key: _formKey,
      child: Container(
        width: 490,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            _buttonRow(),
            _infoLine(),
            const Divider(height: 1, thickness: 1),
            _transcriptWidget(),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter, child: _queryWidget())),
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
