import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/login.dart';

class LoginListWidget extends StatefulWidget {
  const LoginListWidget({Key? key}) : super(key: key);

  @override
  State<LoginListWidget> createState() => _LoginListWidget();
}

// Holds ephemeral state
class _LoginListWidget extends State<LoginListWidget> {
  bool _isLoginListExpanded = true;
  var loginList = Jade().loginList;

  _LoginListWidget() {
    loginList.addListener(_changeListener);
  }

  @override
  void deactivate() {
    loginList.removeListener(_changeListener);
    super.deactivate();
  }

  void _changeListener() {
    setState(() {});
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
        setState(() {
          for (var login in loginList) {
            login.isSelected = false;
          }
          each.isSelected = true;
        });
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

  @override
  Widget build(BuildContext context) {
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
}
