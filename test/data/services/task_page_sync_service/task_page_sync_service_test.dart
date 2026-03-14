import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart' show ConflictAlgorithm, Transaction;
import 'package:task_radar/data/adapter/request_adapter.dart';
import 'package:task_radar/data/adapter/response_adapter.dart';
import 'package:task_radar/data/services/task_page_sync_service/datasources/remote_todo.dart';
import 'package:task_radar/data/services/task_page_sync_service/datasources/task_local_datasource.dart';
import 'package:task_radar/data/services/task_page_sync_service/task_page_sync_service.dart';
import 'package:task_radar/domain/task.dart';

import '../../../mocks.mocks.dart';

void main() {
  late MockDatabase database;
  late MockTransaction transaction;
  late MockHttpServiceAdapter client;
  late TaskLocalDataSource local;
  late TaskRemoteDataSource remote;
  late TaskPageSyncService sut;

  Map<String, Object?> sqliteRow({
    required String localId,
    required int userId,
    required String name,
    required String description,
    required String status,
    required int createdAt,
    required int updatedAt,
    int? remoteId,
    int isDirty = 0,
    int isDeleted = 0,
  }) {
    return {
      'local_id': localId,
      'remote_id': remoteId,
      'user_id': userId,
      'name': name,
      'description': description,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_dirty': isDirty,
      'is_deleted': isDeleted,
    };
  }

  setUpAll(() {
    provideDummy<ResponseAdapter<dynamic>>(
      const ResponseAdapter<dynamic>(
        data: <String, dynamic>{},
        statusCode: 200,
      ),
    );
  });

  setUp(() {
    database = MockDatabase();
    transaction = MockTransaction();
    client = MockHttpServiceAdapter();
    local = TaskLocalDataSource(database);
    remote = TaskRemoteDataSource(client);
    sut = TaskPageSyncService(local: local, remote: remote, pageSize: 30);
  });

  group('TaskPageSyncService.getAllByUser', () {
    test('retorna apenas dados locais quando a pagina ja esta completa', () async {
      final now = DateTime(2026, 3, 14).millisecondsSinceEpoch;
      final localRows = [
        sqliteRow(
          localId: 'l1',
          remoteId: 100,
          userId: 1,
          name: 'A',
          description: 'A',
          status: TaskStatus.pending.name,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      when(
        database.query(
          'tasks',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          orderBy: anyNamed('orderBy'),
          limit: anyNamed('limit'),
          offset: anyNamed('offset'),
        ),
      ).thenAnswer((_) async => localRows);

      final result = await sut.getAllByUser(userId: 1, limit: 1, skip: 0);

      expect(result, hasLength(1));
      expect(result.first.localId, 'l1');
      expect(result.first.remoteId, 100);
      expect(result.first.name, 'A');

      verifyNever(client.get(any));
    });

    test('sincroniza remoto quando cache local nao completa a pagina', () async {
      final now = DateTime(2026, 3, 14).millisecondsSinceEpoch;
      var taskQueryCount = 0;

      when(
        database.query(
          'tasks',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          orderBy: anyNamed('orderBy'),
          limit: anyNamed('limit'),
          offset: anyNamed('offset'),
        ),
      ).thenAnswer((_) async {
        taskQueryCount += 1;
        if (taskQueryCount == 1) {
          return <Map<String, Object?>>[];
        }

        return [
          sqliteRow(
            localId: 'remote-101',
            remoteId: 101,
            userId: 1,
            name: 'Remote todo',
            description: 'Remote todo',
            status: TaskStatus.completed.name,
            createdAt: now,
            updatedAt: now,
          ),
        ];
      });

      var countQueryCall = 0;
      when(database.rawQuery(any, any)).thenAnswer((_) async {
        countQueryCall += 1;
        if (countQueryCall == 1) {
          return [
            {'total': 0},
          ];
        }

        return [
          {'total': 1},
        ];
      });

      when(
        database.query(
          'sync_state',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => <Map<String, Object?>>[]);

      when(
        client.get<dynamic>(
          argThat(
            isA<RequestAdapter>()
                .having((r) => r.path, 'path', '/todos/user/1')
                .having((r) => r.queryParams?['limit'], 'limit', 30)
                .having((r) => r.queryParams?['skip'], 'skip', 0),
          ),
        ),
      ).thenAnswer(
        (_) async => const ResponseAdapter<dynamic>(
          statusCode: 200,
          data: {
            'todos': [
              {'id': 101, 'todo': 'Remote todo', 'completed': true, 'userId': 1},
            ],
            'total': 1,
          },
        ),
      );

      when(
        database.transaction(any, exclusive: anyNamed('exclusive')),
      ).thenAnswer((invocation) {
        final callback =
            invocation.positionalArguments.first
                as Future<void> Function(Transaction txn);
        return callback(transaction);
      });

      when(
        transaction.query(
          'tasks',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => <Map<String, Object?>>[]);

      when(
        transaction.insert(
          any,
          any,
          nullColumnHack: anyNamed('nullColumnHack'),
          conflictAlgorithm: anyNamed('conflictAlgorithm'),
        ),
      ).thenAnswer((_) async => 1);

      when(
        database.insert(
          'sync_state',
          any,
          nullColumnHack: anyNamed('nullColumnHack'),
          conflictAlgorithm: anyNamed('conflictAlgorithm'),
        ),
      ).thenAnswer((_) async => 1);

      final result = await sut.getAllByUser(userId: 1, limit: 1, skip: 0);

      expect(result, hasLength(1));
      expect(result.first.remoteId, 101);
      expect(result.first.status, TaskStatus.completed);

      verify(
        transaction.insert(
          'tasks',
          any,
          nullColumnHack: anyNamed('nullColumnHack'),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ),
      ).called(1);

      verify(
        database.insert(
          'sync_state',
          any,
          nullColumnHack: anyNamed('nullColumnHack'),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ),
      ).called(1);
    });

    test('mantem fallback local quando API falha', () async {
      when(
        database.query(
          'tasks',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          orderBy: anyNamed('orderBy'),
          limit: anyNamed('limit'),
          offset: anyNamed('offset'),
        ),
      ).thenAnswer((_) async => <Map<String, Object?>>[]);

      when(database.rawQuery(any, any)).thenAnswer(
        (_) async => [
          {'total': 0},
        ],
      );

      when(
        database.query(
          'sync_state',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => <Map<String, Object?>>[]);

      when(client.get<dynamic>(any)).thenThrow(Exception('sem internet'));

      final result = await sut.getAllByUser(userId: 1, limit: 10, skip: 0);

      expect(result, isEmpty);
      verifyNever(
        database.insert(
          'sync_state',
          any,
          nullColumnHack: anyNamed('nullColumnHack'),
          conflictAlgorithm: anyNamed('conflictAlgorithm'),
        ),
      );
    });
  });

  group('TaskRemoteDataSource.fetchTodosPage', () {
    test('mapeia payload remoto para RemoteTodosPage', () async {
      when(
        client.get<dynamic>(
          argThat(
            isA<RequestAdapter>()
                .having((r) => r.path, 'path', '/todos/user/7')
                .having((r) => r.queryParams?['limit'], 'limit', 30)
                .having((r) => r.queryParams?['skip'], 'skip', 0),
          ),
        ),
      ).thenAnswer(
        (_) async => const ResponseAdapter<dynamic>(
          statusCode: 200,
          data: {
            'todos': [
              {'id': 1, 'todo': 'Teste', 'completed': false, 'userId': 7},
            ],
            'total': 1,
          },
        ),
      );

      final page = await remote.fetchTodosPage(userId: 7, limit: 30, skip: 0);

      expect(page.total, 1);
      expect(page.items, hasLength(1));
      expect(page.items.first.id, 1);
      expect(page.items.first.todo, 'Teste');
      expect(page.items.first.completed, isFalse);
      expect(page.items.first.userId, 7);
    });

    test('lanca excecao para payload remoto invalido', () async {
      when(
        client.get<dynamic>(any),
      ).thenAnswer(
        (_) async => const ResponseAdapter<dynamic>(statusCode: 500, data: {}),
      );

      expect(
        () => remote.fetchTodosPage(userId: 7, limit: 30, skip: 0),
        throwsException,
      );
    });
  });

  group('TaskLocalDataSource.upsertRemoteTodos', () {
    test('nao sobrescreve tarefa local marcada como dirty', () async {
      when(
        database.transaction(any, exclusive: anyNamed('exclusive')),
      ).thenAnswer((invocation) {
        final callback =
            invocation.positionalArguments.first
                as Future<void> Function(Transaction txn);
        return callback(transaction);
      });

      when(
        transaction.query(
          'tasks',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer(
        (_) async => [
          {
            'local_id': 'local-1',
            'remote_id': 101,
            'is_dirty': 1,
            'is_deleted': 0,
            'created_at': DateTime(2026, 3, 14).millisecondsSinceEpoch,
          },
        ],
      );

      when(
        transaction.insert(
          any,
          any,
          nullColumnHack: anyNamed('nullColumnHack'),
          conflictAlgorithm: anyNamed('conflictAlgorithm'),
        ),
      ).thenAnswer((_) async => 1);

      await local.upsertRemoteTodos(
        const [
          RemoteTodo(id: 101, todo: 'Nao deve sobrescrever', completed: false, userId: 1),
        ],
      );

      verifyNever(
        transaction.insert(
          any,
          any,
          nullColumnHack: anyNamed('nullColumnHack'),
          conflictAlgorithm: anyNamed('conflictAlgorithm'),
        ),
      );
    });

    test('insere tarefa remota quando nao existe local', () async {
      when(
        database.transaction(any, exclusive: anyNamed('exclusive')),
      ).thenAnswer((invocation) {
        final callback =
            invocation.positionalArguments.first
                as Future<void> Function(Transaction txn);
        return callback(transaction);
      });

      when(
        transaction.query(
          'tasks',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => <Map<String, Object?>>[]);

      when(
        transaction.insert(
          'tasks',
          any,
          nullColumnHack: anyNamed('nullColumnHack'),
          conflictAlgorithm: anyNamed('conflictAlgorithm'),
        ),
      ).thenAnswer((_) async => 1);

      await local.upsertRemoteTodos(
        const [
          RemoteTodo(id: 777, todo: 'Remota', completed: true, userId: 99),
        ],
      );

      final payload =
          verify(
                transaction.insert(
                  'tasks',
                  captureAny,
                  nullColumnHack: anyNamed('nullColumnHack'),
                  conflictAlgorithm: ConflictAlgorithm.replace,
                ),
              ).captured.single
              as Map<String, Object?>;

      expect(payload['remote_id'], 777);
      expect(payload['user_id'], 99);
      expect(payload['name'], 'Remota');
      expect(payload['description'], 'Remota');
      expect(payload['status'], TaskStatus.completed.name);
      expect(payload['is_dirty'], 0);
      expect(payload['is_deleted'], 0);
    });
  });
}
