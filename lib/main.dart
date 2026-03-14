import 'package:flutter/material.dart';
import 'package:task_radar/modules/splash/animation_splash.dart';
import 'package:task_radar/theme/app_theme.dart';


void main() {
  runApp(const SplashApp());
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

