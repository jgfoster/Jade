// HomePage uses Scaffold to show
// Navigation (a Drawer) and a SelectedModelForm

import 'package:flutter/material.dart';
import 'package:jade/view/navigation.dart';
import 'package:jade/view/selected_model_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

// Holds ephemeral state: whether the navigation drawer is visible
class _HomePage extends State<HomePage> {
  bool _isShowingNavigation = true;

  Widget drawerIcon() {
    return IconButton(
      icon: const Icon(Icons.menu),
      tooltip: _isShowingNavigation
          ? 'Close navigation drawer'
          : 'Open navigation drawer',
      onPressed: () {
        setState(() {
          _isShowingNavigation = !_isShowingNavigation;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 36,
        leading: drawerIcon(),
        title: const Text('Jade — an IDE for GemStone/S 64 Bit'),
      ),
      body: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _isShowingNavigation ? const Navigation() : Container(),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          const SelectedModelWidget(),
        ],
      ),
    );
  }
}
