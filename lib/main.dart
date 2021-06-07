import 'package:flutter/material.dart';
import 'package:smartdriver/pages/home.dart';

void main() {
  runApp(SmartDriver());
}

class SmartDriver extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'smartdriver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(title: 'smartdriver'),
    );
  }
}

