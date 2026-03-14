import 'package:flutter/material.dart';
import 'package:task_radar/bindings.dart';
import 'package:task_radar/modules/splash/animation_splash.dart';
import 'package:task_radar/routes/router_config.dart';
import 'package:task_radar/routes/routes.dart';
import 'package:task_radar/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bindings.register();

  runApp(const SplashApp());
  await Future.delayed(SplashAnimationScreen.totalSplashDuration);
  runApp(const InitialAplication());
}

class SplashApp extends StatelessWidget {
  const SplashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Radar',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const SplashAnimationScreen(),
    );
  }
}

class InitialAplication extends StatelessWidget {
  const InitialAplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.login,
      debugShowCheckedModeBanner: false,
      title: 'Task Radar',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routes: AppRoutes.routes,
    );
  }
}
