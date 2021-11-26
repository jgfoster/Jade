// SessionListWidget has an ExpansionPanelList with
// children for each window into that session

import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/session.dart';
import 'package:jade/model/session_list.dart';
import 'package:provider/provider.dart';

class SessionListWidget extends StatefulWidget {
  const SessionListWidget({Key? key}) : super(key: key);

  @override
  State<SessionListWidget> createState() => _SessionListWidget();
}

// Holds ephemeral state: is list expanded
class _SessionListWidget extends State<SessionListWidget> {
  final List<bool> _isSessionExpanded = [];

  Widget _sessionDetailsBuilder(var context, var sessionList, var child) {
    return Column(
      children: const [Text('Session child')],
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
              // print('select session without expanding/contracting panel');
            },
          );
        },
        body: ChangeNotifierProvider.value(
          value: session,
          child: Consumer<Session>(builder: _sessionDetailsBuilder),
        ));
  }

  Widget _sessionBuilder(var context, var sessionList, var child) {
    while (_isSessionExpanded.length < sessionList.length) {
      _isSessionExpanded.add(true);
    }
    return ListView(children: [
      ExpansionPanelList(
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Jade().sessionList,
      child: Consumer<SessionList>(builder: _sessionBuilder),
    );
  }
}
