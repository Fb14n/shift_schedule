import 'package:flutter/material.dart';


class CHRONOSTheme {
  // Define common colors
  //static const Color borderColorDefault = Colors.black;
  static Color borderColorDefault(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;
  }
  // static Color onBackground(BuildContext context) {
  //   return Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;
  // }
  static const Color borderColorActive = Color(0xFFFF0000);
  static const Color error = Colors.red;
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;
  static const Color primary = Color(0xFF174165);
  static const Color secondary = Color(0xFF305CA3);
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;
  static const Color onBackground = Color(0xFF5A5A5A);


  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
  );
}