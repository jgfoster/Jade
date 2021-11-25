import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/login.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

// Holds ephemeral state, including which expansion tiles are expanded
class _NavigationState extends State<Navigation> {
  bool _isSessionListExpanded = true;
  bool _isLoginListExpanded = true;
  var loginList = Jade().loginList;

  _NavigationState() {
    loginList.addListener(() {
      setState(() {});
    });
  }

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

  ListTile loginTile(Login each) {
    return ListTile(
      dense: true,
      selected: each.isSelected,
      leading: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          loginList.remove(each);
        },
      ),
      title: Text('${each.username} at ${each.address}'),
      onTap: () {
        // print('Tapped on login');
      },
    );
  }

  ListTile addLoginTile() {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.add),
      title: const Text('Add'),
      onTap: () {
        Jade().newLogin();
      },
    );
  }

  ExpansionPanel loginListExpansionPanel() {
    return ExpansionPanel(
      canTapOnHeader: true,
      isExpanded: _isLoginListExpanded,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return const ListTile(
          title: Text('Logins'),
        );
      },
      body: Column(
        children: [
          ...loginList.map<ListTile>((each) => loginTile(each)).toList(),
          addLoginTile(),
        ],
      ),
    );
  }

  Widget loginListWidget() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isLoginListExpanded = !isExpanded;
        });
      },
      children: [
        loginListExpansionPanel(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(child: sessionListWidget()),
          loginListWidget(),
        ],
      ),
    );
  }
}
