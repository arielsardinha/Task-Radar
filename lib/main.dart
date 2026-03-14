import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_radar/bindings.dart';
import 'package:task_radar/global/providers/provider_theme.dart';
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
    return MultiProvider(
      providers: [
        Provider<ProviderUser>(create: (_) => ProviderUser()),
        ChangeNotifierProvider<ProviderTheme>(create: (_) => ProviderTheme()),
      ],
      child: Consumer<ProviderTheme>(
        builder: (context, providerTheme, _) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Task Radar',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: providerTheme.themeMode,
          routerConfig: AppRoutes.router,
        ),
      ),
    );
  }
}
