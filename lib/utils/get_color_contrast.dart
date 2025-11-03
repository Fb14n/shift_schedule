import 'package:flutter/material.dart';

/// Bestimmt eine gut lesbare Textfarbe (Schwarz oder Weiß)
/// basierend auf der wahrgenommenen Helligkeit der Hintergrundfarbe.
///
/// Diese Funktion nutzt die eingebaute Helligkeitsberechnung von Flutter,
/// um einen optimalen Kontrast zu gewährleisten.
Color getColorContrast(Color backgroundColor) {
  // ThemeData.estimateBrightnessForColor gibt Brightness.dark oder Brightness.light zurück.
  final Brightness brightness = ThemeData.estimateBrightnessForColor(backgroundColor);

  // Wenn der Hintergrund als 'light' eingestuft wird, gib dunklen Text zurück.
  // Wenn der Hintergrund als 'dark' eingestuft wird, gib hellen Text zurück.
  return brightness == Brightness.light ? Colors.black : Colors.white;
}
