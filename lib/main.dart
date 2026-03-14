import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_radar/bindings.dart';
import 'package:task_radar/global/providers/provider_user.dart';
import 'package:task_radar/routes/router_config.dart';
import 'package:task_radar/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Bindings.register();

  runApp(const InitialAplication());
}

class InitialAplication extends StatelessWidget {
  const InitialAplication({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<ProviderUser>(
      create: (_) => ProviderUser(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Task Radar',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
