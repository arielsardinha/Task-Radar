import 'package:task_radar/domain/task.dart';

enum TaskListFilter { all, pending, completed }

enum TaskListOrder { defaultById, alphabetical, completionStatus }

abstract class TasksEvent {}

final class TasksEventLoad extends TasksEvent {}

final class TasksEventSearchChanged extends TasksEvent {
  final String query;

  TasksEventSearchChanged(this.query);
}

final class TasksEventFilterChanged extends TasksEvent {
  final TaskListFilter filter;

  TasksEventFilterChanged(this.filter);
}

final class TasksEventOrderChanged extends TasksEvent {
  final TaskListOrder order;

  TasksEventOrderChanged(this.order);
}

final class TasksEventOrderDirectionChanged extends TasksEvent {
  final bool ascending;

  TasksEventOrderDirectionChanged(this.ascending);
}

final class TasksEventToggleCompleted extends TasksEvent {
  final Task task;

  TasksEventToggleCompleted(this.task);
}

final class TasksEventUpdateTask extends TasksEvent {
  final Task task;
  final String name;
  final String description;

  TasksEventUpdateTask({
    required this.task,
    required this.name,
    required this.description,
  });
}

final class TasksEventDeleteTask extends TasksEvent {
  final Task task;

  TasksEventDeleteTask(this.task);
}

final class TasksEventCreateTask extends TasksEvent {
  final String name;
  final String description;

  TasksEventCreateTask({required this.name, required this.description});
}
