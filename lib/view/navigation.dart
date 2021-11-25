// Navigation shows a Drawer with the
// SessionListWidget and the LoginsListWidget

import 'package:flutter/material.dart';
import 'package:jade/view/login_list_widget.dart';
import 'package:jade/view/session_list_widget.dart';

class Navigation extends StatelessWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: const [
          Expanded(child: SessionListWidget()),
          LoginListWidget(),
        ],
      ),
    );
  }
}
