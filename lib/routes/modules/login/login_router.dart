import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_radar/data/repositories/login_repository.dart';
import 'package:task_radar/modules/login/bloc/login_bloc.dart';
import 'package:task_radar/modules/login/login_screen.dart';
import 'package:task_radar/routes/routes.dart';

sealed class LoginRouter {
  static final List<GoRoute> routes = [
    GoRoute(
      path: Routes.login,
      builder: (context, state) => Provider<LoginBloc>(
        create: (_) => LoginBloc(
          loginRepository: GetIt.instance.get<LoginRepository>(),
        ),
        child: const LoginScreen(),
      ),
    ),
  ];
}