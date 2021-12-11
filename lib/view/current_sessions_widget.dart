// CurrentSessionsWidget displays a list of the current sessions

import 'package:flutter/material.dart';
import 'package:jade/model/current_sessions.dart';
import 'package:provider/provider.dart';

class CurrentSessionsWidget extends StatefulWidget {
  final CurrentSessions _currentSessions;
  const CurrentSessionsWidget(this._currentSessions, {Key? key})
      : super(key: key);

  @override
  _CurrentSessionsWidget createState() {
    // ignore: no_logic_in_create_state
    return _CurrentSessionsWidget(_currentSessions);
  }
}

class _CurrentSessionsWidget extends State<CurrentSessionsWidget> {
  final CurrentSessions _currentSessions;

  _CurrentSessionsWidget(this._currentSessions);

  Widget _builder(var context, var currentSessions, var child) {
    var tableRows = <TableRow>[];
    var string = currentSessions.result['string'];
    string.split('\n').forEach((eachLine) {
      if (eachLine.length > 0) {
        var cells = <Widget>[];
        eachLine.split('\t').forEach((eachCell) {
          if (cells.length < 4) {
            cells.add(
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(eachCell),
              ),
            );
          }
        });
        tableRows.add(TableRow(children: cells));
      }
    });

    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: tableRows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _currentSessions,
      child: Consumer<CurrentSessions>(builder: _builder),
    );
  }
}
