// HomePage uses Scaffold to show
// Navigation (a Drawer) and a SelectedModelForm

import 'dart:math';

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
  final _toolBarHeight = 36.0;
  final _drawerWidth = 200.0;
  bool _isShowingNavigation = true;

  // Scaffold with AppBar and body
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _toolBarHeight,
        leading: _drawerIcon(),
        title: const Text('Jade — an IDE for GemStone/S 64 Bit'),
      ),
      body: _constrainedBox(),
    );
  }

  // Minimum app size is 800x600
  Widget _constrainedBox() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // The InteractiveViewer allows us to support children that are larger
        // than the window in which it is displayed. Otherwise, a web browser
        // that is resized smaller by the user can cause overflows.
        return InteractiveViewer(
          constrained: false, // the child is allowed to be larger
          scaleEnabled: false,
          child: SizedBox(
            width: max(800, constraints.maxWidth),
            height: max(600 - _toolBarHeight, constraints.maxHeight),
            child: _drawerAndSelection(),
          ),
        );
      },
    );
  }

  // Navigation drawer and selection editor/viewer
  Widget _drawerAndSelection() {
    if (_isShowingNavigation) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // each child is offered an infinite width
            children: [
              SizedBox(
                width: _drawerWidth - 1,
                child: const Navigation(),
              ),
              const VerticalDivider(
                width: 1,
                thickness: 1,
              ),
              SizedBox(
                width: constraints.maxWidth - _drawerWidth,
                child: const SelectedModelWidget(),
              ),
            ],
          );
        },
      );
    } else {
      return const SelectedModelWidget();
    }
  }

  Widget _drawerIcon() {
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
}
