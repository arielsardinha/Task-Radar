import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_radar/data/adapter/http_error_adapter.dart';
import 'package:task_radar/data/models/me_model.dart';
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
  late AuthRepositoryImpl sut;

  setUp(() {
    httpServiceAdapter = MockHttpServiceAdapter();
    storage = MockStorage();
    sut = AuthRepositoryImpl(httpServiceAdapter, storage);
  });

  group('AuthRepositoryImpl', () {
    test('deve realizar login e salvar os tokens no storage', () async {
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
      when(storage.setItem(any, any)).thenAnswer((_) async {});

      await sut.login('usuario_teste', 'senha123');

      final capturedRequest =
          verify(httpServiceAdapter.post<dynamic>(captureAny)).captured.single
              as RequestAdapter;
      expect(capturedRequest.path, '/auth/login');
      expect(capturedRequest.data, {
        'username': 'usuario_teste',
        'password': 'senha123',
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
                .having(
                  (m) => m['image'],
                  'image',
                  'https://dummyjson.com/icon/usuario/128',
                ),
          ),
        ),
      ]);
    });

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
      'refreshSession deve atualizar tokens e retornar usuario em cache quando auth_user existir',
      () async {
        when(httpServiceAdapter.post<dynamic>(any)).thenAnswer(
          (_) async => const ResponseAdapter<Map<String, dynamic>>(
            statusCode: 200,
            data: {'accessToken': 'token-novo', 'refreshToken': 'refresh-novo'},
          ),
        );

        when(
          storage.getItemToFactory(
            StorageSecureEnum.auth_user,
            fromJson: anyNamed('fromJson'),
          ),
        ).thenAnswer(
          (_) async => const MeModel(
            firstName: 'Usuario',
            lastName: 'Teste',
            email: 'usuario@teste.com',
            phone: '11999999999',
            image: 'https://dummyjson.com/icon/usuario/128',
            company: MeCompanyModel(name: 'Task Radar', department: 'Produto'),
          ),
        );

        when(storage.setItem(any, any)).thenAnswer((_) async {});

        final result = await sut.refreshSession('refresh-antigo');

        expect(result, isNotNull);
        expect(result!.fullName, 'Usuario Teste');

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
        verifyNever(httpServiceAdapter.get<dynamic>(any));
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
              'image': 'https://dummyjson.com/icon/usuario/128',
            },
          ),
        );

        when(storage.setItem(any, any)).thenAnswer((_) async {});

        final result = await sut.refreshSession('refresh-antigo');

        expect(result, isNotNull);
        expect(result!.fullName, 'Usuario Teste');

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
  });
}
