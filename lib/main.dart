import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Jade with ChangeNotifier {}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Jade(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jade', // web tab
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: const Text('Jade IDE for GemStone/S'),
        actions: [
          Icon(Icons.more_vert),
        ],
      ),
      body: Row(
        children: [
          Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
