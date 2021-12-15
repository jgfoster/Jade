// TranscriptWidget is displayed when a session is selected
// and displays a row of action buttons (commit, open session list, ...)
// followed by a transcript and REPL prompt

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jade/model/jade_server_abstract.dart';
import 'package:jade/model/session.dart';
import 'package:jade/view/open_nav_drawer.dart';
import 'package:provider/provider.dart';

class TranscriptWidget extends StatefulWidget {
  final Session _session;
  const TranscriptWidget(this._session, {Key? key}) : super(key: key);

  @override
  _TranscriptWidget createState() {
    return _TranscriptWidget();
  }
}

class _TranscriptWidget extends State<TranscriptWidget> {
  late Session? _session;
  final _formKey = GlobalKey<FormState>();
  final _queryController = TextEditingController();
  var _expression = 'System session';
  final _transcript = StringBuffer();

  // Set up notification for changes to session
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget._session,
      child: Consumer<Session>(builder: _builder),
    );
  }

  // Show buttons, info, Transcript, and REPL prompt
  Widget _builder(var context, var session, var child) {
    _session = session;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Form(
          key: _formKey,
          child: Column(
            // each child is offered an infinite height
            children: <Widget>[
              _header(),
              // _infoLine(),
              const Divider(height: 1, thickness: 1),
              Expanded(child: _transcriptWidget()),
              _promptWidget(),
            ],
          ),
        );
      },
    );
  }

  Widget _header() {
    return Row(
      // each child is offered an infinite width
      children: [
        const OpenNavDrawer(),
        _commitButton(),
        _sessionListButton(),
        _codeBrowserButton(),
        _workspaceButton(),
        _loginInfo(),
        _abortButton(),
        _logoutButton(),
      ],
    );
  }

  Widget _commitButton() {
    return IconButton(
      icon: const Icon(Icons.photo_camera_outlined),
      tooltip: 'Commit transaction',
      onPressed: () async {
        var result = await _session!.commit();
        setState(() {
          _transcript.writeln(
              '> System commit; commitRecordPageForSessionId: System session');
          _transcript.writeln(result['result']);
        });
      },
    );
  }

  Widget _sessionListButton() {
    return IconButton(
      icon: const Icon(Icons.format_list_numbered),
      tooltip: 'Show session list',
      onPressed: () {
        _session!.showSessionList();
      },
    );
  }

  Widget _codeBrowserButton() {
    return // Open code browser
        IconButton(
      icon: Transform.rotate(
        angle: 270 * pi / 180,
        child: const Icon(Icons.view_sidebar_outlined),
      ),
      tooltip: 'Open code browser',
      onPressed: () {
        _session!.openCodeBrowser();
      },
    );
  }

  Widget _workspaceButton() {
    return IconButton(
      icon: const Icon(Icons.article_outlined),
      tooltip: 'Open workspace',
      onPressed: () {
        // print('Open workspace');
      },
    );
  }

  Widget _loginInfo() {
    return Expanded(
      child: Align(
        // alignment: Alignment.center,
        child: Text('${_session!.username} on ${_session!.address} '
            '(${_session!.version.split(' ')[0]})'),
      ),
    );
  }

  Widget _abortButton() {
    return IconButton(
      icon: const Icon(Icons.delete_outlined),
      tooltip: 'Abort transaction',
      onPressed: () async {
        var result = await _session!.abort();
        setState(() {
          _transcript.writeln(
              '> System abortTransaction; commitRecordPageForSessionId: System session');
          _transcript.writeln(result['result']);
        });
      },
    );
  }

  Widget _logoutButton() {
    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Logout',
      onPressed: () {
        _session!.logout();
      },
    );
  }

  Widget _transcriptWidget() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return TextField(
          minLines: (constraints.maxHeight ~/ 19),
          maxLines: null,
          readOnly: true,
          controller: TextEditingController(text: _transcript.toString()),
        );
      },
    );
  }

  Widget _promptWidget() {
    _queryController.text = _expression;
    _queryController.addListener(() {
      _expression = _queryController.text;
    });
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        autofocus: true,
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
          try {
            var map = await _session!.execute(_expression);
            setState(() {
              _transcript.writeln('> $_expression');
              _transcript.writeln(map['result']);
            });
          } on GciError catch (ex) {
            // TODO: terminate process
            setState(() {
              _transcript.writeln('> $_expression');
              _transcript.writeln(ex.message);
            });
          }
        },
        onSaved: (value) => _expression = value!,
      ),
    );
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }
}
