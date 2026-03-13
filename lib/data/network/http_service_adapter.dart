import "package:dio/dio.dart" as dio;
import 'package:retry/retry.dart' show RetryOptions;
import 'package:task_radar/data/adapter/http_error_adapter.dart';
import 'package:task_radar/data/adapter/request_adapter.dart';
import 'package:task_radar/data/adapter/response_adapter.dart';

abstract interface class HttpServiceAdapter {
  Future<ResponseAdapter<T>> get<T>(RequestAdapter request);
}

final class HttpServiceAdapterImp implements HttpServiceAdapter {
  final dio.Dio _client;

  HttpServiceAdapterImp({required dio.Dio client, })
    : _client = client;

  @override
  Future<ResponseAdapter<T>> get<T>(RequestAdapter request) async {
    const retryOptions = RetryOptions(maxAttempts: 3);
    try {
      final response = await retryOptions.retry(
        () async => await _client.get(
          request.path,
          queryParameters: request.queryParams,
          data: request.data,
          options: dio.Options(headers: request.headers),
        ),
        retryIf: (e) {
          if (e is dio.DioException) {
            return switch (e.type) {
              dio.DioExceptionType.connectionTimeout => true,
              dio.DioExceptionType.connectionError => true,
              dio.DioExceptionType.unknown => true,
              _ => false,
            };
          }
          return false;
        },
      );
      return ResponseAdapter(
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    } on dio.DioException catch (dioError, s) {
      throw HttpError(
        request: RequestAdapter(
          path: dioError.requestOptions.path,
          data: dioError.requestOptions.data,
          headers: dioError.requestOptions.headers,
          queryParams: dioError.requestOptions.queryParameters,
        ),
        response: ResponseAdapter(
          type: dioError.type.name,
          data: dioError.response?.data ?? dioError.message,
          statusCode: dioError.response?.statusCode,
          statusMessage: dioError.response?.statusMessage,
        ),
        exception: dioError,
        stackTrace: s,
      );
    }
  }
}
