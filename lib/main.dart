// import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:smartrider/pages/login.dart';
import 'package:smartrider/widgets/search_bar.dart';
import 'package:smartrider/pages/home.dart';
import 'package:smartrider/widgets/shuttle_map.dart';
import 'package:google_fonts/google_fonts.dart'; //package for google font

void main() => runApp(SmartRider());

class SmartRider extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Rider Prototype',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomePage(),
      home: Loginpage(),
    );
  }
}
