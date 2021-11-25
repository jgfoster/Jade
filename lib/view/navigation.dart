import 'package:flutter/material.dart';
import 'package:jade/view/login_list_widget.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

// Holds ephemeral state, including which expansion tiles are expanded
class _NavigationState extends State<Navigation> {
  bool _isSessionListExpanded = true;

  Widget sessionListWidget() {
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(child: sessionListWidget()),
          const LoginListWidget(),
        ],
      ),
    );
  }
}
