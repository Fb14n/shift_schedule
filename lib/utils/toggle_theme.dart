// dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeManager {
  static const String _keyThemeMode = 'theme_mode';
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static final ValueNotifier<ThemeMode> themeModeNotifier =
  ValueNotifier<ThemeMode>(ThemeMode.light);

  // Muss einmal beim App-Start aufgerufen werden (z. B. in main() vor runApp)
  static Future<void> loadTheme() async {
    final raw = await _storage.read(key: _keyThemeMode);
    final mode = _stringToThemeMode(raw) ?? ThemeMode.light;
    themeModeNotifier.value = mode;
  }

  static Future<void> toggleTheme() async {
    final newMode = themeModeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    themeModeNotifier.value = newMode;
    await _storage.write(key: _keyThemeMode, value: _themeModeToString(newMode));
  }

  static Future<void> setTheme(ThemeMode mode) async {
    themeModeNotifier.value = mode;
    await _storage.write(key: _keyThemeMode, value: _themeModeToString(mode));
  }

  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }

  static ThemeMode? _stringToThemeMode(String? s) {
    if (s == null) return null;
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}