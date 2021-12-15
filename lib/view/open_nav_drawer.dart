import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';

class OpenNavDrawer extends StatelessWidget {
  const OpenNavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Jade().isShowingNavigation) {
      return Container();
    }
    return IconButton(
      icon: const Icon(Icons.menu),
      tooltip: 'Open navigation drawer',
      onPressed: () {
        Jade().toggleIsShowingNavigation();
      },
    );
  }
}
