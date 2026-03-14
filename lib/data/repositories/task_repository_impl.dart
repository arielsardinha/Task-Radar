import 'package:sqflite/sqflite.dart' show Database;
import 'package:task_radar/data/repositories/task_repository.dart';
import 'package:task_radar/domain/task.dart';


final class TaskRepositoryImpl implements TaskRepository {
  final Database _db;

  TaskRepositoryImpl({
    required Database database,
  }) : _db = database;

  /// Garante a criacao do schema local usado pelo fluxo offline-first.
  ///
  /// Tabela `tasks`:
  /// - `local_id`: identificador local estavel (PK) usado para operacoes no app.
  /// - `remote_id`: id opcional da DummyJSON para sincronizacao com o remoto.
  /// - `user_id`: dono da tarefa no contexto autenticado.
  /// - `name`: titulo/nome da tarefa mostrado na UI.
  /// - `description`: descricao detalhada da tarefa.
  /// - `status`: estado logico (`pending` ou `completed`).
  /// - `is_dirty`: marca alteracoes locais ainda nao confirmadas no servidor.
  /// - `is_deleted`: tombstone local para exclusao logica e rollback.
  /// - `created_at`: instante de criacao em epoch millis.
  /// - `updated_at`: ultimo instante de alteracao em epoch millis.
  ///
  /// Tabela `sync_state`:
  /// - `resource`: chave do recurso sincronizado (ex.: `todos:user:<id>`).
  /// - `next_skip`: deslocamento da proxima pagina remota a buscar.
  /// - `remote_total`: total remoto conhecido para calcular exaustao.
  /// - `exhausted`: indica se todas as paginas remotas ja foram lidas.
  /// - `last_sync_at`: timestamp da ultima sincronizacao concluida.
  Future<void> ensureSchema() async {
    await _db.execute('''
    CREATE TABLE IF NOT EXISTS tasks (
      local_id     TEXT    PRIMARY KEY,
      remote_id    INTEGER UNIQUE,
      user_id      INTEGER NOT NULL,
      name         TEXT    NOT NULL,
      description  TEXT    NOT NULL,
      status       TEXT    NOT NULL CHECK(status IN ('pending','completed')),
      is_dirty     INTEGER NOT NULL DEFAULT 0,
      is_deleted   INTEGER NOT NULL DEFAULT 0,
      created_at   INTEGER NOT NULL,
      updated_at   INTEGER NOT NULL
    );
    ''');

    await _db.execute(
      'CREATE INDEX IF NOT EXISTS idx_tasks_user_status ON tasks(user_id, status);',
    );
    await _db.execute(
      'CREATE INDEX IF NOT EXISTS idx_tasks_updated ON tasks(updated_at DESC);',
    );
    await _db.execute(
      'CREATE INDEX IF NOT EXISTS idx_tasks_remote_id ON tasks(remote_id);',
    );

    await _db.execute('''
    CREATE TABLE IF NOT EXISTS sync_state (
      resource     TEXT PRIMARY KEY,
      next_skip    INTEGER NOT NULL DEFAULT 0,
      remote_total INTEGER,
      exhausted    INTEGER NOT NULL DEFAULT 0,
      last_sync_at INTEGER
    );
    ''');
  }

  @override
  Future<Task> create({
    required int userId,
    required String name,
    required String description,
  }) async {
    final task = Task.create(
      userId: userId,
      name: name,
      description: description,
    );
    await _db.insert('tasks', task.toSqliteRow(isDirty: 1));
    return task;
  }

  @override
  Future<Task> updateTask(Task task) async {
    await _db.transaction((txn) async {
      await txn.update(
        'tasks',
        task.toSqliteRow(isDirty: task.remoteId == null ? 1 : 0, isDeleted: 0),
        where: 'local_id = ?',
        whereArgs: [task.localId],
      );
    });
    return task;
  }

  @override
  Future<Task> toggleCompleted(Task task) async {
    final toggledStatus = task.status == TaskStatus.completed
        ? TaskStatus.pending
        : TaskStatus.completed;
    final updatedTask = task.copyWith(
      status: toggledStatus,
      updatedAt: DateTime.now(),
    );

    await _db.transaction((txn) async {
      await txn.update(
        'tasks',
        updatedTask.toSqliteRow(
          isDirty: task.remoteId == null ? 1 : 0,
          isDeleted: 0,
        ),
        where: 'local_id = ?',
        whereArgs: [task.localId],
      );
    });
    return updatedTask;
  }

  @override
  Future<void> delete(Task task) async {
    await _db.transaction((txn) async {
      await txn.update(
        'tasks',
        task.toSqliteRow(isDirty: task.remoteId == null ? 1 : 0, isDeleted: 1),
        where: 'local_id = ?',
        whereArgs: [task.localId],
      );
    });
  }

  @override
  Future<({int pending, int completed})> countByStatus({
    required int userId,
  }) async {
    final rows = await _db.rawQuery(
      '''
      SELECT
        SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) AS pending_count,
        SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_count
      FROM tasks
      WHERE is_deleted = 0
        AND user_id = ?
      ''',
      [userId],
    );

    final row = rows.isEmpty ? const <String, Object?>{} : rows.first;
    final pending = row['pending_count'] as int? ?? 0;
    final completed = row['completed_count'] as int? ?? 0;

    return (pending: pending, completed: completed);
  }
}
