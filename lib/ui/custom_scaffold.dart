import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shift_schedule/services/api_service.dart';
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
    final ApiService apiService = ApiService();
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
                    Scaffold.of(context).openDrawer();
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
            drawer: FutureBuilder<Map<String, dynamic>>(
              future: apiService.fetchUserDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final userDetails = snapshot.data!;
                  final userName = userDetails['name'] ?? 'Unknown';
                  final vacationDays = userDetails['vacation_days'] ?? 0;
                  final sickDays = userDetails['sick_days'] ?? 0;

                  return Drawer(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        DrawerHeader(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.beach_access),
                          title: Text('$vacationDays Tage Resturlaub'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.sick),
                          title: Text('$sickDays Tage Krank'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Abmelden'),
                          onTap: () async {
                            await apiService.logout();
                            context.pushReplacement('/login');
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            body: body,
          ),
        );
      },
    );
  }
}