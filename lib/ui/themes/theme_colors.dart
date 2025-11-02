import 'package:flutter/material.dart';

@immutable
class CHRONOSColors extends ThemeExtension<CHRONOSColors> {
  final Map<String, Color> _colors;

  const CHRONOSColors(this._colors);

  Color operator [](String key) => _colors[key]!;

  Color get popUpBackground => _colors['popUpBackground']!;
  Color get calendarAccent => _colors['calendarAccent']!;
  Color get shiftHighlight => _colors['shiftHighlight']!;
  Color get borderColorDefault => _colors['borderColorDefault']!;

  @override
  CHRONOSColors copyWith({Map<String, Color>? colors}) =>
      CHRONOSColors(colors ?? _colors);

  @override
  CHRONOSColors lerp(ThemeExtension<CHRONOSColors>? other, double t) {
    if (other is! CHRONOSColors) return this;
    final Map<String, Color> lerped = {};
    for (var key in _colors.keys) {
      lerped[key] = Color.lerp(_colors[key], other._colors[key], t)!;
    }
    return CHRONOSColors(lerped);
  }

  // === Light & Dark Map ===
  static final light = CHRONOSColors({
    'popUpBackground': const Color(0xFFF4F4F4),
    'calendarAccent': const Color(0xFF305CA3),
    'shiftHighlight': const Color(0xFF174165),
    'borderColorDefault': Colors.black,
  });

  static final dark = CHRONOSColors({
    'popBackground': const Color(0xFF1E1E1E),
    'calendarAccent': const Color(0xFF7299F5),
    'shiftHighlight': const Color(0xFF4A6CA3),
    'borderColorDefault': Colors.white,
  });
}