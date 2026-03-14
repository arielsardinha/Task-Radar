import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_radar/data/models/me_model.dart';
import 'package:task_radar/modules/users/bloc/users_bloc.dart';
import 'package:task_radar/modules/users/bloc/users_event.dart';
import 'package:task_radar/modules/users/bloc/users_state.dart';
import '../../../mocks.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<Future<List<MeModel>>>(Future.value(const <MeModel>[]));
  });

  late MockUserRepository userRepository;
  late UsersBloc usersBloc;

  const mariaAdmin = MeModel(
    id: 1,
    firstName: 'Maria',
    lastName: 'Silva',
    email: 'maria@teste.com',
    image: 'https://dummyjson.com/icon/maria/128',
    role: 'admin',
  );

  const joaoModerator = MeModel(
    id: 2,
    firstName: 'Joao',
    lastName: 'Souza',
    email: 'joao@teste.com',
    image: 'https://dummyjson.com/icon/joao/128',
    role: 'moderator',
  );

  setUp(() {
    userRepository = MockUserRepository();
    usersBloc = UsersBloc(userRepository: userRepository);
  });

  tearDown(() async {
    await usersBloc.close();
  });

  group('UsersBloc - load', () {
    test('deve emitir loading e success ao carregar usuarios', () async {
      when(
        userRepository.getUsers(
          limit: anyNamed('limit'),
          skip: anyNamed('skip'),
        ),
      ).thenAnswer((_) async => const [mariaAdmin, joaoModerator]);

      usersBloc.add(const UsersEventLoad());

      await expectLater(
        usersBloc.stream,
        emitsInOrder([
          isA<UsersState>().having(
            (s) => s.status,
            'status',
            UsersStateStatus.loading,
          ),
          isA<UsersState>()
              .having((s) => s.status, 'status', UsersStateStatus.success)
              .having((s) => s.allUsers.length, 'allUsers.length', 2)
              .having((s) => s.visibleUsers.length, 'visibleUsers.length', 2)
              .having((s) => s.visibleUsers.first.fullName, 'first.fullName', 'Maria Silva'),
        ]),
      );

      final captured =
          verify(
            userRepository.getUsers(
              limit: captureAnyNamed('limit'),
              skip: captureAnyNamed('skip'),
            ),
          ).captured;
      expect(captured[0], 30);
      expect(captured[1], 0);
    });

    test('deve emitir loading e failure quando repository falhar', () async {
      when(
        userRepository.getUsers(
          limit: anyNamed('limit'),
          skip: anyNamed('skip'),
        ),
      ).thenThrow(Exception('falha de rede'));

      usersBloc.add(const UsersEventLoad());

      await expectLater(
        usersBloc.stream,
        emitsInOrder([
          isA<UsersState>().having(
            (s) => s.status,
            'status',
            UsersStateStatus.loading,
          ),
          isA<UsersState>()
              .having((s) => s.status, 'status', UsersStateStatus.failure)
              .having(
                (s) => s.message,
                'message',
                'Nao foi possivel carregar os usuarios.',
              ),
        ]),
      );
    });
  });

  group('UsersBloc - filters', () {
    test('deve filtrar por nome ao receber UsersEventSearchChanged', () async {
      when(
        userRepository.getUsers(
          limit: anyNamed('limit'),
          skip: anyNamed('skip'),
        ),
      ).thenAnswer((_) async => const [mariaAdmin, joaoModerator]);

      usersBloc
        ..add(const UsersEventLoad())
        ..add(const UsersEventSearchChanged('maria'));

      await expectLater(
        usersBloc.stream,
        emitsInOrder([
          isA<UsersState>().having(
            (s) => s.status,
            'status',
            UsersStateStatus.loading,
          ),
          isA<UsersState>().having(
            (s) => s.status,
            'status',
            UsersStateStatus.success,
          ),
          isA<UsersState>()
              .having((s) => s.status, 'status', UsersStateStatus.success)
              .having((s) => s.query, 'query', 'maria')
              .having((s) => s.visibleUsers.length, 'visibleUsers.length', 1)
              .having((s) => s.visibleUsers.first.fullName, 'first.fullName', 'Maria Silva'),
        ]),
      );
    });

    test('deve filtrar por role admin ao receber UsersEventFilterChanged', () async {
      when(
        userRepository.getUsers(
          limit: anyNamed('limit'),
          skip: anyNamed('skip'),
        ),
      ).thenAnswer((_) async => const [mariaAdmin, joaoModerator]);

      usersBloc
        ..add(const UsersEventLoad())
        ..add(const UsersEventFilterChanged(UsersFilter.admin));

      await expectLater(
        usersBloc.stream,
        emitsInOrder([
          isA<UsersState>().having(
            (s) => s.status,
            'status',
            UsersStateStatus.loading,
          ),
          isA<UsersState>().having(
            (s) => s.status,
            'status',
            UsersStateStatus.success,
          ),
          isA<UsersState>()
              .having((s) => s.status, 'status', UsersStateStatus.success)
              .having((s) => s.filter, 'filter', UsersFilter.admin)
              .having((s) => s.visibleUsers.length, 'visibleUsers.length', 1)
              .having((s) => s.visibleUsers.first.fullName, 'first.fullName', 'Maria Silva'),
        ]),
      );
    });
  });
}
