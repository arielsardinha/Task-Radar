import 'package:sqflite/sqflite.dart' show Database, ConflictAlgorithm;
import 'package:task_radar/data/services/task_page_sync_service/datasources/remote_todo.dart';
import 'package:task_radar/data/services/task_page_sync_service/datasources/sync_cursor.dart';
import 'package:task_radar/domain/task.dart';
import 'package:uuid/uuid.dart' show Uuid;
final class TaskLocalDataSource {
  final Database _db;

  const TaskLocalDataSource(this._db);

  Future<List<Map<String, Object?>>> queryPage({
    required int userId,
    required int limit,
    required int skip,
  }) {
    return _db.query(
      'tasks',
      where: 'is_deleted = 0 AND user_id = ?',
      whereArgs: [userId],
      orderBy: 'updated_at DESC, remote_id DESC',
      limit: limit,
      offset: skip,
    );
  }

  Future<int> countTasks({required int userId}) async {
    final rows = await _db.rawQuery(
      '''
      SELECT COUNT(*) AS total
      FROM tasks
      WHERE is_deleted = 0
        AND user_id = ?
      ''',
      [userId],
    );

    if (rows.isEmpty) {
      return 0;
    }

    return (rows.first['total'] as num?)?.toInt() ?? 0;
  }

  Future<SyncCursor> readSyncCursor({required int userId}) async {
    final rows = await _db.query(
      'sync_state',
      where: 'resource = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (rows.isEmpty) {
      return const SyncCursor(
        nextSkip: 0,
        remoteTotal: null,
        exhausted: false,
      );
    }

    final row = rows.first;
    return SyncCursor(
      nextSkip: (row['next_skip'] as num?)?.toInt() ?? 0,
      remoteTotal: (row['remote_total'] as num?)?.toInt(),
      exhausted: ((row['exhausted'] as num?)?.toInt() ?? 0) == 1,
    );
  }

  Future<void> writeSyncCursor({
    required int userId,
    required int nextSkip,
    required int remoteTotal,
    required bool exhausted,
  }) {
    return _db.insert('sync_state', {
      'resource': userId,
      'next_skip': nextSkip,
      'remote_total': remoteTotal,
      'exhausted': exhausted ? 1 : 0,
      'last_sync_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> upsertRemoteTodos(List<RemoteTodo> remoteTodos) async {
    if (remoteTodos.isEmpty) {
      return;
    }

    await _db.transaction((txn) async {
      final remoteIds = remoteTodos
          .map((item) => item.id)
          .toList(growable: false);
      final placeholders = List.filled(remoteIds.length, '?').join(',');

      final existingRows = await txn.query(
        'tasks',
        where: 'remote_id IN ($placeholders)',
        whereArgs: remoteIds,
      );

      final existingByRemoteId = <int, Map<String, Object?>>{
        for (final row in existingRows)
          ((row['remote_id'] as num?)?.toInt() ?? -1): row,
      };

      final now = DateTime.now();
      for (final remoteTodo in remoteTodos) {
        final existing = existingByRemoteId[remoteTodo.id];
        final isDirty = (existing?['is_dirty'] as num?)?.toInt() ?? 0;
        final isDeleted = (existing?['is_deleted'] as num?)?.toInt() ?? 0;
        if (isDirty == 1 || isDeleted == 1) {
          continue;
        }

        final normalizedTask = _normalizeRemoteTodo(
          remoteTodo: remoteTodo,
          existingRow: existing,
          now: now,
        );

        await txn.insert(
          'tasks',
          normalizedTask.toSqliteRow(isDirty: 0, isDeleted: 0),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Task _normalizeRemoteTodo({
    required RemoteTodo remoteTodo,
    required Map<String, Object?>? existingRow,
    required DateTime now,
  }) {
    final createdAt = existingRow == null
        ? now
        : DateTime.fromMillisecondsSinceEpoch(
            (existingRow['created_at'] as num?)?.toInt() ??
                now.millisecondsSinceEpoch,
          );

    return Task(
      localId: (existingRow?['local_id'] as String?) ?? const Uuid().v4(),
      remoteId: remoteTodo.id,
      userId: remoteTodo.userId,
      name: remoteTodo.todo,
      description: remoteTodo.todo,
      status: remoteTodo.completed ? TaskStatus.completed : TaskStatus.pending,
      createdAt: createdAt,
      updatedAt: now,
    );
  }


}
