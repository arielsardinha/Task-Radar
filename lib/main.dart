import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:task_radar/bindings.dart';
import 'package:task_radar/data/repositories/auth_repository.dart';
import 'package:task_radar/global/mediator.dart';
import 'package:task_radar/global/providers/provider_connectivity.dart';
import 'package:task_radar/global/providers/provider_theme.dart';
import 'package:task_radar/global/providers/provider_user.dart';
import 'package:task_radar/routes/router_config.dart';
import 'package:task_radar/routes/routes.dart';
import 'package:task_radar/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Bindings.register();

  runApp(const InitialAplication());
}

class InitialAplication extends StatefulWidget {
  const InitialAplication({super.key});

  @override
  State<InitialAplication> createState() => _InitialAplicationState();
}

class _InitialAplicationState extends State<InitialAplication> {
  final ProviderConnectivity _providerConnectivity = ProviderConnectivity();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _providerConnectivity.setOnline(
        results.any((result) => result != ConnectivityResult.none),
      );
    });

    _initializeConnectivity();
    final instance = GetIt.instance;
    instance.get<Mediator>().register<String>('refrash_token', (data) async {
      final isOnline = await _hasInternetConnection();
      if (!isOnline) {
        return;
      }

      await instance.get<AuthRepositoryImpl>().refreshSession(data);
    });

    instance.get<Mediator>().register<String>('redirect_login', (data) async {
      final isOnline = await _hasInternetConnection();
      if (!isOnline) {
        return;
      }
      AppRoutes.router.go(Routes.login);
    });
  }

  Future<bool> _hasInternetConnection() async {
    final results = await _connectivity.checkConnectivity();
    final isOnline = results.any((result) => result != ConnectivityResult.none);
    _providerConnectivity.setOnline(isOnline);
    return isOnline;
  }

  Future<void> _initializeConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    if (!mounted) {
      return;
    }
    _providerConnectivity.setOnline(
      results.any((result) => result != ConnectivityResult.none),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _providerConnectivity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProviderUser>(create: (_) => ProviderUser()),
        ChangeNotifierProvider<ProviderTheme>(create: (_) => ProviderTheme()),
        ChangeNotifierProvider<ProviderConnectivity>.value(
          value: _providerConnectivity,
        ),
      ],
      child: Consumer2<ProviderTheme, ProviderConnectivity>(
        builder: (context, providerTheme, providerConnectivity, _) =>
            MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Task Radar',
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: providerTheme.themeMode,
              routerConfig: AppRoutes.router,
              builder: (context, child) {
                final topPadding = MediaQuery.paddingOf(context).top;
                return Stack(
                  children: [
                    if (child != null) child,
                    if (!providerConnectivity.isOnline)
                      Positioned(
                        top: topPadding + 12,
                        right: 12,
                        child: IgnorePointer(
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withValues(alpha: 0.46),
                                  blurRadius: 18,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.wifi_off_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
      ),
    );
  }
}
