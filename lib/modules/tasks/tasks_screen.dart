import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_radar/components/action_chip.dart';
import 'package:task_radar/components/botton_navigator/navigation_bar_enum.dart';
import 'package:task_radar/components/botton_navigator/task_radar_bottom_navigator.dart';
import 'package:task_radar/domain/task.dart';
import 'package:task_radar/modules/home/components/new_task_bottom_sheet.dart';
import 'package:task_radar/modules/tasks/bloc/tasks_bloc.dart';
import 'package:task_radar/modules/tasks/bloc/tasks_event.dart';
import 'package:task_radar/modules/tasks/bloc/tasks_state.dart';
import 'package:task_radar/modules/tasks/components/edit_task_bottom_sheet.dart';
import 'package:task_radar/theme/app_theme.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late final TasksBloc _tasksBloc;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _tasksBloc = context.read<TasksBloc>();
    _tasksBloc.add(TasksEventLoad());
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _tasksBloc.add(TasksEventSearchChanged(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: const Key('TasksScreen.FloatingActionButton.newTask'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (_) => NewTaskBottomSheet(
              onSubmit: ({required name, required description}) async {
                _tasksBloc.add(
                  TasksEventCreateTask(name: name, description: description),
                );
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: BlocBuilder<TasksBloc, TasksState>(
            bloc: _tasksBloc,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Tarefas',
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: const Key('TasksScreen.TextField.search'),
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Pesquisar tarefas',
                      filled: true,
                      fillColor: colorScheme.surfaceContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChipComponent(
                          label: 'Todas',
                          isSelected: state.filter == TaskListFilter.all,
                          onTap: () {
                            _tasksBloc.add(
                              TasksEventFilterChanged(TaskListFilter.all),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChipComponent(
                          label: 'Pendentes',
                          isSelected: state.filter == TaskListFilter.pending,
                          onTap: () {
                            _tasksBloc.add(
                              TasksEventFilterChanged(TaskListFilter.pending),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChipComponent(
                          label: 'Concluídas',
                          isSelected: state.filter == TaskListFilter.completed,
                          onTap: () {
                            _tasksBloc.add(
                              TasksEventFilterChanged(TaskListFilter.completed),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (state.hasActiveIndicators)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (state.filter != TaskListFilter.all)
                            Chip(
                              label: Text(switch (state.filter) {
                                TaskListFilter.all => 'Todas',
                                TaskListFilter.pending => 'Pendentes',
                                TaskListFilter.completed => 'Concluídas',
                              }),
                            ),
                          if (state.query.trim().isNotEmpty)
                            Chip(label: Text('Busca: "${state.query}"')),
                        ],
                      ),
                    ),
                  Text(
                    'Ordenar por',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  PopupMenuButton<String>(
                    key: const Key('TasksScreen.PopupMenu.order'),
                    onSelected: (value) {
                      switch (value) {
                        case 'default':
                          _tasksBloc.add(
                            TasksEventOrderChanged(TaskListOrder.defaultById),
                          );
                        case 'alpha':
                          _tasksBloc.add(
                            TasksEventOrderChanged(TaskListOrder.alphabetical),
                          );
                        case 'status':
                          _tasksBloc.add(
                            TasksEventOrderChanged(
                              TaskListOrder.completionStatus,
                            ),
                          );
                        case 'asc':
                          _tasksBloc.add(TasksEventOrderDirectionChanged(true));
                        case 'desc':
                          _tasksBloc.add(
                            TasksEventOrderDirectionChanged(false),
                          );
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'default', child: Text('Padrão')),
                      PopupMenuItem(
                        value: 'alpha',
                        child: Text('Alfabética (texto)'),
                      ),
                      PopupMenuItem(
                        value: 'status',
                        child: Text('Status de conclusão'),
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'asc',
                        child: Text('Ordem crescente'),
                      ),
                      PopupMenuItem(
                        value: 'desc',
                        child: Text('Ordem decrescente'),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.outlineVariant),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(switch (state.order) {
                            TaskListOrder.defaultById => 'Padrão',
                            TaskListOrder.alphabetical => 'Alfabética',
                            TaskListOrder.completionStatus => 'Status',
                          }),
                          const SizedBox(width: 6),
                          Icon(
                            state.orderAscending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: switch (state.status) {
                      TasksStateStatus.loading ||
                      TasksStateStatus.initial => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      TasksStateStatus.failure => Center(
                        child: Text(
                          state.message ?? 'Falha ao carregar tarefas.',
                        ),
                      ),
                      TasksStateStatus.success => _TasksContent(
                        pendingTasks: state.pendingTasks,
                        completedTasks: state.completedTasks,
                        onTapTask: (task) {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            showDragHandle: true,
                            builder: (_) => EditTaskBottomSheet(
                              initialName: task.name,
                              initialDescription: task.description,
                              onSave: ({required name, required description}) {
                                _tasksBloc.add(
                                  TasksEventUpdateTask(
                                    task: task,
                                    name: name,
                                    description: description,
                                  ),
                                );
                                return Future.value();
                              },
                              onDelete: () {
                                _tasksBloc.add(TasksEventDeleteTask(task));
                                return Future.value();
                              },
                            ),
                          );
                        },
                        onToggle: (task) {
                          _tasksBloc.add(TasksEventToggleCompleted(task));
                        },
                      ),
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const TaskRadarBottomNavigator(
        page: NavigationBarEnum.tasks,
      ),
    );
  }
}

class _TasksContent extends StatelessWidget {
  final List<Task> pendingTasks;
  final List<Task> completedTasks;
  final ValueChanged<Task> onTapTask;
  final ValueChanged<Task> onToggle;

  const _TasksContent({
    required this.pendingTasks,
    required this.completedTasks,
    required this.onTapTask,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      children: [
        Text(
          'Pendentes',
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        ...pendingTasks.map(
          (task) => _TaskItem(task: task, onTap: onTapTask, onToggle: onToggle),
        ),
        const SizedBox(height: 16),
        Text(
          'Concluídas',
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        ...completedTasks.map(
          (task) => _TaskItem(task: task, onTap: onTapTask, onToggle: onToggle),
        ),
        if (pendingTasks.isEmpty && completedTasks.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Center(
              child: Text(
                'Nenhuma tarefa encontrada.',
                style: textTheme.bodyMedium,
              ),
            ),
          ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<Task> onTap;
  final ValueChanged<Task> onToggle;

  const _TaskItem({
    required this.task,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final semanticColors = Theme.of(context).extension<AppSemanticColors>()!;
    final isCompleted = task.status == TaskStatus.completed;

    return Hero(
      tag: 'task-${task.localId}',
      child: Dismissible(
        key: ValueKey(task.localId),
        direction: DismissDirection.horizontal,
        confirmDismiss: (_) async {
          onToggle(task);
          return false;
        },
        background: Container(
          margin: const EdgeInsets.only(bottom: 8),
          color: semanticColors.successContainer,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Icon(Icons.check_circle),
        ),
        secondaryBackground: Container(
          margin: const EdgeInsets.only(bottom: 8),
          color: semanticColors.successContainer,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Icon(Icons.check_circle),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(color: colorScheme.surface),
          child: ListTile(
            onTap: () => onTap(task),
            leading: Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted
                  ? semanticColors.success
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
        ),
      ),
    );
  }
}
