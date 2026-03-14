import 'package:task_radar/domain/task.dart';

typedef TaskSort = ({String field, bool asc});

abstract interface class TaskRepository {
  Future<List<Task>> getAllByUser({required int userId});

  Future<Task> create({
    required int userId,
    required String name,
    required String description,
  });

  Future<Task> updateTask(Task task);

  Future<Task> toggleCompleted(Task task);

  Future<void> delete(Task task);

  Future<({int pending, int completed})> countByStatus({required int userId});
}
