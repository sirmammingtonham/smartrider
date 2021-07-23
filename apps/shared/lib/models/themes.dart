// ignore_for_file: prefer_const_constructors
// TODO: rework themes, add const constructors
import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(42, 46, 67, .1),
  100: Color.fromRGBO(42, 46, 67, .2),
  200: Color.fromRGBO(42, 46, 67, .3),
  300: Color.fromRGBO(42, 46, 67, .4),
  400: Color.fromRGBO(42, 46, 67, .5),
  500: Color.fromRGBO(42, 46, 67, .6),
  600: Color.fromRGBO(42, 46, 67, .7),
  700: Color.fromRGBO(42, 46, 67, .8),
  800: Color.fromRGBO(42, 46, 67, .9),
  900: Color.fromRGBO(42, 46, 67, 1),
};

MaterialColor colorCustom = MaterialColor(0xff2a2e43, color);

final ThemeData lightTheme = ThemeData(
  primarySwatch: colorCustom,
  brightness: Brightness.light,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: Colors.black,
    backgroundColor: Colors.white,
  ),
  //primaryColor: Color(0xff2a2e43),
);

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.purple,
  brightness: Brightness.dark,
  primaryColor: Color(0xff2a2e43),
);
