// CurrentSessionsWidget displays a list of the current sessions

import 'package:flutter/material.dart';
import 'package:jade/model/current_sessions.dart';
import 'package:jade/view/open_nav_drawer.dart';
import 'package:provider/provider.dart';

class CurrentSessionsWidget extends StatelessWidget {
  final CurrentSessions _currentSessions;
  const CurrentSessionsWidget(this._currentSessions, {Key? key})
      : super(key: key);

  // Set up to receive notification when current session list changes
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _currentSessions,
      child: Consumer<CurrentSessions>(builder: _builder),
    );
  }

  Widget _builder(var context, var currentSessions, var child) {
    var result = currentSessions.result;
    var string = result['string'];
    // odd error condition
    if (string == null) {
      return Center(child: Text('$result'));
    }
    return Column(
      children: [
        _headerRow(context),
        Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: _tableRows(string),
        ),
      ],
    );
  }

  Widget _headerRow(context) {
    // Button row
    return Row(
      children: [
        const OpenNavDrawer(),
        _title(context),
        _closeIcon(),
      ],
    );
  }

  Widget _title(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Current Session List',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }

  Widget _closeIcon() {
    return IconButton(
      icon: const Icon(Icons.close_outlined),
      tooltip: 'Close this page',
      onPressed: () {
        _currentSessions.close();
      },
    );
  }

  List<TableRow> _tableRows(string) {
    var tableRows = <TableRow>[];
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
    return tableRows;
  }
}
