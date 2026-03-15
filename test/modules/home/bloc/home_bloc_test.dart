import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import 'package:task_radar/domain/task.dart';
import 'package:task_radar/domain/user.dart';
import 'package:task_radar/modules/home/bloc/home_bloc.dart';
import 'package:task_radar/modules/home/bloc/home_event.dart';
import 'package:task_radar/modules/home/bloc/home_state.dart';

import '../../../mocks.mocks.dart';

void main() {
  late MockTaskRepository taskRepository;
  late MockStorageImpl storage;
  late HomeBloc homeBloc;

  const meModel = User(
    id: '77',
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
      Task.create(userId: '1', name: 'dummy', description: 'dummy'),
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

  group('HomeBloc - load overview', () {
    test(
      'deve emitir Loading e OverviewLoaded quando consulta for bem-sucedida',
      () async {
        when(
          storage.getItemToFactory(
            StorageSecureEnum.auth_user,
            fromJson: anyNamed('fromJson'),
          ),
        ).thenAnswer((_) async => meModel);

        when(
          taskRepository.countByStatus(userId: '77'),
        ).thenAnswer((_) async => (pending: 2, completed: 5));

        homeBloc.add(HomeEventLoadOverview());

        await expectLater(
          homeBloc.stream,
          emitsInOrder([
            isA<HomeStateLoading>(),
            isA<HomeStateOverviewLoaded>()
                .having((s) => s.pending, 'pending', 2)
                .having((s) => s.completed, 'completed', 5)
                .having((s) => s.total, 'total', 7),
          ]),
        );

        verify(taskRepository.countByStatus(userId: '77')).called(1);
      },
    );

    test(
      'deve emitir Failure quando usuario autenticado nao existir no storage',
      () async {
        when(
          storage.getItemToFactory(
            StorageSecureEnum.auth_user,
            fromJson: anyNamed('fromJson'),
          ),
        ).thenAnswer((_) async => null);

        homeBloc.add(HomeEventLoadOverview());

        await expectLater(
          homeBloc.stream,
          emitsInOrder([
            isA<HomeStateLoading>(),
            isA<HomeStateFailure>().having(
              (s) => s.message,
              'message',
              'Falha ao carregar o resumo de tarefas.',
            ),
          ]),
        );

        verifyNever(taskRepository.countByStatus(userId: anyNamed('userId')));
      },
    );

    test('deve emitir Failure quando countByStatus lançar excecao', () async {
      when(
        storage.getItemToFactory(
          StorageSecureEnum.auth_user,
          fromJson: anyNamed('fromJson'),
        ),
      ).thenAnswer((_) async => meModel);

      when(
        taskRepository.countByStatus(userId: '77'),
      ).thenThrow(Exception('erro'));

      homeBloc.add(HomeEventLoadOverview());

      await expectLater(
        homeBloc.stream,
        emitsInOrder([
          isA<HomeStateLoading>(),
          isA<HomeStateFailure>().having(
            (s) => s.message,
            'message',
            'Falha ao carregar o resumo de tarefas.',
          ),
        ]),
      );
    });
  });

  group('HomeBloc - create task', () {
    test(
      'deve criar tarefa e recarregar overview emitindo Loading e OverviewLoaded',
      () async {
        when(
          storage.getItemToFactory(
            StorageSecureEnum.auth_user,
            fromJson: anyNamed('fromJson'),
          ),
        ).thenAnswer((_) async => meModel);

        when(
          taskRepository.create(
            userId: '77',
            name: 'Estudar bloc',
            description: 'Ler documentacao',
          ),
        ).thenAnswer(
          (_) async => Task.create(
            userId: '77',
            name: 'Estudar bloc',
            description: 'Ler documentacao',
          ),
        );

        when(
          taskRepository.countByStatus(userId: '77'),
        ).thenAnswer((_) async => (pending: 3, completed: 1));

        homeBloc.add(
          HomeEventCreateTask(
            name: 'Estudar bloc',
            description: 'Ler documentacao',
          ),
        );

        await expectLater(
          homeBloc.stream,
          emitsInOrder([
            isA<HomeStateLoading>(),
            isA<HomeStateOverviewLoaded>()
                .having((s) => s.pending, 'pending', 3)
                .having((s) => s.completed, 'completed', 1),
          ]),
        );

        verify(
          taskRepository.create(
            userId: '77',
            name: 'Estudar bloc',
            description: 'Ler documentacao',
          ),
        ).called(1);
        verify(taskRepository.countByStatus(userId: '77')).called(1);
      },
    );

    test('deve emitir Failure quando create lançar excecao', () async {
      when(
        storage.getItemToFactory(
          StorageSecureEnum.auth_user,
          fromJson: anyNamed('fromJson'),
        ),
      ).thenAnswer((_) async => meModel);

      when(
        taskRepository.create(userId: '77', name: 'Erro', description: 'Falhar'),
      ).thenThrow(Exception('erro ao criar'));

      homeBloc.add(HomeEventCreateTask(name: 'Erro', description: 'Falhar'));

      await expectLater(
        homeBloc.stream,
        emits(
          isA<HomeStateFailure>().having(
            (s) => s.message,
            'message',
            'Falha ao criar tarefa.',
          ),
        ),
      );

      verifyNever(taskRepository.countByStatus(userId: '77'));
    });
  });
}
