import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_radar/components/botton_navigator/navigation_bar_enum.dart';
import 'package:task_radar/modules/home/home_screen.dart';
import 'package:task_radar/modules/home/home_section_placeholder_screen.dart';
import 'package:task_radar/routes/routes.dart';

sealed class HomeRouter {
  static final List<GoRoute> routes = [
    GoRoute(
      path: Routes.home,
      pageBuilder: (context, state) =>
          const _NoAnimationPage<void>(child: HomeScreen()),
    ),
    GoRoute(
      path: Routes.tasks,
      pageBuilder: (context, state) => const _NoAnimationPage<void>(
        child: HomeSectionPlaceholderScreen(
          title: 'Tarefas',
          page: NavigationBarEnum.tasks,
        ),
      ),
    ),
    GoRoute(
      path: Routes.profile,
      pageBuilder: (context, state) => const _NoAnimationPage<void>(
        child: HomeSectionPlaceholderScreen(
          title: 'Perfil',
          page: NavigationBarEnum.profile,
        ),
      ),
    ),
  ];
}

class _NoAnimationPage<T> extends Page<T> {
  final Widget child;

  const _NoAnimationPage({
    required this.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}
