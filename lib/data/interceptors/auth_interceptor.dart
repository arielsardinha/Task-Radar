import "package:dio/dio.dart" as dio;
import 'package:task_radar/data/network/http_service_adapter.dart';
import 'package:task_radar/data/storage/refresh_token_model.dart';
import 'package:task_radar/data/storage/storage.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import 'package:task_radar/global/mediator.dart';

class AuthInterceptor extends dio.Interceptor {
  final Mediator _mediator;
  final HttpServiceAdapter _client;
  final Storage _storage;

  AuthInterceptor({
    required HttpServiceAdapter client,
    required Mediator mediator,
    required Storage storage,
  }) : _client = client,
       _mediator = mediator,
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

  Future<void> _updateJwt(
    RefreshTokenModel auth,
    String newToken,
    String newRefreshToken,
  ) async {
    final newAuth = auth.copyWith(
      token: newToken,
      refreshToken: newRefreshToken,
    );
    await _storage.setItem(StorageSecureEnum.auth_jwt, newAuth.toJson());
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
          await _mediator.notify('refrash_token', auth.refreshToken);
          final tokenUpdated = await _storage.getItemToFactory(
            StorageSecureEnum.auth_jwt,
            fromJson: RefreshTokenModel.fromJson,
          );

          final newToken = tokenUpdated?.token;
          final newRefreshToken = tokenUpdated?.refreshToken;
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
