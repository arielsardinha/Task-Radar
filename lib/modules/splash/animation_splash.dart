import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_radar/data/repositories/auth_repository.dart';
import 'package:task_radar/data/storage/storage.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import 'package:task_radar/global/providers/provider_user.dart';
import 'package:task_radar/routes/routes.dart';

class SplashAnimationScreen extends StatefulWidget {
  final AuthRepository authRepository;
  final Storage storage;

  const SplashAnimationScreen({
    super.key,
    required this.authRepository,
    required this.storage,
  });

  /// Duração de espera antes de iniciar a animação da splash
  static final Duration _splashWaitBeforeDuration = Duration(
    milliseconds: switch (Platform.isAndroid) {
      true => 300,
      // o iOS não possui a splash nativa paradona do Android 12+
      // então, para manter a ID Visual, geramos um tempo de espera fictício maior
      false => 1000,
    },
  );

  static final Duration _splashAnimationDuration = const Duration(
    milliseconds: 2000,
  );

  static final Duration totalSplashDuration =
      (_splashWaitBeforeDuration + _splashAnimationDuration) * 1.25;

  @override
  State<SplashAnimationScreen> createState() => _SplashAnimationScreenState();
}

class _SplashAnimationScreenState extends State<SplashAnimationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: SplashAnimationScreen._splashAnimationDuration,
      vsync: this,
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _bootstrapSession();
  }

  Future<void> _bootstrapSession() async {
    final authData = await widget.storage.getItem(StorageSecureEnum.auth_jwt);
    final refreshToken = authData?['refresh_token'] as String?;
    final user = refreshToken == null
        ? null
        : await widget.authRepository.refreshSession(refreshToken);

    await Future<void>.delayed(SplashAnimationScreen._splashWaitBeforeDuration);
    if (!mounted) {
      return;
    }

    final animationFuture = _controller.forward(from: 0.0);

    await animationFuture;
    if (!mounted) {
      return;
    }

    if (user != null) {
      context.read<ProviderUser>().user = user;
      GoRouter.of(context).go(Routes.home);
      return;
    }

    GoRouter.of(context).go(Routes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final viewport = Size(constraints.maxWidth, constraints.maxHeight);

          return AnimatedBuilder(
            animation: _progress,
            builder: (context, _) {
              final p = _progress.value;
              return Stack(
                children: [_AnimatedShape(size: viewport, progress: p)],
              );
            },
          );
        },
      ),
    );
  }
}

class _AnimatedShape extends StatelessWidget {
  const _AnimatedShape({required this.size, required this.progress});

  final Size size;
  final double progress;

  double _lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }

  double _segment(double p, double start, double end) {
    if (p <= start) return 0;
    if (p >= end) return 1;
    return (p - start) / (end - start);
  }

  @override
  Widget build(BuildContext context) {
    final shapeColor = Theme.of(context).colorScheme.primary;
    final viewportCenterX = size.width / 2;
    final viewportCenterY = size.height / 2;
    final centerX = (size.width - 100) / 2;
    final startTop = size.height * 0.71;
    final endTop = size.height * 0.44;

    final moveAndRotateT = Curves.easeOutCubic.transform(
      _segment(progress, 0.0, 0.36),
    );
    final shrinkT = Curves.easeInOut.transform(_segment(progress, 0.36, 0.56));
    final roundT = Curves.easeInOut.transform(_segment(progress, 0.56, 0.72));
    final expandT = Curves.easeInCubic.transform(_segment(progress, 0.72, 1.0));

    var shapeSize = 100.0;
    var top = _lerp(startTop, endTop, moveAndRotateT);
    var left = centerX;
    var radius = 32.0;
    var rotation = _lerp(0, math.pi, moveAndRotateT);

    if (shrinkT > 0) {
      shapeSize = _lerp(100, 50, shrinkT);
      top = _lerp(endTop, viewportCenterY - 25, shrinkT);
      left = _lerp(centerX, (size.width - 50) / 2, shrinkT);
      radius = _lerp(12, 10, shrinkT);
      rotation = math.pi;
    }

    if (roundT > 0) {
      shapeSize = 50;
      top = viewportCenterY - 25;
      left = (size.width - 50) / 2;
      radius = _lerp(10, 25, roundT);
      rotation = math.pi;
    }

    if (expandT > 0) {
      final maxDimension = math.max(size.width, size.height) * 4.8;

      shapeSize = _lerp(50, maxDimension, expandT);
      top = viewportCenterY - shapeSize / 2;
      left = viewportCenterX - shapeSize / 2;
      radius = shapeSize / 2;
      rotation = math.pi;
    }

    return Positioned(
      left: left,
      top: top,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          width: shapeSize,
          height: shapeSize,
          decoration: BoxDecoration(
            color: shapeColor,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }
}
