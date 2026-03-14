import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_radar/data/repositories/login_repository.dart';
import 'package:task_radar/modules/login/login_screen.dart';
import 'package:task_radar/modules/login/view_models/login_view_model.dart';
import 'package:task_radar/routes/routes.dart';

sealed class LoginRouter {
  static final Map<String, WidgetBuilder> routes = {
    Routes.login: (context) => LoginScreen(
      viewModel: LoginViewModel(
        loginRepository: GetIt.instance.get<LoginRepository>(),
      ),
    ),
  };
}