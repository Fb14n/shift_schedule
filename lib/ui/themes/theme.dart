import 'package:flutter/material.dart';


class DayCellColors {
  DayCellColors();
  final Color earlyShift = Colors.transparent;
  final Color lateShift = Color(0xFFccffcc);
  final Color sick = Color(0xFFFFCCCC);
  final Color holiday = Color(0xFF3399CC);
  final Color defaultColor = Colors.transparent;
}

class FEZTheme {
  // Define common colors
  static const Color borderColorDefault = Colors.black;
  static const Color borderColorActive = Color(0xFFFF0000);
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.orange;
  static const Color infoColor = Colors.blue;
  static final dayCellColors = DayCellColors();

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepPurple,
    colorScheme: const ColorScheme.light(
      primary: Colors.deepPurple,
      secondary: Colors.deepPurpleAccent,
      error: errorColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    colorScheme: const ColorScheme.dark(
      primary: Colors.deepPurple,
      secondary: Colors.deepPurpleAccent,
      error: errorColor,
    ),
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
  );
}