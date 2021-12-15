import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/session.dart';

class CodeModel extends JadeModel {
  static Widget getIcon() => Transform.rotate(
        angle: 270 * pi / 180,
        child: const Icon(Icons.view_sidebar_outlined),
      );
  static String getTitle() => 'Code Browser';

  final Session _session;

  CodeModel(this._session);

  @override
  void updateState() async {
    // TODO: _result = await _session.execute(code);
    notifyListeners();
  }
}
