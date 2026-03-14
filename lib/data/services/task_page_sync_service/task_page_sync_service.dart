import 'package:task_radar/data/services/task_page_sync_service/datasources/remote_todo.dart';
import 'package:task_radar/data/services/task_page_sync_service/datasources/remote_todos_page.dart';
import 'package:task_radar/data/services/task_page_sync_service/datasources/task_local_datasource.dart';
import 'package:task_radar/data/adapter/request_adapter.dart';
import 'package:task_radar/data/network/http_service_adapter.dart';
import 'package:task_radar/domain/task.dart';

final class TaskPageSyncService {
  final TaskLocalDataSource _local;
  final TaskRemoteDataSource _remote;
  final int _pageSize;

  const TaskPageSyncService({
    required TaskLocalDataSource local,
    required TaskRemoteDataSource remote,
    required int pageSize,
  }) : _local = local,
       _remote = remote,
       _pageSize = pageSize;

  Future<List<Task>> getAllByUser({
    required int userId,
    required int limit,
    required int skip,
  }) async {
    final normalizedLimit = limit <= 0 ? _pageSize : limit;
    final normalizedSkip = skip < 0 ? 0 : skip;
    final desiredCount = normalizedSkip + normalizedLimit;

    var localRows = await _local.queryPage(
      userId: userId,
      limit: normalizedLimit,
      skip: normalizedSkip,
    );

    if (localRows.length == normalizedLimit) {
      return localRows.map(Task.fromSqliteRow).toList(growable: false);
    }

    try {
      await _fillLocalCacheFromRemote(
        userId: userId,
        desiredCount: desiredCount,
      );
    } catch (_) {
      // Mantem comportamento offline-first quando a API falha.
    }

    localRows = await _local.queryPage(
      userId: userId,
      limit: normalizedLimit,
      skip: normalizedSkip,
    );
    return localRows.map(Task.fromSqliteRow).toList(growable: false);
  }

  Future<void> _fillLocalCacheFromRemote({
    required int userId,
    required int desiredCount,
  }) async {
    while (true) {
      final localCount = await _local.countTasks(userId: userId);
      if (localCount >= desiredCount) {
        return;
      }

      final syncCursor = await _local.readSyncCursor(userId: userId);
      if (syncCursor.exhausted) {
        return;
      }

      final remotePage = await _remote.fetchTodosPage(
        userId: userId,
        limit: _pageSize,
        skip: syncCursor.nextSkip,
      );

      await _local.upsertRemoteTodos(remotePage.items);

      final nextSkip = syncCursor.nextSkip + remotePage.items.length;
      final exhausted =
          remotePage.items.isEmpty ||
          remotePage.total <= nextSkip ||
          remotePage.total == 0;

      await _local.writeSyncCursor(
        userId: userId,
        nextSkip: nextSkip,
        remoteTotal: remotePage.total,
        exhausted: exhausted,
      );

      if (remotePage.items.isEmpty) {
        return;
      }
    }
  }
}


final class TaskRemoteDataSource {
  final HttpServiceAdapter _client;

  const TaskRemoteDataSource(this._client);

  Future<RemoteTodosPage> fetchTodosPage({
    required int userId,
    required int limit,
    required int skip,
  }) async {
    final response = await _client.get(
      RequestAdapter(
        path: '/todos/user/$userId',
        queryParams: {'limit': limit, 'skip': skip},
      ),
    );

    if (response.statusCode != 200 || response.data is! Map) {
      throw Exception('Falha ao carregar pagina de tarefas remotas.');
    }

    final payload = Map<String, dynamic>.from(response.data as Map);
    final todosRaw = payload['todos'];
    if (todosRaw is! List) {
      throw Exception('Resposta remota invalida para tarefas.');
    }

    final items = todosRaw
        .whereType<Map>()
        .map((json) => RemoteTodo.fromJson(Map<String, dynamic>.from(json)))
        .toList(growable: false);

    final total = (payload['total'] as num?)?.toInt() ?? (skip + items.length);

    return RemoteTodosPage(items: items, total: total);
  }
}

