import 'package:flutter/material.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/session.dart';

class BrowserModel extends JadeModel {
  final Session _session;
  // Map<String, dynamic> _result = {'string': ''};

  // get result => _result;
  get title => const Text('Browser');

  BrowserModel(this._session) {
    // _session.execute(_doSetup);
  }

  @override
  void selectionStatusChanged() async {
    notifyListeners();
  }
}
