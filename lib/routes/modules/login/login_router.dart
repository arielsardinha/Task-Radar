import 'package:flutter/material.dart';
import 'package:task_radar/routes/routes.dart';

sealed class LoginRouter {
  static final Map<String, WidgetBuilder> routes = {
    Routes.login: (context) => const Text(""),
  };
}