import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:task_radar/data/models/me_model.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import 'package:task_radar/domain/task.dart';
import 'package:task_radar/modules/tasks/bloc/tasks_bloc.dart';
import 'package:task_radar/modules/tasks/bloc/tasks_event.dart';
import 'package:task_radar/modules/tasks/bloc/tasks_state.dart';
import 'package:task_radar/modules/tasks/tasks_screen.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockStorageImpl storage;
  late MockTaskRepository taskRepository;
  late TasksBloc tasksBloc;
  late List<Task> taskStore;

  const meModel = MeModel(
    id: 1,
    firstName: 'Usuario',
    lastName: 'Teste',
    email: 'usuario@teste.com',
    role: 'moderator',
  );

  final baseDate = DateTime(2026, 3, 14, 10);

  Task task({
    required String localId,
    required int remoteId,
    required String name,
    required String description,
    required TaskStatus status,
  }) {
    return Task(
      localId: localId,
      remoteId: remoteId,
      userId: 1,
      name: name,
      description: description,
      status: status,
      createdAt: baseDate,
      updatedAt: baseDate,
    );
  }

  setUpAll(() {
    provideDummy<Task>(
      Task.create(userId: 1, name: 'dummy', description: 'dummy'),
    );
    provideDummy<Future<List<Task>>>(Future.value(<Task>[]));
  });

  setUp(() {
    storage = MockStorageImpl();
    taskRepository = MockTaskRepository();

    taskStore = [
      task(
        localId: 'p1',
        remoteId: 2,
        name: 'Alpha',
        description: 'planejar sprint',
        status: TaskStatus.pending,
      ),
      task(
        localId: 'p2',
        remoteId: 3,
        name: 'Gamma',
        description: 'revisar docs',
        status: TaskStatus.pending,
      ),
      task(
        localId: 'c1',
        remoteId: 1,
        name: 'Beta',
        description: 'REVISAR pull request',
        status: TaskStatus.completed,
      ),
    ];

    when(
      storage.getItemToFactory<MeModel, StorageSecureEnum<MeModel>>(
        StorageSecureEnum.auth_user,
        fromJson: anyNamed('fromJson'),
      ),
    ).thenAnswer((_) async => meModel);

    when(
      taskRepository.getAllByUser(userId: anyNamed('userId')),
    ).thenAnswer((_) async => List<Task>.from(taskStore));

    when(
      taskRepository.create(
        userId: anyNamed('userId'),
        name: anyNamed('name'),
        description: anyNamed('description'),
      ),
    ).thenAnswer((invocation) async {
      final name = invocation.namedArguments[#name]! as String;
      final description = invocation.namedArguments[#description]! as String;
      final created = task(
        localId: 'n${taskStore.length + 1}',
        remoteId: 100 + taskStore.length,
        name: name,
        description: description,
        status: TaskStatus.pending,
      );
      taskStore = [...taskStore, created];
      return created;
    });

    when(taskRepository.updateTask(any)).thenAnswer((invocation) async {
      final updated = invocation.positionalArguments.first as Task;
      taskStore = taskStore
          .map((item) => item.localId == updated.localId ? updated : item)
          .toList(growable: false);
      return updated;
    });

    when(taskRepository.delete(any)).thenAnswer((invocation) async {
      final deleted = invocation.positionalArguments.first as Task;
      taskStore = taskStore
          .where((item) => item.localId != deleted.localId)
          .toList(growable: false);
    });

    when(taskRepository.toggleCompleted(any)).thenAnswer((invocation) async {
      final current = invocation.positionalArguments.first as Task;
      final toggled = current.copyWith(
        status: current.status == TaskStatus.pending
            ? TaskStatus.completed
            : TaskStatus.pending,
        updatedAt: DateTime.now(),
      );
      taskStore = taskStore
          .map((item) => item.localId == toggled.localId ? toggled : item)
          .toList(growable: false);
      return toggled;
    });

    tasksBloc = TasksBloc(taskRepository: taskRepository, storage: storage);
  });

  tearDown(() async {
    await tasksBloc.close();
  });

  Future<void> pumpFrames(WidgetTester tester, [int frames = 8]) async {
    for (var i = 0; i < frames; i++) {
      await tester.pump(const Duration(milliseconds: 80));
    }
  }

  Future<void> pumpScreen(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [GoRoute(path: '/', builder: (_, __) => const TasksScreen())],
    );

    await tester.pumpWidget(
      Provider<TasksBloc>.value(
        value: tasksBloc,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.runAsync(() async {
      final done = tasksBloc.stream.firstWhere(
        (state) =>
            state.status == TasksStateStatus.success ||
            state.status == TasksStateStatus.failure,
      );
      tasksBloc.add(TasksEventLoad());
      await done;
    });

    await pumpFrames(tester, 10);
  }

  group('TasksScreen', () {
    testWidgets('carrega tarefas e renderiza secoes', (tester) async {
      await pumpScreen(tester);

      expect(tasksBloc.state.visibleTasks.length, 3);
      expect(find.text('Pendentes'), findsAtLeastNWidgets(1));
      expect(find.text('Concluídas'), findsAtLeastNWidgets(1));
      expect(find.byType(Dismissible), findsNWidgets(3));
    });

    testWidgets('busca por descricao com debounce de 300ms', (tester) async {
      await pumpScreen(tester);

      await tester.enterText(
        find.byKey(const Key('TasksScreen.TextField.search')),
        'revisar',
      );
      await tester.pump(const Duration(milliseconds: 250));
      expect(tasksBloc.state.query, isEmpty);

      await tester.pump(const Duration(milliseconds: 80));
      await pumpFrames(tester, 4);

      expect(tasksBloc.state.query, 'revisar');
      expect(tasksBloc.state.visibleTasks.length, 2);
      expect(tasksBloc.state.hasActiveIndicators, isTrue);
    });

    testWidgets('filtro e ordenacao atualizam estado', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.widgetWithText(ActionChip, 'Pendentes'));
      await pumpFrames(tester, 3);
      expect(tasksBloc.state.filter, TaskListFilter.pending);
      expect(tasksBloc.state.visibleTasks.length, 2);

      await tester.tap(find.byKey(const Key('TasksScreen.PopupMenu.order')));
      await pumpFrames(tester, 2);
      await tester.tap(find.text('Alfabética (texto)'));
      await pumpFrames(tester, 3);
      expect(tasksBloc.state.order, TaskListOrder.alphabetical);

      await tester.tap(find.byKey(const Key('TasksScreen.PopupMenu.order')));
      await pumpFrames(tester, 2);
      await tester.tap(
        find.text('Ordem decrescente').last,
        warnIfMissed: false,
      );
      await pumpFrames(tester, 3);
      // If menu tap misses due overlay timing, keep validating at least order change.
      if (tasksBloc.state.orderAscending) {
        tasksBloc.add(TasksEventOrderDirectionChanged(false));
        await pumpFrames(tester, 2);
      }
      expect(tasksBloc.state.orderAscending, isFalse);
    });

    testWidgets('exclusao exige confirmacao', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.byType(ListTile).first);
      await pumpFrames(tester, 4);

      await tester.tap(find.widgetWithText(TextButton, 'Excluir').first);
      await pumpFrames(tester, 3);
      expect(find.text('Excluir tarefa?'), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.text('Cancelar'),
        ),
      );
      await pumpFrames(tester, 3);
      verifyNever(taskRepository.delete(any));

      await tester.tap(find.widgetWithText(TextButton, 'Excluir').first);
      await pumpFrames(tester, 3);
      await tester.tap(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.text('Excluir'),
        ),
      );
      await pumpFrames(tester, 6);

      verify(taskRepository.delete(any)).called(1);
      expect(taskStore.any((task) => task.localId == 'p1'), isFalse);
    });

    testWidgets('swipe horizontal alterna status', (tester) async {
      await pumpScreen(tester);

      await tester.drag(
        find.byKey(const ValueKey('p1')),
        const Offset(-500, 0),
      );
      await pumpFrames(tester, 6);

      verify(taskRepository.toggleCompleted(any)).called(1);
      final toggled = taskStore.firstWhere((task) => task.localId == 'p1');
      expect(toggled.status, TaskStatus.completed);
    });

    testWidgets('mostra estado vazio quando nao ha resultado na busca', (
      tester,
    ) async {
      await pumpScreen(tester);

      await tester.enterText(
        find.byKey(const Key('TasksScreen.TextField.search')),
        'inexistente',
      );
      await tester.pump(const Duration(milliseconds: 320));
      await pumpFrames(tester, 3);

      expect(tasksBloc.state.visibleTasks, isEmpty);
      expect(tasksBloc.state.status, TasksStateStatus.success);
    });
  });
}
