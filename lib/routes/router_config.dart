import 'package:flutter/material.dart';
import 'package:task_radar/routes/modules/login/login_router.dart';

sealed class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    ...LoginRouter.routes
  };
}
