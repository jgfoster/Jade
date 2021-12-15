// Navigation shows a Drawer with the
// SessionListWidget and the LoginsListWidget

import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/view/login_list_widget.dart';
import 'package:jade/view/session_list_widget.dart';

class Navigation extends StatelessWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _header(context),
          const SessionListWidget(),
          const LoginListWidget(),
          Container(),
        ],
      ),
    );
  }

  Widget _header(context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.menu),
      title: Text(
        'Navigation',
        style: Theme.of(context).textTheme.headline6,
      ),
      onTap: () {
        Jade().toggleIsShowingNavigation();
      },
    );
  }
}
