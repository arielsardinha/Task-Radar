import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_radar/components/botton_navigator/navigation_bar_enum.dart';
import 'package:task_radar/components/botton_navigator/task_radar_bottom_navigator.dart';
import 'package:task_radar/global/providers/provider_user.dart';
import 'package:task_radar/modules/home/bloc/home_bloc.dart';
import 'package:task_radar/modules/home/bloc/home_event.dart';
import 'package:task_radar/modules/home/bloc/home_state.dart';
import 'package:task_radar/modules/home/components/new_task_bottom_sheet.dart';
import 'package:task_radar/modules/home/components/task_overview_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<ProviderUser>();
    final firstName = user.user.fullName;
    final homeBloc = context.read<HomeBloc>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: const Key('HomeScreen.FloatingActionButton.newTask'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            backgroundColor: const Color(0xFFF7F2FA),
            builder: (_) => const NewTaskBottomSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: 'Olá,',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextSpan(text: ' $firstName!'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '“ A única maneira de fazer um excelente\n'
                'trabalho é amar o que você faz.”',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                  height: 20 / 14,
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '- Steve Jobs',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                    height: 20 / 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Suas tarefas',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<HomeBloc, HomeState>(
                bloc: homeBloc,
                builder: (context, state) {
                  return switch (state) {
                    HomeStateLoading() || HomeStateInitial() => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    HomeStateFailure(:final message) => Center(
                      child: Text(message),
                    ),
                    HomeStateOverviewLoaded(
                      :final total,
                      :final completed,
                      :final pending,
                    ) =>
                      TaskOverviewCard(
                        total: total,
                        completed: completed,
                        pending: pending,
                      ),
                    HomeState() => const SizedBox.shrink(),
                  };
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TaskRadarBottomNavigator(
        page: NavigationBarEnum.home,
      ),
    );
  }
}
