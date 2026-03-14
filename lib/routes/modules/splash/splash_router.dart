import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:task_radar/data/repositories/auth_repository.dart';
import 'package:task_radar/data/storage/storage_impl.dart';
import 'package:task_radar/modules/splash/animation_splash.dart';
import 'package:task_radar/routes/routes.dart';

sealed class SplashRouter {
  static final List<GoRoute> routes = [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => SplashAnimationScreen(
        authRepository: GetIt.instance.get<AuthRepositoryImpl>(),
        storage: GetIt.instance.get<StorageImpl>(),
      ),
    ),
  ];
}
