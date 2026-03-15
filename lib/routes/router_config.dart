import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_radar/routes/modules/home/home_router.dart';
import 'package:task_radar/routes/modules/login/login_router.dart';
import 'package:task_radar/routes/modules/splash/splash_router.dart';
import 'package:task_radar/routes/routes.dart';

sealed class AppRoutes {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
    routes: [
      ...SplashRouter.routes,
      ...HomeRouter.routes,
      ...LoginRouter.routes,
    ],
  );
}
