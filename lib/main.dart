import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smartdriver/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
