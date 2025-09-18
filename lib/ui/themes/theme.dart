import 'package:flutter/material.dart';


class DayCellColors {
  DayCellColors();
  final Color earlyShift = Colors.transparent;
  final Color lateShift = Color(0xFFccffcc);
  final Color onLateShift = Colors.black;
  final Color sick = Color(0xFFFFCCCC);
  final Color onSick = Colors.black;
  final Color holiday = Color(0xFF3399CC);
  final Color onHoliday = Colors.black;
  final Color defaultColor = Colors.transparent;
}

class FEZTheme {
  // Define common colors
  //static const Color borderColorDefault = Colors.black;
  static Color borderColorDefault(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;
  }
  static const Color borderColorActive = Color(0xFFFF0000);
  static const Color error = Colors.red;
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;
  static final dayCellColors = DayCellColors();
  static const Color primary = Color(0xFF0082AF);
  static const Color secondary = Color(0xFF2E8FB8);
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;


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