import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shift_schedule/calender_view.dart';
import 'package:shift_schedule/holiday_editor_view.dart';

import 'login_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter goRouter = GoRouter(
  initialLocation: '/login',

  /// Splashscreen redirects to initialLocation
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) {
        return MaterialPage(child: LoginPage());
      },
    ),
    GoRoute(
      path: '/calendar',
      name: 'calendarView',
      pageBuilder: (context, state) {
        return MaterialPage(child: CalendarView());
      },
    ),
    GoRoute(
      path: '/holiday_editor',
      name: 'holidayEditor',
      pageBuilder: (context, state) {
        return MaterialPage(child: HolidayEditorView());
      },
    ),
  ],
);
