import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:task_radar/components/botton_navigator/navigation_bar_enum.dart';
import 'package:task_radar/components/botton_navigator/task_radar_bottom_navigator.dart';
import 'package:task_radar/modules/profile/bloc/profile_bloc.dart';
import 'package:task_radar/modules/profile/bloc/profile_event.dart';
import 'package:task_radar/modules/profile/bloc/profile_state.dart';
import 'package:task_radar/routes/routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = context.read<ProfileBloc>();
    _profileBloc.add(ProfileEventLoad());
  }

  void _showFailureSnackbar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        duration: const Duration(seconds: 4),
        content: Text(message),
        action: SnackBarAction(
          label: 'Tentar novamente',
          onPressed: () {
            _profileBloc.add(ProfileEventRetry());
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          listenWhen: (previous, current) =>
              current is ProfileStateFailure ||
              current is ProfileStateLoggedOut,
          listener: (context, state) {
            if (state is ProfileStateFailure) {
              _showFailureSnackbar(state.message);
            }

            if (state is ProfileStateLoggedOut) {
              context.go(Routes.login);
            }
          },
          builder: (context, state) {
            final isLoading =
                state is ProfileStateInitial || state is ProfileStateLoading;
            final profile = state is ProfileStateSuccess
                ? state.profile
                : ProfileViewData.skeleton();

            return Skeletonizer(
              enabled: isLoading,
              ignoreContainers: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SizedBox(width: 60, height: 32),
                        const Spacer(),
                        TextButton.icon(
                          key: const Key('ProfileScreen.TextButton.logout'),
                          onPressed: isLoading
                              ? null
                              : () {
                                  _profileBloc.add(ProfileEventLogout());
                                },
                          icon: const Icon(Icons.logout),
                          label: const Text('Sair'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: _ProfileAvatar(
                        profile: profile,
                        isLoading: isLoading,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        profile.firstName,
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        profile.email,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.badge_outlined,
                              size: 18,
                              color: colorScheme.onSurface,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              profile.type,
                              style: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: colorScheme.outlineVariant),
                    const SizedBox(height: 8),
                    _InfoCell(label: 'Nome completo', value: profile.fullName),
                    _InfoCell(label: 'E-mail', value: profile.email),
                    _InfoCell(label: 'Telefone', value: profile.phone),
                    _InfoCell(label: 'Empresa', value: profile.company),
                    _InfoCell(label: 'Departamento', value: profile.department),
                    _InfoCell(label: 'Type', value: profile.type),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const TaskRadarBottomNavigator(
        page: NavigationBarEnum.profile,
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final ProfileViewData profile;
  final bool isLoading;

  const _ProfileAvatar({required this.profile, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: 30,
      backgroundColor: colorScheme.primaryContainer,
      backgroundImage: NetworkImage(profile.photo),
      child: Text(
        profile.initialLetter,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.outline),
          ),
          Text(
            value,
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
