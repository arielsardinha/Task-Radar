import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_radar/components/botton_navigator/navigation_bar_enum.dart';
import 'package:task_radar/components/botton_navigator/task_radar_bottom_navigator.dart';
import 'package:task_radar/data/models/me_model.dart';
import 'package:task_radar/data/repositories/task_repository_impl.dart';
import 'package:task_radar/data/storage/storage_impl.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import 'package:task_radar/domain/task.dart';
import 'package:task_radar/domain/user.dart';
import 'package:task_radar/global/providers/provider_user.dart';
import 'package:provider/provider.dart';

enum UsersFilter { all, admin, moderator }

enum UserTasksFilter { all, pending, completed }

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  UsersFilter _usersFilter = UsersFilter.all;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUserId() async {
    final storage = GetIt.instance.get<StorageImpl>();
    final me = await storage.getItemToFactory(
      StorageSecureEnum.auth_user,
      fromJson: MeModel.fromJson,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _currentUserId = me?.id;
    });
  }

  void _openUserTasksBottomSheet(_UserItemData user) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _UserTasksBottomSheet(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final currentUser = context.read<ProviderUser>().user;
    final users = [
      _UserItemData(
        id: _currentUserId,
        fullName: currentUser.fullName,
        email: currentUser.email,
        role: currentUser.userType,
        photo: currentUser.photo,
      ),
    ];

    final filteredUsers = users
        .where((user) {
          final byRole = switch (_usersFilter) {
            UsersFilter.all => true,
            UsersFilter.admin => user.role == UserType.admin,
            UsersFilter.moderator => user.role == UserType.moderator,
          };

          if (!byRole) {
            return false;
          }

          final query = _searchController.text.trim().toLowerCase();
          if (query.isEmpty) {
            return true;
          }

          return user.fullName.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query);
        })
        .toList(growable: false);

    final admins = filteredUsers
        .where((user) => user.role == UserType.admin)
        .toList(growable: false);
    final moderators = filteredUsers
        .where((user) => user.role == UserType.moderator)
        .toList(growable: false);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                onChanged: (_) => setState(() {}),
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
              Row(
                children: [
                  _UsersFilterChip(
                    label: 'Todos',
                    selected: _usersFilter == UsersFilter.all,
                    onTap: () => setState(() => _usersFilter = UsersFilter.all),
                  ),
                  const SizedBox(width: 8),
                  _UsersFilterChip(
                    label: 'Administradores',
                    selected: _usersFilter == UsersFilter.admin,
                    onTap: () =>
                        setState(() => _usersFilter = UsersFilter.admin),
                  ),
                  const SizedBox(width: 8),
                  _UsersFilterChip(
                    label: 'Moderadores',
                    selected: _usersFilter == UsersFilter.moderator,
                    onTap: () =>
                        setState(() => _usersFilter = UsersFilter.moderator),
                  ),
                ],
              ),
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
      ),
      bottomNavigationBar: const TaskRadarBottomNavigator(
        page: NavigationBarEnum.profile,
      ),
    );
  }
}

class _UsersSection extends StatelessWidget {
  final String title;
  final List<_UserItemData> users;
  final ValueChanged<_UserItemData> onTapUser;

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
  final _UserItemData user;
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

class _UsersFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _UsersFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      avatar: selected ? const Icon(Icons.check, size: 16) : null,
      side: BorderSide(color: colorScheme.outlineVariant),
      backgroundColor: selected
          ? colorScheme.secondaryContainer
          : Colors.transparent,
      labelStyle: TextStyle(
        color: selected
            ? colorScheme.onSecondaryContainer
            : colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class _UserTasksBottomSheet extends StatefulWidget {
  final _UserItemData user;

  const _UserTasksBottomSheet({required this.user});

  @override
  State<_UserTasksBottomSheet> createState() => _UserTasksBottomSheetState();
}

class _UserTasksBottomSheetState extends State<_UserTasksBottomSheet> {
  UserTasksFilter _filter = UserTasksFilter.all;
  late final Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _loadUserTasks();
  }

  Future<List<Task>> _loadUserTasks() async {
    if (widget.user.id == null) {
      return const [];
    }

    final repository = GetIt.instance.get<TaskRepositoryImpl>();
    return repository.getAllByUser(userId: widget.user.id!);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.82,
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
              child: Row(
                children: [
                  _TaskFilterChip(
                    label: 'Todas',
                    selected: _filter == UserTasksFilter.all,
                    onTap: () => setState(() => _filter = UserTasksFilter.all),
                  ),
                  const SizedBox(width: 8),
                  _TaskFilterChip(
                    label: 'Pendentes',
                    selected: _filter == UserTasksFilter.pending,
                    onTap: () =>
                        setState(() => _filter = UserTasksFilter.pending),
                  ),
                  const SizedBox(width: 8),
                  _TaskFilterChip(
                    label: 'Concluídas',
                    selected: _filter == UserTasksFilter.completed,
                    onTap: () =>
                        setState(() => _filter = UserTasksFilter.completed),
                  ),
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

                  final tasks = (snapshot.data ?? const <Task>[])
                      .where((task) {
                        return switch (_filter) {
                          UserTasksFilter.all => true,
                          UserTasksFilter.pending =>
                            task.status == TaskStatus.pending,
                          UserTasksFilter.completed =>
                            task.status == TaskStatus.completed,
                        };
                      })
                      .toList(growable: false);

                  if (tasks.isEmpty) {
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
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
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

class _TaskFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TaskFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      avatar: selected ? const Icon(Icons.check, size: 16) : null,
      side: BorderSide(color: colorScheme.outlineVariant),
      backgroundColor: selected
          ? colorScheme.secondaryContainer
          : Colors.transparent,
      labelStyle: TextStyle(
        color: selected
            ? colorScheme.onSecondaryContainer
            : colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

final class _UserItemData {
  final int? id;
  final String fullName;
  final String email;
  final UserType role;
  final String photo;

  const _UserItemData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.photo,
  });

  String get initial {
    final normalized = fullName.trim();
    if (normalized.isEmpty) {
      return '?';
    }

    return normalized.substring(0, 1).toUpperCase();
  }
}
