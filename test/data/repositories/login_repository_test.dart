import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_radar/data/adapter/http_error_adapter.dart';
import 'package:task_radar/data/adapter/request_adapter.dart';
import 'package:task_radar/data/adapter/response_adapter.dart';
import 'package:task_radar/data/repositories/login_repository.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import '../../mocks.mocks.dart';

void main() {
	setUpAll(() {
		provideDummy<ResponseAdapter<dynamic>>(const ResponseAdapter<dynamic>());
	});

	late MockHttpServiceAdapter httpServiceAdapter;
	late MockStorage storage;
	late LoginRepositoryImpl sut;

	setUp(() {
		httpServiceAdapter = MockHttpServiceAdapter();
		storage = MockStorage();
		sut = LoginRepositoryImpl(httpServiceAdapter, storage);
	});

	group('LoginRepositoryImpl', () {
		test('deve realizar login e salvar os tokens no storage', () async {
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

			await sut.login('user@email.com', 'senha123');

			final capturedRequest = verify(
				httpServiceAdapter.post<dynamic>(captureAny),
			).captured.single as RequestAdapter;
			expect(capturedRequest.path, '/auth/login');
			expect(capturedRequest.data, {
				'email': 'user@email.com',
				'password': 'senha123',
			});

			verify(storage.setItem(StorageSecureEnum.auth_jwt, {
				'refresh_token': 'refresh-token-valido',
				'token': 'access-token-valido',
			})).called(1);
		});

		test('deve lançar excecao quando status code for diferente de 200', () async {
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
				() => sut.login('user@email.com', 'senha123'),
				throwsA(
					isA<Exception>().having(
						(error) => error.toString(),
						'mensagem',
						contains('falha ao realizar login: 401'),
					),
				),
			);

			verifyNever(storage.setItem(any, any));
		});

		test('deve lançar excecao quando resposta nao tiver accessToken e refreshToken', () async {
			when(httpServiceAdapter.post<dynamic>(any)).thenAnswer(
				(_) async => const ResponseAdapter<Map<String, dynamic>>(
				statusCode: 200,
				data: {
					'token': 'campo-incorreto',
				},
			),
			);

			expect(
				() => sut.login('user@email.com', 'senha123'),
				throwsA(
					isA<Exception>().having(
						(error) => error.toString(),
						'mensagem',
						contains('falha ao realizar login: 200'),
					),
				),
			);

			verifyNever(storage.setItem(any, any));
		});

		test('deve adaptar HttpError para excecao de login', () async {
			when(httpServiceAdapter.post<dynamic>(any)).thenThrow(
				const HttpError(
					response: ResponseAdapter(statusCode: 401),
					statusMessage: 'Credenciais invalidas',
				),
			);

			expect(
				() => sut.login('user@email.com', 'senha123'),
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
	});
}
