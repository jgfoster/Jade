// SessionListWidget has an ExpansionPanelList with
// children for each window into that session
//
// See https://github.com/flutter/flutter/issues/13780 for
// _children[j] is MaterialGap is not true error.

import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/session.dart';
import 'package:jade/model/session_list.dart';
import 'package:jade/view/session_child_tile.dart';
import 'package:provider/provider.dart';

class SessionListWidget extends StatefulWidget {
  const SessionListWidget({Key? key}) : super(key: key);

  @override
  State<SessionListWidget> createState() => _SessionListWidget();
}

// Holds ephemeral state: is list expanded
class _SessionListWidget extends State<SessionListWidget> {
  final List<bool> _isSessionExpanded = [];

  Widget _sessionDetailsBuilder(var context, var session, var child) {
    final widgets = <Widget>[];
    session.children.forEach((each) {
      widgets.add(SessionChildTile(each));
    });
    return Column(
      children: widgets,
    );
  }

  ExpansionPanel _expansionPanel(Session session, bool isExpanded, int index) {
    return ExpansionPanel(
      isExpanded: isExpanded,
      canTapOnHeader: true,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return GestureDetector(
          child: ListTile(
            title: Text('Session ${index + 1}'),
          ),
          onTap: () {
            session.beSelected();
          },
        );
      },
      body: ChangeNotifierProvider.value(
        value: session,
        child: Consumer<Session>(builder: _sessionDetailsBuilder),
      ),
    );
  }

  Widget _builder(var context, var sessionList, var child) {
    while (_isSessionExpanded.length < sessionList.length) {
      _isSessionExpanded.add(true);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isSessionExpanded[index] = !isExpanded;
          });
        },
        children: sessionList
            .map<ExpansionPanel>((session, index) =>
                _expansionPanel(session, _isSessionExpanded[index], index))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Jade().sessionList,
      child: Consumer<SessionList>(builder: _builder),
    );
  }
}
