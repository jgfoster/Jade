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
  List<bool> _isSessionExpanded = [];

  ExpansionPanel _expansionPanel(Session session, bool isExpanded) {
    return ExpansionPanel(
      isExpanded: isExpanded,
      canTapOnHeader: true,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return const ListTile(
          title: Text('Sessions'),
        );
      },
      body: const Text('Body of session panel'),
    );
  }

  Widget _builder(var context, var sessionList, var child) {
    _isSessionExpanded = List.filled(sessionList.length, true);
    var expansionPanelList = sessionList
        .map<ExpansionPanel>((session, index) =>
            _expansionPanel(session, _isSessionExpanded[index]))
        .toList();
    return ListView(children: [
      ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isSessionExpanded[index] = !isExpanded;
          });
        },
        children: expansionPanelList,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Jade().sessionList,
      child: Consumer<SessionList>(builder: _builder),
    );
  }
}
