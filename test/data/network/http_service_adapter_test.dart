import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_radar/data/adapter/http_error_adapter.dart';
import 'package:task_radar/data/adapter/request_adapter.dart';
import 'package:task_radar/data/network/http_service_adapter.dart';

import '../../mocks.mocks.dart';

void main() {
	late MockDio dioClient;
	late HttpServiceAdapterImp sut;

	setUp(() {
		dioClient = MockDio();
		sut = HttpServiceAdapterImp(client: dioClient);
	});

	group('HttpServiceAdapterImp', () {
		test('get deve retornar ResponseAdapter quando a chamada for bem sucedida', () async {
			final request = const RequestAdapter(
				path: '/users',
				queryParams: {'page': 1},
				data: {'enabled': true},
				headers: {'Authorization': 'Bearer token'},
			);
			final dioResponse = dio.Response<dynamic>(
				requestOptions: dio.RequestOptions(path: '/users'),
				data: {'items': [1, 2, 3]},
				statusCode: 200,
				statusMessage: 'OK',
			);

			when(
				dioClient.get<dynamic>(
					any,
					queryParameters: anyNamed('queryParameters'),
					data: anyNamed('data'),
					options: anyNamed('options'),
				),
			).thenAnswer((_) async => dioResponse);

			final result = await sut.get<Map<String, dynamic>>(request);

			expect(result.statusCode, 200);
			expect(result.statusMessage, 'OK');
			expect(result.data, {'items': [1, 2, 3]});
			verify(
				dioClient.get<dynamic>(
					'/users',
					queryParameters: {'page': 1},
					data: {'enabled': true},
					options: anyNamed('options'),
				),
			).called(1);
		});

		test('get deve lançar HttpError quando DioException acontecer', () async {
			final request = const RequestAdapter(
				path: '/users',
				queryParams: {'page': 1},
				headers: {'Authorization': 'Bearer token'},
			);
			final requestOptions = dio.RequestOptions(
				path: '/users',
				queryParameters: {'page': 1},
				headers: {'Authorization': 'Bearer token'},
			);
			final dioException = dio.DioException(
				requestOptions: requestOptions,
				response: dio.Response<dynamic>(
					requestOptions: requestOptions,
					statusCode: 500,
					statusMessage: 'Server error',
					data: {'message': 'internal'},
				),
				type: dio.DioExceptionType.badResponse,
			);

			when(
				dioClient.get<dynamic>(
					any,
					queryParameters: anyNamed('queryParameters'),
					data: anyNamed('data'),
					options: anyNamed('options'),
				),
			).thenThrow(dioException);

			expect(
				() => sut.get<Map<String, dynamic>>(request),
				throwsA(
					isA<HttpError>()
							.having((e) => e.response.statusCode, 'statusCode', 500)
							.having((e) => e.response.statusMessage, 'statusMessage', 'Server error')
							.having((e) => e.request?.path, 'request.path', '/users'),
				),
			);
		});

		test('post deve retornar ResponseAdapter quando a chamada for bem sucedida', () async {
			final request = const RequestAdapter(
				path: '/auth/login',
				data: {'username': 'emilys', 'password': 'emilyspass'},
			);
			final dioResponse = dio.Response<dynamic>(
				requestOptions: dio.RequestOptions(path: '/auth/login'),
				data: {'accessToken': 'abc', 'refreshToken': 'def'},
				statusCode: 200,
				statusMessage: 'OK',
			);

			when(
				dioClient.post<dynamic>(
					any,
					data: anyNamed('data'),
					queryParameters: anyNamed('queryParameters'),
					options: anyNamed('options'),
				),
			).thenAnswer((_) async => dioResponse);

			final result = await sut.post<Map<String, dynamic>>(request);

			expect(result.statusCode, 200);
			expect(result.data?['accessToken'], 'abc');
			expect(result.data?['refreshToken'], 'def');
			verify(
				dioClient.post<dynamic>(
					'/auth/login',
					data: {'username': 'emilys', 'password': 'emilyspass'},
					queryParameters: null,
					options: anyNamed('options'),
				),
			).called(1);
		});

		test('post deve lançar HttpError e manter data quando nao for multipart', () async {
			final request = const RequestAdapter(
				path: '/auth/login',
				data: {'username': 'emilys', 'password': 'emilyspass'},
			);
			final requestOptions = dio.RequestOptions(
				path: '/auth/login',
				data: {'username': 'emilys', 'password': 'emilyspass'},
			);
			final dioException = dio.DioException(
				requestOptions: requestOptions,
				response: dio.Response<dynamic>(
					requestOptions: requestOptions,
					statusCode: 401,
					statusMessage: 'Unauthorized',
					data: {'message': 'invalid credentials'},
				),
				type: dio.DioExceptionType.badResponse,
			);

			when(
				dioClient.post<dynamic>(
					any,
					data: anyNamed('data'),
					queryParameters: anyNamed('queryParameters'),
					options: anyNamed('options'),
				),
			).thenThrow(dioException);

			expect(
				() => sut.post<Map<String, dynamic>>(request),
				throwsA(
					isA<HttpError>()
							.having((e) => e.response.statusCode, 'statusCode', 401)
							.having((e) => e.request?.data, 'request.data', {
								'username': 'emilys',
								'password': 'emilyspass',
							}),
				),
			);
		});

		test('post deve lançar HttpError e manter request.data quando for multipart', () async {
			final request = const RequestAdapter(path: '/upload', data: {'file': 'bin'});
			final requestOptions = dio.RequestOptions(
				path: '/upload',
				data: {'file': 'bin'},
				contentType: 'multipart/form-data',
			);
			final dioException = dio.DioException(
				requestOptions: requestOptions,
				response: dio.Response<dynamic>(
					requestOptions: requestOptions,
					statusCode: 400,
					statusMessage: 'Bad Request',
				),
				type: dio.DioExceptionType.badResponse,
			);

			when(
				dioClient.post<dynamic>(
					any,
					data: anyNamed('data'),
					queryParameters: anyNamed('queryParameters'),
					options: anyNamed('options'),
				),
			).thenThrow(dioException);

			expect(
				() => sut.post<Map<String, dynamic>>(request),
				throwsA(
					isA<HttpError>()
							.having((e) => e.response.statusCode, 'statusCode', 400)
							.having((e) => e.request?.data, 'request.data', {'file': 'bin'}),
				),
			);
		});

		test('fetch deve delegar para Dio.fetch e retornar a resposta', () async {
			final requestOptions = dio.RequestOptions(path: '/raw');
			final dioResponse = dio.Response<dynamic>(
				requestOptions: requestOptions,
				data: {'raw': true},
				statusCode: 200,
			);

			when(dioClient.fetch<dynamic>(any)).thenAnswer((_) async => dioResponse);

			final response = await sut.fetch(requestOptions);

			expect(response.statusCode, 200);
			expect(response.data, {'raw': true});
			verify(dioClient.fetch<dynamic>(requestOptions)).called(1);
		});
	});
}
