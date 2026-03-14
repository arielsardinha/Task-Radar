import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:task_radar/data/models/me_model.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import 'package:task_radar/domain/task.dart';
import 'package:task_radar/domain/user.dart';
import 'package:task_radar/global/providers/provider_user.dart';
import 'package:task_radar/modules/home/bloc/home_bloc.dart';
import 'package:task_radar/modules/home/home_screen.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockTaskRepository taskRepository;
  late MockStorageImpl storage;
  late HomeBloc homeBloc;

  const meModel = MeModel(
    id: 1,
    firstName: 'Usuario',
    lastName: 'Teste',
    email: 'usuario@teste.com',
    role: 'moderator',
  );

  const domainUser = User(
    fullName: 'Usuario Teste',
    email: 'usuario@teste.com',
    phone: '11999999999',
    company: 'Task Radar',
    department: 'Produto',
    photo: 'https://dummyjson.com/icon/usuario/128',
    userType: UserType.moderator,
  );

  setUpAll(() {
    provideDummy<Task>(
      Task.create(userId: 1, name: 'dummy', description: 'dummy'),
    );
  });

  setUp(() {
    taskRepository = MockTaskRepository();
    storage = MockStorageImpl();
    homeBloc = HomeBloc(taskRepository: taskRepository, storage: storage);
  });

  tearDown(() async {
    await homeBloc.close();
  });

  Future<void> pumpHomeScreen(WidgetTester tester) async {
    final providerUser = ProviderUser()..user = domainUser;
    final router = GoRouter(
      initialLocation: '/',
      routes: [GoRoute(path: '/', builder: (_, __) => const HomeScreen())],
    );

    await tester.pumpWidget(
      Provider<ProviderUser>.value(
        value: providerUser,
        child: Provider<HomeBloc>.value(
          value: homeBloc,
          child: MaterialApp.router(routerConfig: router),
        ),
      ),
    );

    await tester.pump();
  }

  Future<void> flushBloc(WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpAndSettle();
    });
  }

  group('HomeScreen widget tests', () {
    testWidgets('deve exibir saudacao com nome do usuario', (tester) async {
      await pumpHomeScreen(tester);

      final richText = tester.widget<RichText>(find.byType(RichText).first);
      final greeting = richText.text.toPlainText();

      expect(greeting, contains('Olá,'));
      expect(greeting, contains('Usuario Teste'));
    });

    testWidgets('deve exibir loading quando estado inicial/loading', (
      tester,
    ) async {
      final loadingCompleter = Completer<MeModel?>();
      when(
        storage.getItemToFactory(
          StorageSecureEnum.auth_user,
          fromJson: anyNamed('fromJson'),
        ),
      ).thenAnswer((_) => loadingCompleter.future);

      await pumpHomeScreen(tester);
      await tester.runAsync(() async {});

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      loadingCompleter.complete(meModel);
    });

    testWidgets('deve renderizar TaskOverviewCard com dados carregados', (
      tester,
    ) async {
      when(
        storage.getItemToFactory(
          StorageSecureEnum.auth_user,
          fromJson: anyNamed('fromJson'),
        ),
      ).thenAnswer((_) async => meModel);

      when(
        taskRepository.countByStatus(userId: 1),
      ).thenAnswer((_) async => (pending: 4, completed: 8));

      await pumpHomeScreen(tester);
      await flushBloc(tester);

      expect(homeBloc.state.runtimeType.toString(), 'HomeStateOverviewLoaded');

      expect(find.text('Concluídas: 8'), findsOneWidget);
      expect(find.text('Pendentes: 4'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
    });

    testWidgets(
      'deve exibir mensagem de erro quando falhar ao carregar resumo',
      (tester) async {
        when(
          storage.getItemToFactory(
            StorageSecureEnum.auth_user,
            fromJson: anyNamed('fromJson'),
          ),
        ).thenAnswer((_) async => meModel);

        when(
          taskRepository.countByStatus(userId: 1),
        ).thenThrow(Exception('erro'));

        await pumpHomeScreen(tester);
        await flushBloc(tester);

        expect(homeBloc.state.runtimeType.toString(), 'HomeStateFailure');

        expect(
          find.text('Falha ao carregar o resumo de tarefas.'),
          findsOneWidget,
        );
      },
    );

    testWidgets('deve abrir bottom sheet ao tocar no FAB', (tester) async {
      when(
        storage.getItemToFactory(
          StorageSecureEnum.auth_user,
          fromJson: anyNamed('fromJson'),
        ),
      ).thenAnswer((_) async => meModel);

      when(
        taskRepository.countByStatus(userId: 1),
      ).thenAnswer((_) async => (pending: 1, completed: 1));

      await pumpHomeScreen(tester);
      await flushBloc(tester);

      await tester.tap(
        find.byKey(const Key('HomeScreen.FloatingActionButton.newTask')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 220));

      expect(find.text('Nova tarefa'), findsOneWidget);
      expect(find.text('Criar tarefa'), findsOneWidget);
    });

    testWidgets('deve criar tarefa ao preencher formulario e enviar', (
      tester,
    ) async {
      when(
        storage.getItemToFactory(
          StorageSecureEnum.auth_user,
          fromJson: anyNamed('fromJson'),
        ),
      ).thenAnswer((_) async => meModel);

      when(
        taskRepository.create(
          userId: 1,
          name: 'Task A',
          description: 'Descricao A',
        ),
      ).thenAnswer(
        (_) async =>
            Task.create(userId: 1, name: 'Task A', description: 'Descricao A'),
      );

      when(
        taskRepository.countByStatus(userId: 1),
      ).thenAnswer((_) async => (pending: 2, completed: 1));

      await pumpHomeScreen(tester);
      await flushBloc(tester);

      await tester.tap(
        find.byKey(const Key('HomeScreen.FloatingActionButton.newTask')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 220));

      await tester.enterText(find.byType(TextField).at(0), 'Task A');
      await tester.enterText(find.byType(TextField).at(1), 'Descricao A');
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Criar tarefa'));
      await tester.pump();
      await flushBloc(tester);
      await tester.pump(const Duration(milliseconds: 80));
      await tester.pump(const Duration(milliseconds: 260));

      verify(
        taskRepository.create(
          userId: 1,
          name: 'Task A',
          description: 'Descricao A',
        ),
      ).called(1);

      expect(find.text('Nova tarefa'), findsNothing);
    });
  });
}
