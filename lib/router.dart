import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shift_schedule/routes/calendar_view.dart';
import 'package:shift_schedule/routes/edit/add_user_page.dart';
import 'package:shift_schedule/routes/edit/admin_calendar_view.dart';
import 'package:shift_schedule/routes/edit/user_list_page.dart';
import 'package:shift_schedule/routes/holiday_editor_view.dart';
import 'package:shift_schedule/routes/login_page.dart';
import 'package:shift_schedule/routes/settings_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter goRouter = GoRouter(
  initialLocation: '/login',

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
    GoRoute(
      path: '/settings',
      name: 'settings',
      pageBuilder: (context, state) {
        return MaterialPage(child: SettingsView());
      },
    ),
    GoRoute(
      path: '/edit',
      name: 'edit',
      redirect: (context, state) {
        if (state.uri.path == '/edit') return state.namedLocation('user_list');
        return null;
      },
      routes: [
        GoRoute(
          path: 'user_list',
          name: 'user_list',
          pageBuilder: (context, state) {
            return MaterialPage(child: UserListPage());
          },
          routes: [
            GoRoute(
              path: 'admin_calendar',
              name: 'admin_calendar',
              pageBuilder: (context, state) {
                final user = state.extra as Map<String, dynamic>;
                return MaterialPage(child: AdminCalendarView(user: user));
              },
            ),
            GoRoute(
              path: 'add_user',
              name: 'add_user',
              pageBuilder: (context, state) {
                return MaterialPage(child: AddUserPage());
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
