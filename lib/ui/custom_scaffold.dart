import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shift_schedule/utils/toggle_theme.dart';
import 'package:material_symbols_icons/symbols.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? title;

  const CustomScaffold({
    super.key,
    this.body,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: Scaffold(
            appBar: AppBar(
              title: title ?? const Text('FEZ Schichtplan'),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Symbols.person),
                  onPressed: () {
                    log('User icon pressed', name: 'CustomScaffold');
                    Scaffold.of(context).openDrawer(); // Open the drawer
                  },
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    themeMode == ThemeMode.light
                        ? Symbols.dark_mode
                        : Symbols.light_mode,
                  ),
                  onPressed: ThemeManager.toggleTheme,
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      'hans Peter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Symbols.beach_access),
                    title: const Text('3 Tage Resturlaub'),
                    onTap: () {
                      log('Urlaub', name: 'CustomScaffold');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Symbols.sick),
                    title: const Text('13 Tage Krank'),
                    onTap: () {
                      log('Krank', name: 'CustomScaffold');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Abmelden'),
                    onTap: () {
                      log('Abmelden ausgewählt', name: 'CustomScaffold');
                    },
                  ),
                ],
              ),
            ),
            body: body,
          ),
        );
      },
    );
  }
}