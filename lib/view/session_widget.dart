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

Widget _builder(var context, var session, var child) {
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

class _SessionWidget extends State<SessionWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget._session,
      child: Consumer<Session>(builder: _builder),
    );
  }

  @override
  void dispose() {
    // Clean up any TextController objects allocated above
    super.dispose();
  }
}
