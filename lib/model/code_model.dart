import 'package:flutter/material.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/session.dart';

class CodeModel extends JadeModel {
  final Session _session;

  get title => const Text('Code Browser');

  CodeModel(this._session);

  @override
  void selectionStatusChanged() async {
    // _result = await _session.execute(code);
    notifyListeners();
  }

  @override
  void removeFromParent() {
    _session.removeChild(this);
  }
}
