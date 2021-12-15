// HomePage uses Scaffold to show
// Navigation (a Drawer) and a SelectedModelForm

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/view/navigation.dart';
import 'package:jade/view/selected_model_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final _drawerWidth = 220.0;

  const HomePage({Key? key}) : super(key: key);

  // Material App Scaffold
  @override
  Widget build(BuildContext context) {
    // Material needs a top-level widget
    return Scaffold(
      body: _constrainedBox(),
    );
  }

  // Minimum size of home page is 800x600 (scroll if smaller viewport)
  Widget _constrainedBox() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // The InteractiveViewer allows us to support children that are larger
        // than the window in which it is displayed. Otherwise, a web browser
        // that is resized smaller by the user can cause overflows.
        return InteractiveViewer(
          constrained: false, // the child is allowed to be larger
          scaleEnabled: false, // no need for the user to enlarge/shrink
          child: SizedBox(
            width: max(800, constraints.maxWidth),
            height: max(600, constraints.maxHeight),
            child: _homePage(),
          ),
        );
      },
    );
  }

  // We will redraw if Jade notifies us of changes.
  // Our only real interest is the navigation drawer state.
  Widget _homePage() {
    return ChangeNotifierProvider.value(
      value: Jade(),
      child: Consumer<Jade>(builder: _builder),
    );
  }

  // Choose with or without navigation drawer
  Widget _builder(var context, var jade, var child) {
    if (jade.isShowingNavigation) {
      return _drawerAndSelection();
    } else {
      return const SelectedModelWidget();
    }
  }

  // Drawer plus selection
  Widget _drawerAndSelection() {
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
  }
}
