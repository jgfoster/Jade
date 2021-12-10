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
  final double _width;
  final double _height;
  const TranscriptWidget(this._session, this._width, this._height, {Key? key})
      : super(key: key);

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
  var _expression = 'System session.';
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
    return Column(
      children: const [
        Text('Transcript'),
        SizedBox(
          height: 150,
          child: TextField(
            minLines: 10,
            maxLines: null,
            readOnly: false,
          ),
        ),
      ],
    );
  }

  Widget _workspaceWidget() {
    return Column(
      children: const [
        Text('Workspace'),
        SizedBox(
          height: 150,
          child: TextField(
            minLines: 10,
            maxLines: null,
            readOnly: false,
          ),
        ),
      ],
    );
  }

  Widget _queryWidget() {
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
      onFieldSubmitted: (_) async {
        var map = await _session.execute(_expression);
        setState(() {
          _result = map.toString();
        });
      },
      onSaved: (value) => _expression = value!,
    );
  }

  Widget _resultWidget() {
    return Text(_result);
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
            const Divider(height: 1, thickness: 1),
            _workspaceWidget(),
            const Divider(height: 1, thickness: 1),
            _queryWidget(),
            _resultWidget(),
          ],
        ),
      ),
    );
  }

  // our parent offers an infinite extent so we need to specify a size
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
