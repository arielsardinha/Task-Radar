import 'package:flutter/material.dart';
import 'package:task_radar/components/botton_navigator/navigation_bar_enum.dart';
import 'package:task_radar/components/botton_navigator/task_radar_bottom_navigator.dart';

class HomeSectionPlaceholderScreen extends StatelessWidget {
  final String title;
  final NavigationBarEnum page;

  const HomeSectionPlaceholderScreen({
    super.key,
    required this.title,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
        ),
      ),
      bottomNavigationBar: TaskRadarBottomNavigator(page: page),
    );
  }
}
