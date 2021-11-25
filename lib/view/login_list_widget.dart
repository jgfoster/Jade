// LoginListWidget uses an ExpansionPanelList to show the
// current logins. This has a ChangeNotificationProvider
// to monitor adding and removing logins from the list.
// The LoginTile monitors the state of the Login itself.

import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/login.dart';
import 'package:jade/view/login_tile.dart';
import 'package:provider/provider.dart';

class LoginListWidget extends StatefulWidget {
  const LoginListWidget({Key? key}) : super(key: key);

  @override
  State<LoginListWidget> createState() => _LoginListWidget();
}

// Holds ephemeral state expansion state
class _LoginListWidget extends State<LoginListWidget> {
  bool _isLoginListExpanded = true;

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

  ExpansionPanel loginListExpansionPanel(LoginList loginList) {
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
          ...loginList.map<ListTile>((each) => LoginTile(each)).toList(),
          addLoginTile(),
        ],
      ),
    );
  }

  Widget builder(var context, var loginList, var child) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isLoginListExpanded = !isExpanded;
        });
      },
      children: [loginListExpansionPanel(loginList)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Jade().loginList,
      child: Consumer<LoginList>(builder: builder),
    );
  }
}
