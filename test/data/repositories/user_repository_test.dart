import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_radar/data/adapter/request_adapter.dart';
import 'package:task_radar/data/adapter/response_adapter.dart';
import 'package:task_radar/data/repositories/user_repository.dart';
import 'package:task_radar/domain/user.dart';

import '../../mocks.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<ResponseAdapter<dynamic>>(const ResponseAdapter<dynamic>());
  });

  late MockHttpServiceAdapter httpServiceAdapter;
  late MockDatabase database;
  late UserRepositoryImpl sut;

  setUp(() {
    httpServiceAdapter = MockHttpServiceAdapter();
    database = MockDatabase();
    sut = UserRepositoryImpl(httpServiceAdapter, database: database);
  });

  group('UserRepositoryImpl.getUsers', () {
    test('deve buscar /users e retornar lista parseada de usuarios', () async {
      when(httpServiceAdapter.get<dynamic>(any)).thenAnswer(
        (_) async => const ResponseAdapter<Map<String, dynamic>>(
          statusCode: 200,
          data: {
            'users': [
              {
                'id': 1,
                'firstName': 'Maria',
                'lastName': 'Silva',
                'email': 'maria@teste.com',
                'image': 'https://dummyjson.com/icon/maria/128',
                'role': 'admin',
              },
              {
                'id': 2,
                'firstName': 'Joao',
                'lastName': 'Souza',
                'email': 'joao@teste.com',
                'image': 'https://dummyjson.com/icon/joao/128',
                'role': 'moderator',
              },
            ],
          },
        ),
      );

      final result = await sut.getUsers(limit: 15, skip: 30);

      expect(result, hasLength(2));
      expect(result.first.fullName, 'Maria Silva');
      expect(result.first.userType, UserType.admin);
      expect(result.last.fullName, 'Joao Souza');
      expect(result.last.userType, UserType.moderator);

      final request =
          verify(httpServiceAdapter.get<dynamic>(captureAny)).captured.single
              as RequestAdapter;
      expect(request.path, '/users');
      expect(request.queryParams, {
        'limit': 15,
        'skip': 30,
        'select': 'firstName,lastName,email,image,role',
      });
    });

    test('deve usar parametros padrao quando limit e skip nao forem informados', () async {
      when(httpServiceAdapter.get<dynamic>(any)).thenAnswer(
        (_) async => const ResponseAdapter<Map<String, dynamic>>(
          statusCode: 200,
          data: {'users': []},
        ),
      );

      await sut.getUsers();

      final request =
          verify(httpServiceAdapter.get<dynamic>(captureAny)).captured.single
              as RequestAdapter;
      expect(request.queryParams, {
        'limit': 30,
        'skip': 0,
        'select': 'firstName,lastName,email,image,role',
      });
    });

    test('deve lancar excecao quando status code for diferente de 200', () async {
      when(httpServiceAdapter.get<dynamic>(any)).thenAnswer(
        (_) async => const ResponseAdapter<Map<String, dynamic>>(
          statusCode: 500,
          data: {'users': []},
        ),
      );

      expect(
        () => sut.getUsers(),
        throwsA(
          isA<Exception>().having(
            (error) => error.toString(),
            'mensagem',
            contains('Falha ao consultar usuários.'),
          ),
        ),
      );
    });

    test('deve lancar excecao quando payload users nao for lista', () async {
      when(httpServiceAdapter.get<dynamic>(any)).thenAnswer(
        (_) async => const ResponseAdapter<Map<String, dynamic>>(
          statusCode: 200,
          data: {'users': {}},
        ),
      );

      expect(
        () => sut.getUsers(),
        throwsA(
          isA<Exception>().having(
            (error) => error.toString(),
            'mensagem',
            contains('Resposta inválida ao consultar usuários.'),
          ),
        ),
      );
    });

    test('deve ignorar entradas invalidas e mapear apenas itens Map', () async {
      when(httpServiceAdapter.get<dynamic>(any)).thenAnswer(
        (_) async => const ResponseAdapter<Map<String, dynamic>>(
          statusCode: 200,
          data: {
            'users': [
              1,
              'invalido',
              {
                'id': 3,
                'firstName': 'Ana',
                'lastName': 'Lima',
                'email': 'ana@teste.com',
                'image': 'https://dummyjson.com/icon/ana/128',
                'role': 'admin',
              },
            ],
          },
        ),
      );

      final result = await sut.getUsers();

      expect(result, hasLength(1));
      expect(result.single.id, '3');
      expect(result.single.fullName, 'Ana Lima');
    });
  });
}
