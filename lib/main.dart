import 'package:flutter/material.dart';

import 'features/pages/welcome_page/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

// Root app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LearnBridge',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WelcomePage(onContinue: () {}),
      routes: {},
    );
  }
}
