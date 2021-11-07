import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:jade/model/jade.dart';
import 'package:jade/view/home_page.dart';

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
      home: const HomePage(),
    );
  }
}
