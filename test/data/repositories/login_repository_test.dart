import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_radar/data/adapter/http_error_adapter.dart';

import 'package:task_radar/data/adapter/request_adapter.dart';
import 'package:task_radar/data/adapter/response_adapter.dart';
import 'package:task_radar/data/repositories/auth_repository.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import '../../mocks.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<ResponseAdapter<dynamic>>(const ResponseAdapter<dynamic>());
  });

  late MockHttpServiceAdapter httpServiceAdapter;
  late MockStorage storage;
  late MockDatabase database;
  late MockTransaction transaction;
  late AuthRepositoryImpl sut;

  setUp(() {
    httpServiceAdapter = MockHttpServiceAdapter();
    storage = MockStorage();
    database = MockDatabase();
    transaction = MockTransaction();

    when(database.execute(any)).thenAnswer((_) async {});
    when(database.query(any, limit: anyNamed('limit'))).thenAnswer((_) async => []);
    when(
      database.transaction(any, exclusive: anyNamed('exclusive')),
    ).thenAnswer((invocation) {
      final callback =
          invocation.positionalArguments.first
              as Future<void> Function(dynamic txn);
      return callback(transaction);
    });
    when(transaction.delete(any)).thenAnswer((_) async => 1);
    when(transaction.insert(any, any)).thenAnswer((_) async => 1);

    sut = AuthRepositoryImpl(
      httpServiceAdapter,
      storage,
      databaseProvider: () async => database,
    );
  });

  group('AuthRepositoryImpl', () {
    test(
      'deve realizar login, buscar /auth/me e salvar tokens e usuario no storage',
      () async {
        when(httpServiceAdapter.post<dynamic>(any)).thenAnswer(
          (_) async => const ResponseAdapter<Map<String, dynamic>>(
            statusCode: 200,
            data: {
              'id': 1,
              'username': 'usuario_teste',
              'email': 'usuario@teste.com',
              'firstName': 'Usuario',
              'lastName': 'Teste',
              'image': 'https://dummyjson.com/icon/usuario/128',
              'accessToken': 'access-token-valido',
              'refreshToken': 'refresh-token-valido',
            },
          ),
        );

        when(httpServiceAdapter.get<dynamic>(any)).thenAnswer(
          (_) async => const ResponseAdapter<Map<String, dynamic>>(
            statusCode: 200,
            data: {
              'id': 1,
              'username': 'usuario_teste',
              'firstName': 'Usuario',
              'lastName': 'Teste',
              'email': 'usuario@teste.com',
              'phone': '11999999999',
              'image': 'https://dummyjson.com/icon/usuario/128',
              'role': 'admin',
              'company': {'name': 'Task Radar', 'department': 'Produto'},
            },
          ),
        );

        when(storage.setItem(any, any)).thenAnswer((_) async {});

        final user = await sut.login('usuario_teste', 'senha123');

        expect(user.userType.name, 'admin');

        final capturedRequest =
            verify(httpServiceAdapter.post<dynamic>(captureAny)).captured.single
                as RequestAdapter;
        expect(capturedRequest.path, '/auth/login');
        expect(capturedRequest.data, {
          'username': 'usuario_teste',
          'password': 'senha123',
        });

        final capturedMeRequest =
            verify(httpServiceAdapter.get<dynamic>(captureAny)).captured.single
                as RequestAdapter;
        expect(capturedMeRequest.path, '/auth/me');
        expect(capturedMeRequest.headers, {
          'Authorization': 'Bearer access-token-valido',
        });

        verifyInOrder([
          storage.setItem(StorageSecureEnum.auth_jwt, {
            'refresh_token': 'refresh-token-valido',
            'token': 'access-token-valido',
          }),
          storage.setItem(
            StorageSecureEnum.auth_user,
            argThat(
              isA<Map<String, dynamic>>()
                  .having((m) => m['id'], 'id', 1)
                  .having((m) => m['username'], 'username', 'usuario_teste')
                  .having((m) => m['email'], 'email', 'usuario@teste.com')
                  .having((m) => m['firstName'], 'firstName', 'Usuario')
                  .having((m) => m['lastName'], 'lastName', 'Teste')
                  .having((m) => m['role'], 'role', 'admin')
                  .having(
                    (m) => m['image'],
                    'image',
                    'https://dummyjson.com/icon/usuario/128',
                  ),
            ),
          ),
        ]);
        verify(database.execute(argThat(contains('CREATE TABLE IF NOT EXISTS logged_user')))).called(1);
        verify(transaction.delete('logged_user')).called(1);
        verify(
          transaction.insert(
            'logged_user',
            argThat(
              isA<Map<String, Object?>>()
                  .having((m) => m['full_name'], 'full_name', 'Usuario Teste')
                  .having((m) => m['email'], 'email', 'usuario@teste.com')
                  .having((m) => m['phone'], 'phone', '11999999999')
                  .having((m) => m['company'], 'company', 'Task Radar')
                  .having((m) => m['department'], 'department', 'Produto')
                  .having(
                    (m) => m['photo'],
                    'photo',
                    'https://dummyjson.com/icon/usuario/128',
                  )
                  .having((m) => m['user_type'], 'user_type', 'admin'),
            ),
          ),
        ).called(1);
      },
    );

    test(
      'deve lançar excecao quando status code for diferente de 200',
      () async {
        when(httpServiceAdapter.post<dynamic>(any)).thenAnswer(
          (_) async => const ResponseAdapter<Map<String, dynamic>>(
            statusCode: 401,
            data: {
              'accessToken': 'access-token',
              'refreshToken': 'refresh-token',
            },
          ),
        );

        expect(
          () => sut.login('usuario_teste', 'senha123'),
          throwsA(
            isA<Exception>().having(
              (error) => error.toString(),
              'mensagem',
              contains('falha ao realizar login: 401'),
            ),
          ),
        );

        verifyNever(storage.setItem(any, any));
      },
    );

    test(
      'deve lançar excecao quando resposta nao tiver accessToken e refreshToken',
      () async {
        when(httpServiceAdapter.post<dynamic>(any)).thenAnswer(
          (_) async => const ResponseAdapter<Map<String, dynamic>>(
            statusCode: 200,
            data: {'token': 'campo-incorreto'},
          ),
        );

        expect(
          () => sut.login('usuario_teste', 'senha123'),
          throwsA(
            isA<Exception>().having(
              (error) => error.toString(),
              'mensagem',
              contains('falha ao realizar login: 200'),
            ),
          ),
        );

        verifyNever(storage.setItem(any, any));
      },
    );

    test('deve adaptar HttpError para excecao de login', () async {
      when(httpServiceAdapter.post<dynamic>(any)).thenThrow(
        const HttpError(
          response: ResponseAdapter(statusCode: 401),
          statusMessage: 'Credenciais invalidas',
        ),
      );

      expect(
        () => sut.login('usuario_teste', 'senha123'),
        throwsA(
          isA<Exception>().having(
            (error) => error.toString(),
            'mensagem',
            contains('Login failed: Credenciais invalidas'),
          ),
        ),
      );

      verifyNever(storage.setItem(any, any));
    });

    test(
      'deve lançar excecao contextual quando falhar ao obter perfil apos login',
      () async {
        when(httpServiceAdapter.post<dynamic>(any)).thenAnswer(
          (_) async => const ResponseAdapter<Map<String, dynamic>>(
            statusCode: 200,
            data: {
              'accessToken': 'access-token-valido',
              'refreshToken': 'refresh-token-valido',
            },
          ),
        );

        when(storage.setItem(any, any)).thenAnswer((_) async {});
        when(httpServiceAdapter.get<dynamic>(any)).thenThrow(
          const HttpError(
            response: ResponseAdapter(statusCode: 401),
            statusMessage: 'token invalido',
          ),
        );

        expect(
          () => sut.login('usuario_teste', 'senha123'),
          throwsA(
            isA<Exception>().having(
              (error) => error.toString(),
              'mensagem',
              contains('Falha ao obter perfil do usuário'),
            ),
          ),
        );
      },
    );

    test(
      'refreshSession deve limpar storage e retornar null quando refreshToken for vazio',
      () async {
        final result = await sut.refreshSession('   ');

        expect(result, isNull);
        verify(storage.removeAll()).called(1);
        verifyNever(httpServiceAdapter.post<dynamic>(any));
        verifyNever(httpServiceAdapter.get<dynamic>(any));
      },
    );

    test(
      'refreshSession deve limpar storage quando refresh retornar resposta invalida',
      () async {
        when(httpServiceAdapter.post<dynamic>(any)).thenAnswer(
          (_) async => const ResponseAdapter<Map<String, dynamic>>(
            statusCode: 500,
            data: {'message': 'erro interno'},
          ),
        );

        final result = await sut.refreshSession('refresh-antigo');

        expect(result, isNull);
        verify(storage.removeAll()).called(1);
        verifyNever(storage.setItem(StorageSecureEnum.auth_jwt, any));
        verifyNever(httpServiceAdapter.get<dynamic>(any));
      },
    );

    test(
      'refreshSession deve atualizar tokens e retornar usuario obtido em /auth/me',
      () async {
        when(httpServiceAdapter.post<dynamic>(any)).thenAnswer(
          (_) async => const ResponseAdapter<Map<String, dynamic>>(
            statusCode: 200,
            data: {'accessToken': 'token-novo', 'refreshToken': 'refresh-novo'},
          ),
        );

        when(httpServiceAdapter.get<dynamic>(any)).thenAnswer(
          (_) async => const ResponseAdapter<Map<String, dynamic>>(
            statusCode: 200,
            data: {
              'id': 1,
              'username': 'usuario_teste',
              'email': 'usuario@teste.com',
              'firstName': 'Usuario',
              'lastName': 'Teste',
              'phone': '11999999999',
              'image': 'https://dummyjson.com/icon/usuario/128',
              'role': 'admin',
              'company': {'name': 'Task Radar', 'department': 'Produto'},
            },
          ),
        );

        when(storage.setItem(any, any)).thenAnswer((_) async {});

        final result = await sut.refreshSession('refresh-antigo');

        expect(result, isNotNull);
        expect(result!.fullName, 'Usuario Teste');
        expect(result.userType.name, 'admin');

        final capturedRefreshRequest =
            verify(httpServiceAdapter.post<dynamic>(captureAny)).captured.single
                as RequestAdapter;
        expect(capturedRefreshRequest.path, '/auth/refresh');
        expect(capturedRefreshRequest.data, {
          'refreshToken': 'refresh-antigo',
          'expiresInMins': 30,
        });

        verify(
          storage.setItem(StorageSecureEnum.auth_jwt, {
            'refresh_token': 'refresh-novo',
            'token': 'token-novo',
          }),
        ).called(1);
        verify(httpServiceAdapter.get<dynamic>(any)).called(1);
        verifyNever(storage.removeAll());
      },
    );

    test(
      'refreshSession deve buscar /auth/me quando auth_user nao existir em cache',
      () async {
        when(
          storage.getItemToFactory(
            StorageSecureEnum.auth_user,
            fromJson: anyNamed('fromJson'),
          ),
        ).thenAnswer((_) async => null);

        when(httpServiceAdapter.post<dynamic>(any)).thenAnswer(
          (_) async => const ResponseAdapter<Map<String, dynamic>>(
            statusCode: 200,
            data: {'accessToken': 'token-novo', 'refreshToken': 'refresh-novo'},
          ),
        );

        when(httpServiceAdapter.get<dynamic>(any)).thenAnswer(
          (_) async => const ResponseAdapter<Map<String, dynamic>>(
            statusCode: 200,
            data: {
              'id': 1,
              'username': 'usuario_teste',
              'email': 'usuario@teste.com',
              'firstName': 'Usuario',
              'lastName': 'Teste',
              'phone': '11999999999',
              'image': 'https://dummyjson.com/icon/usuario/128',
              'role': 'admin',
              'company': {'name': 'Task Radar', 'department': 'Produto'},
            },
          ),
        );

        when(storage.setItem(any, any)).thenAnswer((_) async {});

        final result = await sut.refreshSession('refresh-antigo');

        expect(result, isNotNull);
        expect(result!.fullName, 'Usuario Teste');
        expect(result.userType.name, 'admin');

        final capturedGetRequest =
            verify(httpServiceAdapter.get<dynamic>(captureAny)).captured.single
                as RequestAdapter;
        expect(capturedGetRequest.path, '/auth/me');
        expect(capturedGetRequest.headers, {
          'Authorization': 'Bearer token-novo',
        });

        verify(
          storage.setItem(StorageSecureEnum.auth_jwt, {
            'refresh_token': 'refresh-novo',
            'token': 'token-novo',
          }),
        ).called(1);
        verify(storage.setItem(StorageSecureEnum.auth_user, any)).called(1);
        verifyNever(storage.removeAll());
      },
    );

    test(
      'refreshSession deve limpar storage quando /auth/me retornar resposta invalida',
      () async {
        when(
          storage.getItemToFactory(
            StorageSecureEnum.auth_user,
            fromJson: anyNamed('fromJson'),
          ),
        ).thenAnswer((_) async => null);

        when(httpServiceAdapter.post<dynamic>(any)).thenAnswer(
          (_) async => const ResponseAdapter<Map<String, dynamic>>(
            statusCode: 200,
            data: {'accessToken': 'token-novo', 'refreshToken': 'refresh-novo'},
          ),
        );

        when(httpServiceAdapter.get<dynamic>(any)).thenAnswer(
          (_) async => const ResponseAdapter<Map<String, dynamic>>(
            statusCode: 500,
            data: {'message': 'erro'},
          ),
        );

        when(storage.setItem(any, any)).thenAnswer((_) async {});

        final result = await sut.refreshSession('refresh-antigo');

        expect(result, isNull);
        verify(storage.removeAll()).called(1);
      },
    );

    test(
      'refreshSession deve limpar storage quando ocorrer excecao no refresh',
      () async {
        when(httpServiceAdapter.post<dynamic>(any)).thenThrow(
          const HttpError(
            response: ResponseAdapter(statusCode: 401),
            statusMessage: 'Refresh inválido',
          ),
        );

        final result = await sut.refreshSession('refresh-antigo');

        expect(result, isNull);
        verify(storage.removeAll()).called(1);
      },
    );

    test('loginOffline deve retornar usuario salvo no sqlite', () async {
      when(database.query('logged_user', limit: 1)).thenAnswer(
        (_) async => [
          {
            'full_name': 'Usuario Offline',
            'email': 'offline@taskradar.local',
            'phone': '11911112222',
            'company': 'Task Radar',
            'department': 'Offline',
            'photo': 'https://dummyjson.com/icon/offline/128',
            'user_type': 'moderator',
          },
        ],
      );

      final result = await sut.loginOffline();

      expect(result.fullName, 'Usuario Offline');
      expect(result.email, 'offline@taskradar.local');
      expect(result.phone, '11911112222');
      expect(result.company, 'Task Radar');
      expect(result.department, 'Offline');
      expect(result.photo, 'https://dummyjson.com/icon/offline/128');
      expect(result.userType.name, 'moderator');
    });

    test('loginOffline deve lançar excecao quando sqlite nao tiver usuario', () async {
      when(database.query('logged_user', limit: 1)).thenAnswer((_) async => []);

      expect(
        () => sut.loginOffline(),
        throwsA(
          isA<Exception>().having(
            (error) => error.toString(),
            'mensagem',
            contains('Nenhum usuário salvo para login offline.'),
          ),
        ),
      );
    });
  });
}
