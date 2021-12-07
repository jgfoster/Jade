// main.dart creates the MaterialApp and shows HomePage()

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jade/view/home_page.dart';
// import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:window_size/window_size.dart'
    if (dart.library.html) 'package:jade/view/unused.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowTitle('Jade — an IDE for GemStone/S 64 Bit');
  setWindowMinSize(const Size(800, 600));
  setWindowMaxSize(Size.infinite);
  runApp(const JadeApp());
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
