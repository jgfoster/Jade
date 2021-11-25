import 'package:flutter/material.dart';

import 'package:jade/view/login_form.dart';
import 'package:jade/view/navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// Holds ephemeral state, including whether the navigation drawer is visible
class _HomePageState extends State<HomePage> {
  bool _isShowingNavigation = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: _isShowingNavigation
              ? 'Close navigation drawer'
              : 'Open navigation drawer',
          onPressed: () {
            setState(() {
              _isShowingNavigation = !_isShowingNavigation;
            });
          },
        ),
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
          const LoginForm(),
        ],
      ),
    );
  }
}
