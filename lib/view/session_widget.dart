// SessionWidget displays a single session

import 'package:flutter/material.dart';
import 'package:jade/model/session.dart';

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
  late Session _session;

  @override
  Widget build(BuildContext context) {
    _session = widget._session;
    return const Text('hello');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }
}
