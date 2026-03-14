import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_radar/components/botton_navigator/navigation_bar_enum.dart';
import 'package:task_radar/data/repositories/task_repository_impl.dart';
import 'package:task_radar/data/storage/storage_impl.dart';
import 'package:task_radar/modules/home/bloc/home_bloc.dart';
import 'package:task_radar/modules/home/home_screen.dart';
import 'package:task_radar/modules/home/home_section_placeholder_screen.dart';
import 'package:task_radar/modules/tasks/bloc/tasks_bloc.dart';
import 'package:task_radar/modules/tasks/tasks_screen.dart';
import 'package:task_radar/routes/routes.dart';

sealed class HomeRouter {
  static final List<GoRoute> routes = [
    GoRoute(
      path: Routes.home,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: Provider<HomeBloc>(
          create: (_) => HomeBloc(
            taskRepository: GetIt.instance.get<TaskRepositoryImpl>(),
            storage: GetIt.instance.get<StorageImpl>(),
          ),
          child: const HomeScreen(),
        ),
      ),
    ),
    GoRoute(
      path: Routes.tasks,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: Provider<TasksBloc>(
          create: (_) => TasksBloc(
            taskRepository: GetIt.instance.get<TaskRepositoryImpl>(),
            storage: GetIt.instance.get<StorageImpl>(),
          ),
          child: const TasksScreen(),
        ),
      ),
    ),
    GoRoute(
      path: Routes.profile,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: HomeSectionPlaceholderScreen(
          title: 'Perfil',
          page: NavigationBarEnum.profile,
        ),
      ),
    ),
  ];
}
