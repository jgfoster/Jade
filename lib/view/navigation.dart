// Navigation shows a Drawer with the
// SessionListWidget and the LoginsListWidget

import 'package:flutter/material.dart';
import 'package:jade/view/login_list_widget.dart';
import 'package:jade/view/session_list_widget.dart';

class Navigation extends StatelessWidget {
  const Navigation({Key? key}) : super(key: key);

  // our parent offers an infinite extent so we need to specify a size
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const SessionListWidget(),
          const LoginListWidget(),
          Container(),
        ],
      ),
    );
  }
}
