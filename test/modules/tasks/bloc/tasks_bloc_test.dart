import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_radar/data/models/me_model.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import 'package:task_radar/domain/task.dart';
import 'package:task_radar/modules/tasks/bloc/tasks_bloc.dart';
import 'package:task_radar/modules/tasks/bloc/tasks_event.dart';
import 'package:task_radar/modules/tasks/bloc/tasks_state.dart';

import '../../../mocks.mocks.dart';

void main() {
  late MockTaskRepository taskRepository;
  late MockStorageImpl storage;
  late TasksBloc tasksBloc;

  const meModel = MeModel(
    id: 77,
    firstName: 'Usuario',
    lastName: 'Teste',
    email: 'usuario@teste.com',
    role: 'moderator',
  );

  final createdAt = DateTime(2026, 1, 1, 10, 0);

  Task buildTask({
    required String localId,
    required int remoteId,
    required String name,
    required String description,
    required TaskStatus status,
  }) {
    return Task(
      localId: localId,
      remoteId: remoteId,
      userId: 77,
      name: name,
      description: description,
      status: status,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
  }

  late Task pendingAlpha;
  late Task completedBeta;
  late Task pendingGamma;

  setUpAll(() {
    provideDummy<Future<List<Task>>>(Future.value(<Task>[]));
    provideDummy<Future<Task>>(
      Future.value(Task.create(userId: 1, name: 'dummy', description: 'dummy')),
    );
    provideDummy<Task>(
      Task.create(userId: 1, name: 'dummy', description: 'dummy'),
    );
  });

  void stubAuthenticated([MeModel? value]) {
    when(
      storage.getItemToFactory<MeModel, StorageSecureEnum<MeModel>>(
        StorageSecureEnum.auth_user,
        fromJson: anyNamed('fromJson'),
      ),
    ).thenAnswer((_) async => value ?? meModel);
  }

  setUp(() {
    taskRepository = MockTaskRepository();
    storage = MockStorageImpl();
    tasksBloc = TasksBloc(taskRepository: taskRepository, storage: storage);

    pendingAlpha = buildTask(
      localId: 'l1',
      remoteId: 1,
      name: 'Alpha',
      description: 'planejar sprint',
      status: TaskStatus.pending,
    );

    completedBeta = buildTask(
      localId: 'l2',
      remoteId: 2,
      name: 'Beta',
      description: 'revisar PR',
      status: TaskStatus.completed,
    );

    pendingGamma = buildTask(
      localId: 'l3',
      remoteId: 3,
      name: 'Gamma',
      description: 'ajustar docs',
      status: TaskStatus.pending,
    );
  });

  tearDown(() async {
    await tasksBloc.close();
  });

  group('TasksBloc - load', () {
    test('deve emitir Loading e Success ao carregar tarefas', () async {
      stubAuthenticated();
      final tasks = [pendingAlpha, completedBeta, pendingGamma];
      when(
        taskRepository.getAllByUser(userId: 77),
      ).thenAnswer((_) async => tasks);

      tasksBloc.add(TasksEventLoad());

      await expectLater(
        tasksBloc.stream,
        emitsInOrder([
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.loading,
          ),
          isA<TasksState>()
              .having((s) => s.status, 'status', TasksStateStatus.success)
              .having((s) => s.visibleTasks.length, 'visibleTasks.length', 3),
        ]),
      );

      verify(taskRepository.getAllByUser(userId: 77)).called(1);
    });

    test('deve emitir Failure quando user id for nulo', () async {
      stubAuthenticated(meModel.copyWith(id: null));

      tasksBloc.add(TasksEventLoad());

      await expectLater(
        tasksBloc.stream,
        emitsInOrder([
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.loading,
          ),
          isA<TasksState>()
              .having((s) => s.status, 'status', TasksStateStatus.failure)
              .having(
                (s) => s.message,
                'message',
                'Nao foi possivel identificar o usuario autenticado.',
              ),
        ]),
      );

      verifyZeroInteractions(taskRepository);
    });

    test('deve emitir Failure quando getAllByUser lancar excecao', () async {
      stubAuthenticated();
      when(
        taskRepository.getAllByUser(userId: 77),
      ).thenThrow(Exception('erro'));

      tasksBloc.add(TasksEventLoad());

      await expectLater(
        tasksBloc.stream,
        emitsInOrder([
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.loading,
          ),
          isA<TasksState>()
              .having((s) => s.status, 'status', TasksStateStatus.failure)
              .having(
                (s) => s.message,
                'message',
                'Falha ao carregar tarefas.',
              ),
        ]),
      );
    });
  });

  group('TasksBloc - view operations', () {
    test('deve filtrar busca por descricao', () async {
      stubAuthenticated();
      final tasks = [pendingAlpha, completedBeta, pendingGamma];
      when(
        taskRepository.getAllByUser(userId: 77),
      ).thenAnswer((_) async => tasks);

      tasksBloc
        ..add(TasksEventLoad())
        ..add(TasksEventSearchChanged('revisar'));

      await expectLater(
        tasksBloc.stream,
        emitsInOrder([
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.loading,
          ),
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.success,
          ),
          isA<TasksState>()
              .having((s) => s.query, 'query', 'revisar')
              .having((s) => s.visibleTasks.length, 'visibleTasks.length', 1)
              .having(
                (s) => s.visibleTasks.first.localId,
                'first.localId',
                'l2',
              ),
        ]),
      );
    });

    test('deve aplicar filtro e ordenacao desc alfabetica', () async {
      stubAuthenticated();
      final tasks = [pendingGamma, completedBeta, pendingAlpha];
      when(
        taskRepository.getAllByUser(userId: 77),
      ).thenAnswer((_) async => tasks);

      tasksBloc
        ..add(TasksEventLoad())
        ..add(TasksEventFilterChanged(TaskListFilter.pending))
        ..add(TasksEventOrderChanged(TaskListOrder.alphabetical))
        ..add(TasksEventOrderDirectionChanged(false));

      await expectLater(
        tasksBloc.stream,
        emitsInOrder([
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.loading,
          ),
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.success,
          ),
          isA<TasksState>().having(
            (s) => s.filter,
            'filter',
            TaskListFilter.pending,
          ),
          isA<TasksState>().having(
            (s) => s.order,
            'order',
            TaskListOrder.alphabetical,
          ),
          isA<TasksState>()
              .having((s) => s.orderAscending, 'orderAscending', false)
              .having((s) => s.visibleTasks.length, 'visibleTasks.length', 2)
              .having((s) => s.visibleTasks.first.name, 'first.name', 'Gamma')
              .having((s) => s.visibleTasks.last.name, 'last.name', 'Alpha'),
        ]),
      );
    });

    test('deve ordenar por status de conclusao', () async {
      stubAuthenticated();
      final tasks = [pendingAlpha, completedBeta, pendingGamma];
      when(
        taskRepository.getAllByUser(userId: 77),
      ).thenAnswer((_) async => tasks);

      tasksBloc
        ..add(TasksEventLoad())
        ..add(TasksEventOrderChanged(TaskListOrder.completionStatus));

      await expectLater(
        tasksBloc.stream,
        emitsInOrder([
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.loading,
          ),
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.success,
          ),
          isA<TasksState>()
              .having((s) => s.order, 'order', TaskListOrder.completionStatus)
              .having(
                (s) => s.visibleTasks.first.status,
                'first.status',
                TaskStatus.completed,
              ),
        ]),
      );
    });
  });

  group('TasksBloc - mutation operations', () {
    test('deve atualizar tarefa e recarregar lista', () async {
      stubAuthenticated();
      final tasks = [pendingAlpha, completedBeta];
      when(
        taskRepository.getAllByUser(userId: 77),
      ).thenAnswer((_) async => tasks);
      when(
        taskRepository.updateTask(any),
      ).thenAnswer((_) async => pendingAlpha);

      tasksBloc
        ..add(TasksEventLoad())
        ..add(
          TasksEventUpdateTask(
            task: pendingAlpha,
            name: 'Alpha editada',
            description: 'nova descricao',
          ),
        );

      await expectLater(
        tasksBloc.stream,
        emitsInOrder([
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.loading,
          ),
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.success,
          ),
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.loading,
          ),
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.success,
          ),
        ]),
      );

      verify(
        taskRepository.updateTask(
          argThat(
            isA<Task>()
                .having((t) => t.localId, 'localId', pendingAlpha.localId)
                .having((t) => t.name, 'name', 'Alpha editada')
                .having((t) => t.description, 'description', 'nova descricao'),
          ),
        ),
      ).called(1);
      verify(
        taskRepository.getAllByUser(userId: 77),
      ).called(greaterThanOrEqualTo(2));
    });

    test('deve excluir tarefa e recarregar lista', () async {
      stubAuthenticated();
      final tasks = [pendingAlpha, completedBeta];
      when(
        taskRepository.getAllByUser(userId: 77),
      ).thenAnswer((_) async => tasks);
      when(
        taskRepository.delete(any),
      ).thenAnswer((_) async => Future<void>.value());

      tasksBloc
        ..add(TasksEventLoad())
        ..add(TasksEventDeleteTask(pendingAlpha));

      await expectLater(
        tasksBloc.stream,
        emitsInOrder([
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.loading,
          ),
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.success,
          ),
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.loading,
          ),
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.success,
          ),
        ]),
      );

      verify(taskRepository.delete(pendingAlpha)).called(1);
      verify(
        taskRepository.getAllByUser(userId: 77),
      ).called(greaterThanOrEqualTo(2));
    });

    test('deve emitir Failure quando toggleCompleted falhar', () async {
      when(
        taskRepository.toggleCompleted(pendingAlpha),
      ).thenThrow(Exception('erro'));

      tasksBloc.add(TasksEventToggleCompleted(pendingAlpha));

      await expectLater(
        tasksBloc.stream,
        emits(
          isA<TasksState>()
              .having((s) => s.status, 'status', TasksStateStatus.failure)
              .having(
                (s) => s.message,
                'message',
                'Falha ao atualizar status da tarefa.',
              ),
        ),
      );
    });

    test(
      'deve alternar status e recarregar lista quando toggle funcionar',
      () async {
        stubAuthenticated();
        final tasks = [pendingAlpha, completedBeta];
        when(
          taskRepository.getAllByUser(userId: 77),
        ).thenAnswer((_) async => tasks);
        when(taskRepository.toggleCompleted(pendingAlpha)).thenAnswer(
          (_) async => pendingAlpha.copyWith(status: TaskStatus.completed),
        );

        tasksBloc
          ..add(TasksEventLoad())
          ..add(TasksEventToggleCompleted(pendingAlpha));

        await expectLater(
          tasksBloc.stream,
          emitsInOrder([
            isA<TasksState>().having(
              (s) => s.status,
              'status',
              TasksStateStatus.loading,
            ),
            isA<TasksState>().having(
              (s) => s.status,
              'status',
              TasksStateStatus.success,
            ),
            isA<TasksState>().having(
              (s) => s.status,
              'status',
              TasksStateStatus.loading,
            ),
            isA<TasksState>().having(
              (s) => s.status,
              'status',
              TasksStateStatus.success,
            ),
          ]),
        );

        verify(taskRepository.toggleCompleted(pendingAlpha)).called(1);
        verify(taskRepository.getAllByUser(userId: 77)).called(greaterThan(1));
      },
    );

    test('deve emitir Failure quando updateTask falhar', () async {
      when(taskRepository.updateTask(any)).thenThrow(Exception('erro'));

      tasksBloc.add(
        TasksEventUpdateTask(
          task: pendingAlpha,
          name: 'Alpha editada',
          description: 'nova descricao',
        ),
      );

      await expectLater(
        tasksBloc.stream,
        emits(
          isA<TasksState>()
              .having((s) => s.status, 'status', TasksStateStatus.failure)
              .having(
                (s) => s.message,
                'message',
                'Falha ao atualizar tarefa.',
              ),
        ),
      );
    });

    test('deve emitir Failure quando delete falhar', () async {
      when(taskRepository.delete(any)).thenThrow(Exception('erro'));

      tasksBloc.add(TasksEventDeleteTask(pendingAlpha));

      await expectLater(
        tasksBloc.stream,
        emits(
          isA<TasksState>()
              .having((s) => s.status, 'status', TasksStateStatus.failure)
              .having((s) => s.message, 'message', 'Falha ao excluir tarefa.'),
        ),
      );
    });

    test('deve criar tarefa e recarregar lista', () async {
      stubAuthenticated();
      when(
        taskRepository.create(
          userId: 77,
          name: 'Nova',
          description: 'Descricao',
        ),
      ).thenAnswer((_) async => pendingAlpha);
      when(
        taskRepository.getAllByUser(userId: 77),
      ).thenAnswer((_) async => [pendingAlpha]);

      tasksBloc.add(
        TasksEventCreateTask(name: 'Nova', description: 'Descricao'),
      );

      await expectLater(
        tasksBloc.stream,
        emitsInOrder([
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.loading,
          ),
          isA<TasksState>().having(
            (s) => s.status,
            'status',
            TasksStateStatus.success,
          ),
        ]),
      );

      verify(
        taskRepository.create(
          userId: 77,
          name: 'Nova',
          description: 'Descricao',
        ),
      ).called(1);
      verify(taskRepository.getAllByUser(userId: 77)).called(1);
    });

    test('deve emitir Failure quando create falhar', () async {
      stubAuthenticated();
      when(
        taskRepository.create(
          userId: 77,
          name: 'Nova',
          description: 'Descricao',
        ),
      ).thenThrow(Exception('erro'));

      tasksBloc.add(
        TasksEventCreateTask(name: 'Nova', description: 'Descricao'),
      );

      await expectLater(
        tasksBloc.stream,
        emits(
          isA<TasksState>()
              .having((s) => s.status, 'status', TasksStateStatus.failure)
              .having((s) => s.message, 'message', 'Falha ao criar tarefa.'),
        ),
      );
    });

    test('deve emitir Failure quando create for chamado sem user id', () async {
      stubAuthenticated(meModel.copyWith(id: null));

      tasksBloc.add(
        TasksEventCreateTask(name: 'Nova', description: 'Descricao'),
      );

      await expectLater(
        tasksBloc.stream,
        emits(
          isA<TasksState>()
              .having((s) => s.status, 'status', TasksStateStatus.failure)
              .having(
                (s) => s.message,
                'message',
                'Nao foi possivel identificar o usuario autenticado.',
              ),
        ),
      );

      verifyNever(
        taskRepository.create(
          userId: anyNamed('userId'),
          name: anyNamed('name'),
          description: anyNamed('description'),
        ),
      );
    });
  });

  group('TasksBloc - pagination', () {
    test('deve carregar proxima pagina ao receber TasksEventLoadMore', () async {
      stubAuthenticated();
      final firstPage = List.generate(30, (index) {
        return buildTask(
          localId: 'p$index',
          remoteId: index + 1,
          name: 'Task $index',
          description: 'descricao $index',
          status: TaskStatus.pending,
        );
      });
      final secondPage = [
        buildTask(
          localId: 'p31',
          remoteId: 31,
          name: 'Task 31',
          description: 'descricao 31',
          status: TaskStatus.completed,
        ),
      ];

      when(taskRepository.getAllByUser(userId: 77, limit: 30, skip: 0)).thenAnswer(
        (_) async => firstPage,
      );
      when(
        taskRepository.getAllByUser(userId: 77, limit: 30, skip: 30),
      ).thenAnswer((_) async => secondPage);

      tasksBloc.add(TasksEventLoad());
      await untilCalled(taskRepository.getAllByUser(userId: 77, limit: 30, skip: 0));
      await Future<void>.delayed(Duration.zero);

      expect(tasksBloc.state.status, TasksStateStatus.success);
      expect(tasksBloc.state.allTasks.length, 30);
      expect(tasksBloc.state.hasReachedEnd, isFalse);

      tasksBloc.add(TasksEventLoadMore());
      await untilCalled(taskRepository.getAllByUser(userId: 77, limit: 30, skip: 30));
      await Future<void>.delayed(Duration.zero);

      expect(tasksBloc.state.status, TasksStateStatus.success);
      expect(tasksBloc.state.isLoadingMore, isFalse);
      expect(tasksBloc.state.allTasks.length, 31);
      expect(tasksBloc.state.hasReachedEnd, isTrue);

      verify(taskRepository.getAllByUser(userId: 77, limit: 30, skip: 30)).called(1);
    });

    test('nao deve carregar mais quando fim da lista foi atingido', () async {
      stubAuthenticated();
      final firstPage = [
        pendingAlpha,
        completedBeta,
      ];

      when(taskRepository.getAllByUser(userId: 77, limit: 30, skip: 0)).thenAnswer(
        (_) async => firstPage,
      );

      tasksBloc.add(TasksEventLoad());
      await untilCalled(taskRepository.getAllByUser(userId: 77, limit: 30, skip: 0));
      await Future<void>.delayed(Duration.zero);

      expect(tasksBloc.state.hasReachedEnd, isTrue);

      tasksBloc.add(TasksEventLoadMore());
      await Future<void>.delayed(const Duration(milliseconds: 20));

      verifyNever(taskRepository.getAllByUser(userId: 77, limit: 30, skip: 2));
    });
  });
}
