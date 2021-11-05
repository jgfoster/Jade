import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import 'navigation.dart';

class Jade with ChangeNotifier {}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Jade(),
      child: const JadeApp(),
    ),
  );
}

class JadeApp extends StatelessWidget {
  const JadeApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jade', // web tab
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const JadeHomePage(),
    );
  }
}

class JadeHomePage extends StatefulWidget {
  const JadeHomePage({Key? key}) : super(key: key);

  @override
  State<JadeHomePage> createState() => _JadeHomePageState();
}

// Holds ephemeral state, including whether the navigation drawer is visible
class _JadeHomePageState extends State<JadeHomePage> {
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
        title: const Text('Jade IDE for GemStone/S'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New login...',
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          _isShowingNavigation ? const Navigation() : Container(),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          const Expanded(child: LoginForm()),
        ],
      ),
    );
  }
}
