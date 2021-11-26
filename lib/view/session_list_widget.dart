// SessionListWidget has an ExpansionPanelList with
// children for each window into that session
//
//

import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/session_list.dart';
// import 'package:jade/view/login_tile.dart';
import 'package:provider/provider.dart';

class SessionListWidget extends StatefulWidget {
  const SessionListWidget({Key? key}) : super(key: key);

  @override
  State<SessionListWidget> createState() => _SessionListWidget();
}

// Holds ephemeral state: is list expanded
class _SessionListWidget extends State<SessionListWidget> {
  bool _isSessionListExpanded = true;

  Widget builder(var context, var sessionList, var child) {
    return ListView(
      children: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Jade().sessionList,
      child: Consumer<SessionList>(builder: builder),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return ListView(
  //     children: [
  //       ExpansionPanelList(
  //         expansionCallback: (int index, bool isExpanded) {
  //           setState(() {
  //             _isSessionListExpanded = !isExpanded;
  //           });
  //         },
  //         children: [
  //           ExpansionPanel(
  //             canTapOnHeader: true,
  //             isExpanded: _isSessionListExpanded,
  //             headerBuilder: (BuildContext context, bool isExpanded) {
  //               return const ListTile(
  //                 title: Text('Session 1'),
  //               );
  //             },
  //             body: Column(
  //               children: [
  //                 ListTile(
  //                   dense: true,
  //                   // autofocus: true,
  //                   title: const Text('Transcript'),
  //                   onTap: () {
  //                     // print('Tapped on Transcript');
  //                   },
  //                 ),
  //                 ListTile(
  //                   dense: true,
  //                   selected: true,
  //                   title: const Text('Workspace 1'),
  //                   onTap: () {
  //                     // print('Tapped on Workspace 1');
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
}
