import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shift_schedule/ui/themes/theme.dart';
import 'package:shift_schedule/utils/toggle_theme.dart';
import 'router.dart';
//import 'theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          routerConfig: goRouter,
          title: 'Shift Schedule',
          theme: CHRONOSTheme.lightTheme,
          darkTheme: CHRONOSTheme.darkTheme,
          themeMode: themeMode,
        );
      },
    );
  }
}