import 'package:flutter/material.dart';
import 'package:shift_schedule/ui/themes/theme_colors.dart';


class CHRONOSTheme {
  static const Color primary = Color(0xFF174165);
  static const Color onPrimary = Colors.white;
  static const Color secondary = Colors.white;
  static const Color onSecondary = Color(0xFF305CA3);
  static const Color error = Colors.red;
  static const Color success = Colors.green;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    extensions: [CHRONOSColors.light],
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    extensions: [CHRONOSColors.dark],
  );

  static CHRONOSColors of(BuildContext context) =>
      Theme.of(context).extension<CHRONOSColors>()!;
}