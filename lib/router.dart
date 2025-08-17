import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shift_schedule/calender_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final initialLocation = '/login';
final GoRouter goRouter = GoRouter(
  initialLocation: initialLocation,

  /// Splashscreen redirects to initialLocation
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) {
        String path = initialLocation;
        if (state.extra is Map<String, dynamic>) {
          path = (state.extra as Map<String, dynamic>)['origin'];
        }
        log('Login route origin: $path', name: 'Router');

        return MaterialPage(child: CalenderView());
      },
    ),
  ],
);
