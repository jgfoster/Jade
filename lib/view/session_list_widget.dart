import 'package:flutter/material.dart';

class SessionListWidget extends StatefulWidget {
  const SessionListWidget({Key? key}) : super(key: key);

  @override
  State<SessionListWidget> createState() => _SessionListWidget();
}

// Holds ephemeral state
class _SessionListWidget extends State<SessionListWidget> {
  bool _isSessionListExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _isSessionListExpanded = !isExpanded;
            });
          },
          children: [
            ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: _isSessionListExpanded,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return const ListTile(
                  title: Text('Session 1'),
                );
              },
              body: Column(
                children: [
                  ListTile(
                    dense: true,
                    // autofocus: true,
                    title: const Text('Transcript'),
                    onTap: () {
                      // print('Tapped on Transcript');
                    },
                  ),
                  ListTile(
                    dense: true,
                    selected: true,
                    title: const Text('Workspace 1'),
                    onTap: () {
                      // print('Tapped on Workspace 1');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
