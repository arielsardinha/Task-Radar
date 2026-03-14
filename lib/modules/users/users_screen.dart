import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_radar/components/action_chip.dart';
import 'package:task_radar/components/botton_navigator/navigation_bar_enum.dart';
import 'package:task_radar/components/botton_navigator/task_radar_bottom_navigator.dart';
import 'package:task_radar/data/repositories/task_repository.dart';
import 'package:task_radar/domain/task.dart';
import 'package:task_radar/domain/user.dart';
import 'package:task_radar/modules/users/bloc/users_bloc.dart';
import 'package:task_radar/modules/users/bloc/users_event.dart';
import 'package:task_radar/modules/users/bloc/users_state.dart';

class UsersScreen extends StatefulWidget {
  final TaskRepository taskRepository;

  const UsersScreen({required this.taskRepository, super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late final UsersBloc _usersBloc;
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _usersBloc = context.read<UsersBloc>();
    _usersBloc.add(const UsersEventLoad());
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _usersBloc.add(UsersEventSearchChanged(value));
    });
  }

  void _openUserTasksBottomSheet(UsersViewData user) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _UserTasksBottomSheet(
        user: user,
        taskRepository: widget.taskRepository,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<UsersBloc, UsersState>(
          bloc: _usersBloc,
          builder: (context, state) {
            if (state.status == UsersStateStatus.loading ||
                state.status == UsersStateStatus.initial) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (state.status == UsersStateStatus.failure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.message ?? 'Não foi possível carregar os usuários.',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final filteredUsers = state.visibleUsers;

            final admins = filteredUsers.where((user) {
              return user.role == UserType.admin;
            }).toList(growable: false);
            final moderators = filteredUsers.where((user) {
              return user.role == UserType.moderator;
            }).toList(growable: false);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Usuários',
                          style: textTheme.headlineMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Pesquisar usuários',
                            filled: true,
                            fillColor: colorScheme.surfaceContainer,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 32),
                        FilterChipComponent(
                          label: 'Todos',
                          isSelected: state.filter == UsersFilter.all,
                          onTap: () => _usersBloc.add(
                            const UsersEventFilterChanged(UsersFilter.all),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilterChipComponent(
                          label: 'Administradores',
                          isSelected: state.filter == UsersFilter.admin,
                          onTap: () => _usersBloc.add(
                            const UsersEventFilterChanged(UsersFilter.admin),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilterChipComponent(
                          label: 'Moderadores',
                          isSelected: state.filter == UsersFilter.moderator,
                          onTap: () => _usersBloc.add(
                            const UsersEventFilterChanged(
                              UsersFilter.moderator,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _UsersSection(
                          title: 'Administradores',
                          users: admins,
                          onTapUser: _openUserTasksBottomSheet,
                        ),
                        const SizedBox(height: 16),
                        _UsersSection(
                          title: 'Moderadores',
                          users: moderators,
                          onTapUser: _openUserTasksBottomSheet,
                        ),
                        if (filteredUsers.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Center(
                              child: Text(
                                'Nenhum usuário encontrado.',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const TaskRadarBottomNavigator(
        page: NavigationBarEnum.users,
      ),
    );
  }
}

class _UsersSection extends StatelessWidget {
  final String title;
  final List<UsersViewData> users;
  final ValueChanged<UsersViewData> onTapUser;

  const _UsersSection({
    required this.title,
    required this.users,
    required this.onTapUser,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        if (users.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Sem usuários nesta seção.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ...users.map(
          (user) => _UserListItem(user: user, onTap: () => onTapUser(user)),
        ),
      ],
    );
  }
}

class _UserListItem extends StatelessWidget {
  final UsersViewData user;
  final VoidCallback onTap;

  const _UserListItem({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: colorScheme.primaryContainer,
          backgroundImage: user.photo.trim().isEmpty
              ? null
              : NetworkImage(user.photo),
          child: Text(
            user.initial,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(user.fullName),
        subtitle: Text(user.email),
      ),
    );
  }
}



class _UserTasksBottomSheet extends StatefulWidget {
  final UsersViewData user;
  final TaskRepository taskRepository;

  const _UserTasksBottomSheet({
    required this.user,
    required this.taskRepository,
  });

  @override
  State<_UserTasksBottomSheet> createState() => _UserTasksBottomSheetState();
}

enum _UserTaskFilter { all, pending, completed }

class _UserTasksBottomSheetState extends State<_UserTasksBottomSheet> {
  late final Future<List<Task>> _tasksFuture;
  _UserTaskFilter _taskFilter = _UserTaskFilter.all;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _loadUserTasks();
  }

  Future<List<Task>> _loadUserTasks() async {
    if (widget.user.id == null) {
      return const [];
    }

    return widget.taskRepository.getAllByUser(userId: widget.user.id!);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: true,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      widget.user.initial,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.user.fullName,
                      style: textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                'Tarefas do usuário',
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  FilterChipComponent(
                    label: 'Todas',
                    isSelected: _taskFilter == _UserTaskFilter.all,
                    onTap: () {
                      setState(() => _taskFilter = _UserTaskFilter.all);
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChipComponent(
                    label: 'Pendentes',
                    isSelected: _taskFilter == _UserTaskFilter.pending,
                    onTap: () {
                      setState(() => _taskFilter = _UserTaskFilter.pending);
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChipComponent(
                    label: 'Concluídas',
                    isSelected: _taskFilter == _UserTaskFilter.completed,
                    onTap: () {
                      setState(() => _taskFilter = _UserTaskFilter.completed);
                    },
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Task>>(
                future: _tasksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Não foi possível carregar as tarefas deste usuário.',
                          style: textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final tasks = (snapshot.data ?? const <Task>[]).toList(
                    growable: false,
                  );

                  final filteredTasks = tasks.where((task) {
                    return switch (_taskFilter) {
                      _UserTaskFilter.all => true,
                      _UserTaskFilter.pending =>
                        task.status == TaskStatus.pending,
                      _UserTaskFilter.completed =>
                        task.status == TaskStatus.completed,
                    };
                  }).toList(growable: false);

                  if (filteredTasks.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhuma tarefa encontrada.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: filteredTasks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      final isCompleted = task.status == TaskStatus.completed;
                      return Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(
                            isCompleted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isCompleted
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                          title: Text(task.name),
                          subtitle: task.description.trim().isEmpty
                              ? null
                              : Text(
                                  task.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


