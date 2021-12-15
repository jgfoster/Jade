// SessionTile shows the name of a session, its selected state,
// and allows for selecting and removing of the Session

import 'package:flutter/material.dart';
import 'package:jade/model/jade_model.dart';
import 'package:provider/provider.dart';

class SessionChildTile extends ListTile {
  final JadeModel _model;
  const SessionChildTile(this._model, {Key? key}) : super(key: key);

  get model => _model;

  Widget _sessionChildTile(context, model, child) {
    return ListTile(
      dense: true,
      selected: model.isSelected,
      title: Text(model.title),
      onTap: () => model.beSelected(),
      leading: model.icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<JadeModel>(
        builder: _sessionChildTile,
      ),
    );
  }
}
