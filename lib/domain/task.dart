import 'package:uuid/uuid.dart';

enum TaskStatus { pending, completed }

final class Task {
  final String localId;
  final int? remoteId;
  final String userId;
  final String name;
  final String description;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.localId,
    required this.remoteId,
    required this.userId,
    required this.name,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Task copyWith({
    String? localId,
    int? remoteId,
    bool clearRemoteId = false,
    String? userId,
    String? name,
    String? description,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      localId: localId ?? this.localId,
      remoteId: clearRemoteId ? null : (remoteId ?? this.remoteId),
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toSqliteRow({int isDirty = 0, int isDeleted = 0}) {
    return {
      'local_id': localId,
      'remote_id': remoteId,
      'user_id': userId,
      'name': name,
      'description': description,
      'status': status.name,
      'is_dirty': isDirty,
      'is_deleted': isDeleted,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Task.fromDummyjson(
    Map<String, dynamic> json, {
    required DateTime now,
    required String userId,
  }) {
    final id = int.tryParse(json['id']?.toString() ?? '0') ?? 0;
    return Task(
      localId: id.toString(),
      remoteId: id,
      userId: userId,
      name: json['todo'] ?? '',
      description: json['todo'] ?? '',
      status: json['completed'] == true
          ? TaskStatus.completed
          : TaskStatus.pending,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Task.fromSqliteRow(Map<String, Object?> row) {
    return Task(
      localId: row['local_id'] as String,
      remoteId: row['remote_id'] as int?,
      userId: row['user_id'] as String,
      name: (row['name'] as String?) ?? '',
      description: (row['description'] as String?) ?? '',
      status: row['status'] == TaskStatus.completed.name
          ? TaskStatus.completed
          : TaskStatus.pending,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (row['created_at'] as int?) ?? 0,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (row['updated_at'] as int?) ?? 0,
      ),
    );
  }

  factory Task.create({
    required String userId,
    required String name,
    required String description,
  }) {
    final now = DateTime.now();
    return Task(
      localId: const Uuid().v4(),
      remoteId: null,
      userId: userId,
      name: name,
      description: description,
      status: TaskStatus.pending,
      createdAt: now,
      updatedAt: now,
    );
  }
}
