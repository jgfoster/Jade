// LoginListWidget uses an ExpansionPanelList to show the
// current logins. This has a ChangeNotifierProvider
// to monitor adding and removing logins from the list.
// The LoginTile monitors the state of the Login itself.

import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/login_list.dart';
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

  ExpansionPanel _expansionPanel(LoginList loginList) {
    return ExpansionPanel(
      canTapOnHeader: true,
      isExpanded: _isLoginListExpanded,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          leading: isExpanded
              ? IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add login',
                  onPressed: () {
                    Jade().newLogin();
                    if (!isExpanded) {
                      setState(() {
                        _isLoginListExpanded = true;
                      });
                    }
                  },
                )
              : Container(width: 1.0),
          title: const Text('Logins'),
        );
      },
      body: Column(
        // each child is offered an infinite height
        children: loginList.map<ListTile>((each) => LoginTile(each)).toList(),
      ),
    );
  }

  Widget _builder(var context, var loginList, var child) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isLoginListExpanded = !isExpanded;
        });
      },
      children: [_expansionPanel(loginList)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Jade().loginList,
      child: Consumer<LoginList>(builder: _builder),
    );
  }
}
