import 'package:flutter/material.dart';

@immutable
class CHRONOSColors extends ThemeExtension<CHRONOSColors> {
  final Map<String, Color> _colors;

  const CHRONOSColors(this._colors);

  Color operator [](String key) => _colors[key]!;

  Color get popUpBackground => _colors['popUpBackground']!;
  Color get borderColorDefault => _colors['borderColorDefault']!;
  Color get popUpShadow => _colors['popUpShadow']!;

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
    'popUpBackground': Colors.white,
    'popUpShadow': Colors.white,
    'borderColorDefault': Colors.black,
  });

  static final dark = CHRONOSColors({
    'popUpBackground': Colors.black,
    'popUpShadow': Colors.white,
    'borderColorDefault': Colors.white,
  });
}