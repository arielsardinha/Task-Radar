import 'dart:async' show TimeoutException;
import 'dart:io' show SocketException;
import "package:dio/dio.dart" as dio;
import 'package:retry/retry.dart' show RetryOptions;
import 'package:task_radar/data/storage/refresh_token_model.dart';
import 'package:task_radar/data/storage/storage.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';

class AuthInterceptor extends dio.Interceptor {
  final dio.Dio _client;
  final Storage _storage;

  AuthInterceptor({required dio.Dio client, required Storage storage})
    : _client = client,
      _storage = storage;

  Future<String?> _getJwtToken() async {
    final authJwt = await _storage.getItemToFactory(
      StorageSecureEnum.auth_jwt,
      fromJson: RefreshTokenModel.fromJson,
    );

    return authJwt?.token;
  }

  Future<RefreshTokenModel?> _getAuth() async {
    return await _storage.getItemToFactory(
      StorageSecureEnum.auth_jwt,
      fromJson: RefreshTokenModel.fromJson,
    );
  }

  Future<void> _updateJwt(RefreshTokenModel auth, String newToken, String newRefreshToken) async {
    final newAuth = auth.copyWith(token: newToken, refreshToken: newRefreshToken);
    await _storage.setItem(StorageSecureEnum.auth_jwt, newAuth.toJson());
  }

  Future<dio.Response?> _refreshToken(RefreshTokenModel auth) async {
    const retryOptions = RetryOptions(maxAttempts: 3);

    final data = {"refreshToken": auth.refreshToken, "expiresInMins": 30};

    return await retryOptions.retry(
      () => _client.post('/auth/refresh', data: data),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }

  bool _isTokenExpired(dio.DioException err) {
    final response = err.response;
    final data = response?.data;
    final statuCode = response?.statusCode;
    return statuCode == 401 &&
        data is Map &&
        data.containsKey("message") &&
        ["Expired Token"].contains(data['message']);
  }

  @override
  void onRequest(
    dio.RequestOptions options,
    dio.RequestInterceptorHandler handler,
  ) async {
    final token = await _getJwtToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    dio.DioException err,
    dio.ErrorInterceptorHandler handler,
  ) async {
    if (_isTokenExpired(err)) {
      final auth = await _getAuth();
      if (auth != null) {
        try {
          final response = await _refreshToken(auth);
          final newToken = response?.data['accessToken'];
          final newRefreshToken = response?.data['refreshToken'];
          if (newToken != null && newRefreshToken != null) {
            await _updateJwt(auth, newToken, newRefreshToken);

            final requestOptions = err.requestOptions;
            requestOptions.headers['Authorization'] = 'Bearer $newToken';

            final originalResponse = await _client.fetch(requestOptions);
            return handler.resolve(originalResponse);
          }
        } catch (_) {
          return handler.reject(err);
        }
      }
    }
    handler.next(err);
  }
}
