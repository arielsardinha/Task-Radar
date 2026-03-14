import 'package:task_radar/domain/task.dart';
import 'package:task_radar/modules/tasks/bloc/tasks_event.dart';

enum TasksStateStatus { initial, loading, success, failure }

final class TasksState {
  final TasksStateStatus status;
  final List<Task> allTasks;
  final List<Task> visibleTasks;
  final TaskListFilter filter;
  final TaskListOrder order;
  final bool orderAscending;
  final String query;
  final String? message;

  const TasksState({
    required this.status,
    required this.allTasks,
    required this.visibleTasks,
    required this.filter,
    required this.order,
    required this.orderAscending,
    required this.query,
    this.message,
  });

  const TasksState.initial()
    : this(
        status: TasksStateStatus.initial,
        allTasks: const [],
        visibleTasks: const [],
        filter: TaskListFilter.all,
        order: TaskListOrder.defaultById,
        orderAscending: true,
        query: '',
      );

  List<Task> get pendingTasks =>
      visibleTasks.where((task) => task.status == TaskStatus.pending).toList();

  List<Task> get completedTasks => visibleTasks
      .where((task) => task.status == TaskStatus.completed)
      .toList();

  bool get hasActiveIndicators {
    return filter != TaskListFilter.all || query.trim().isNotEmpty;
  }

  TasksState copyWith({
    TasksStateStatus? status,
    List<Task>? allTasks,
    List<Task>? visibleTasks,
    TaskListFilter? filter,
    TaskListOrder? order,
    bool? orderAscending,
    String? query,
    String? message,
    bool clearMessage = false,
  }) {
    return TasksState(
      status: status ?? this.status,
      allTasks: allTasks ?? this.allTasks,
      visibleTasks: visibleTasks ?? this.visibleTasks,
      filter: filter ?? this.filter,
      order: order ?? this.order,
      orderAscending: orderAscending ?? this.orderAscending,
      query: query ?? this.query,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}
