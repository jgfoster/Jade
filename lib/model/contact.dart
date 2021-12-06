import 'package:flutter/material.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/session.dart';

class Contact extends JadeModel {
  final Session _session;
  // Map<String, dynamic> _result = {'string': ''};

  // get result => _result;
  get title => const Text('Contact');

  Contact(this._session) {
    // _session.execute(_doSetup);
  }

  @override
  void selectionStatusChanged() async {
    notifyListeners();
  }
}
