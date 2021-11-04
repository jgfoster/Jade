import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Widget _navigation() {
    if (!_isShowingNavigation) {
      return Container();
    }
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Logins',
                  style: textTheme.headline6,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'New login...',
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Item 1'),
            selected: true,
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Item 2'),
            selected: false,
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.label),
            title: const Text('Item 3'),
            selected: false,
            onTap: () {},
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Label',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Item A'),
            selected: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }

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
          _navigation(),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
