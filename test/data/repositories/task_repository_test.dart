import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart' show Transaction;
import 'package:task_radar/data/adapter/response_adapter.dart';
import 'package:task_radar/data/repositories/task_repository_impl.dart';
import 'package:task_radar/domain/task.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockDatabase database;
  late MockTransaction transaction;
  late MockHttpServiceAdapter client;
  late TaskRepositoryImpl sut;

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
    when(client.get<dynamic>(any)).thenThrow(Exception('api indisponivel'));
    sut = TaskRepositoryImpl(
      database: database,
      client: client,
    );
  });

  group('TaskRepositoryImpl.ensureSchema', () {
    test('deve executar criacao das tabelas e indices', () async {
      when(database.execute(any)).thenAnswer((_) async {});

      await sut.ensureSchema();

      verify(
        database.execute(argThat(contains('CREATE TABLE IF NOT EXISTS tasks'))),
      ).called(1);
      verify(
        database.execute(
          argThat(contains('CREATE INDEX IF NOT EXISTS idx_tasks_user_status')),
        ),
      ).called(1);
      verify(
        database.execute(
          argThat(contains('CREATE INDEX IF NOT EXISTS idx_tasks_updated')),
        ),
      ).called(1);
      verify(
        database.execute(
          argThat(contains('CREATE INDEX IF NOT EXISTS idx_tasks_remote_id')),
        ),
      ).called(1);
      verify(
        database.execute(
          argThat(contains('CREATE TABLE IF NOT EXISTS sync_state')),
        ),
      ).called(1);
      verifyNoMoreInteractions(database);
    });
  });

  group('TaskRepositoryImpl.create', () {
    test('deve inserir tarefa local com dirty=1 e status pending', () async {
      when(database.insert(any, any)).thenAnswer((_) async => 1);

      final result = await sut.create(
        userId: 42,
        name: 'Nova tarefa',
        description: 'Descricao da tarefa',
      );

      final captured =
          verify(database.insert('tasks', captureAny)).captured.single
              as Map<String, Object?>;

      expect(result.userId, 42);
      expect(result.name, 'Nova tarefa');
      expect(result.description, 'Descricao da tarefa');
      expect(result.status, TaskStatus.pending);
      expect(result.remoteId, isNull);

      expect(captured['user_id'], 42);
      expect(captured['name'], 'Nova tarefa');
      expect(captured['description'], 'Descricao da tarefa');
      expect(captured['status'], TaskStatus.pending.name);
      expect(captured['is_dirty'], 1);
      expect(captured['is_deleted'], 0);
      expect(captured['remote_id'], isNull);
      expect(captured['local_id'], isA<String>());
      expect(captured['created_at'], isA<int>());
      expect(captured['updated_at'], isA<int>());
    });
  });

  group('TaskRepositoryImpl.updateTask', () {
    test(
      'deve atualizar tarefa em transacao com dirty=1 quando remoteId for null',
      () async {
        when(
          database.transaction(any, exclusive: anyNamed('exclusive')),
        ).thenAnswer((invocation) {
          final callback =
              invocation.positionalArguments.first
                  as Future<void> Function(Transaction txn);
          return callback(transaction);
        });
        when(
          transaction.update(
            any,
            any,
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            conflictAlgorithm: anyNamed('conflictAlgorithm'),
          ),
        ).thenAnswer((_) async => 1);

        final task = Task.create(userId: 2, name: 'A', description: 'B');

        final updated = await sut.updateTask(task);

        expect(updated, same(task));

        final call = verify(
          transaction.update(
            'tasks',
            captureAny,
            where: captureAnyNamed('where'),
            whereArgs: captureAnyNamed('whereArgs'),
            conflictAlgorithm: captureAnyNamed('conflictAlgorithm'),
          ),
        );

        final payload = call.captured[0] as Map<String, Object?>;
        final where = call.captured[1] as String;
        final whereArgs = call.captured[2] as List<Object?>;

        expect(payload['is_dirty'], 1);
        expect(payload['is_deleted'], 0);
        expect(where, 'local_id = ?');
        expect(whereArgs, [task.localId]);
      },
    );

    test(
      'deve atualizar tarefa em transacao com dirty=0 quando remoteId existir',
      () async {
        when(
          database.transaction(any, exclusive: anyNamed('exclusive')),
        ).thenAnswer((invocation) {
          final callback =
              invocation.positionalArguments.first
                  as Future<void> Function(Transaction txn);
          return callback(transaction);
        });
        when(
          transaction.update(
            any,
            any,
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            conflictAlgorithm: anyNamed('conflictAlgorithm'),
          ),
        ).thenAnswer((_) async => 1);

        final now = DateTime.now();
        final task = Task(
          localId: 'local-1',
          remoteId: 999,
          userId: 2,
          name: 'A',
          description: 'B',
          status: TaskStatus.pending,
          createdAt: now,
          updatedAt: now,
        );

        await sut.updateTask(task);

        final payload =
            verify(
                  transaction.update(
                    'tasks',
                    captureAny,
                    where: anyNamed('where'),
                    whereArgs: anyNamed('whereArgs'),
                    conflictAlgorithm: anyNamed('conflictAlgorithm'),
                  ),
                ).captured.single
                as Map<String, Object?>;

        expect(payload['is_dirty'], 0);
        expect(payload['is_deleted'], 0);
      },
    );
  });

  group('TaskRepositoryImpl.toggleCompleted', () {
    test('deve alternar pending para completed', () async {
      when(
        database.transaction(any, exclusive: anyNamed('exclusive')),
      ).thenAnswer((invocation) {
        final callback =
            invocation.positionalArguments.first
                as Future<void> Function(Transaction txn);
        return callback(transaction);
      });
      when(
        transaction.update(
          any,
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          conflictAlgorithm: anyNamed('conflictAlgorithm'),
        ),
      ).thenAnswer((_) async => 1);

      final original = Task.create(userId: 10, name: 'x', description: 'y');

      final result = await sut.toggleCompleted(original);

      expect(result.status, TaskStatus.completed);

      final payload =
          verify(
                transaction.update(
                  'tasks',
                  captureAny,
                  where: anyNamed('where'),
                  whereArgs: anyNamed('whereArgs'),
                  conflictAlgorithm: anyNamed('conflictAlgorithm'),
                ),
              ).captured.single
              as Map<String, Object?>;

      expect(payload['status'], TaskStatus.completed.name);
      expect(payload['is_deleted'], 0);
      expect(payload['is_dirty'], 1);
    });

    test('deve alternar completed para pending', () async {
      when(
        database.transaction(any, exclusive: anyNamed('exclusive')),
      ).thenAnswer((invocation) {
        final callback =
            invocation.positionalArguments.first
                as Future<void> Function(Transaction txn);
        return callback(transaction);
      });
      when(
        transaction.update(
          any,
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          conflictAlgorithm: anyNamed('conflictAlgorithm'),
        ),
      ).thenAnswer((_) async => 1);

      final now = DateTime.now();
      final original = Task(
        localId: 'l1',
        remoteId: 30,
        userId: 10,
        name: 'x',
        description: 'y',
        status: TaskStatus.completed,
        createdAt: now,
        updatedAt: now,
      );

      final result = await sut.toggleCompleted(original);

      expect(result.status, TaskStatus.pending);

      final payload =
          verify(
                transaction.update(
                  'tasks',
                  captureAny,
                  where: anyNamed('where'),
                  whereArgs: anyNamed('whereArgs'),
                  conflictAlgorithm: anyNamed('conflictAlgorithm'),
                ),
              ).captured.single
              as Map<String, Object?>;

      expect(payload['status'], TaskStatus.pending.name);
      expect(payload['is_dirty'], 0);
      expect(payload['is_deleted'], 0);
    });
  });

  group('TaskRepositoryImpl.delete', () {
    test('deve realizar delete logico com is_deleted=1 em transacao', () async {
      when(
        database.transaction(any, exclusive: anyNamed('exclusive')),
      ).thenAnswer((invocation) {
        final callback =
            invocation.positionalArguments.first
                as Future<void> Function(Transaction txn);
        return callback(transaction);
      });
      when(
        transaction.update(
          any,
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          conflictAlgorithm: anyNamed('conflictAlgorithm'),
        ),
      ).thenAnswer((_) async => 1);

      final task = Task.create(userId: 7, name: 'name', description: 'desc');

      await sut.delete(task);

      final payload =
          verify(
                transaction.update(
                  'tasks',
                  captureAny,
                  where: captureAnyNamed('where'),
                  whereArgs: captureAnyNamed('whereArgs'),
                  conflictAlgorithm: anyNamed('conflictAlgorithm'),
                ),
              ).captured[0]
              as Map<String, Object?>;

      expect(payload['is_deleted'], 1);
      expect(payload['is_dirty'], 1);
    });
  });

  group('TaskRepositoryImpl.countByStatus', () {
    test('deve somar contagens da API com SQLite', () async {
      when(client.get<dynamic>(any)).thenAnswer(
        (_) async => const ResponseAdapter<dynamic>(
          statusCode: 200,
          data: {
            'todos': [
              {'id': 1, 'todo': 'API pending', 'completed': false, 'userId': 99},
              {'id': 2, 'todo': 'API completed', 'completed': true, 'userId': 99},
            ],
          },
        ),
      );

      when(database.rawQuery(any, any)).thenAnswer(
        (_) async => [
          {'pending_count': 3, 'completed_count': 5},
        ],
      );

      final result = await sut.countByStatus(userId: 99);

      final queryCall = verify(
        database.rawQuery(captureAny, captureAny),
      ).captured;
      expect(
        queryCall[0] as String,
        contains('SUM(CASE WHEN status = \'pending\''),
      );
      expect(queryCall[1], [99]);

      expect(result.pending, 4);
      expect(result.completed, 6);
    });

    test('deve retornar zero quando query nao tiver linhas', () async {
      when(database.rawQuery(any, any)).thenAnswer((_) async => []);

      final result = await sut.countByStatus(userId: 1);

      expect(result.pending, 0);
      expect(result.completed, 0);
    });

    test('deve considerar API quando colunas do SQLite vierem nulas', () async {
      when(client.get<dynamic>(any)).thenAnswer(
        (_) async => const ResponseAdapter<dynamic>(
          statusCode: 200,
          data: {
            'todos': [
              {'id': 10, 'todo': 'A', 'completed': false, 'userId': 1},
              {'id': 11, 'todo': 'B', 'completed': false, 'userId': 1},
            ],
          },
        ),
      );

      when(database.rawQuery(any, any)).thenAnswer(
        (_) async => [
          {'pending_count': null, 'completed_count': null},
        ],
      );

      final result = await sut.countByStatus(userId: 1);

      expect(result.pending, 2);
      expect(result.completed, 0);
    });
  });
}
