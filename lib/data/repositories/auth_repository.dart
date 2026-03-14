import 'package:task_radar/data/adapter/http_error_adapter.dart';
import 'package:task_radar/data/adapter/request_adapter.dart';
import 'package:task_radar/data/adapter/response_adapter.dart';
import 'package:task_radar/data/models/me_model.dart';
import 'package:task_radar/data/network/http_service_adapter.dart';
import 'package:task_radar/data/storage/refresh_token_model.dart';
import 'package:task_radar/data/storage/storage.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import 'package:task_radar/domain/user.dart';

abstract interface class AuthRepository {
  Future<User> login(String username, String password);
  Future<User?> refreshSession(String refreshToken);
}

final class AuthRepositoryImpl implements AuthRepository {
  final Storage _storage;
  final HttpServiceAdapter _httpServiceAdapter;

  AuthRepositoryImpl(this._httpServiceAdapter, this._storage);

  bool _containsTokenPair(Map<dynamic, dynamic> payload) {
    return payload.containsKey('accessToken') &&
        payload.containsKey('refreshToken');
  }

  bool _isLoginSuccessful(ResponseAdapter response) {
    return response.statusCode == 200 &&
        response.data is Map &&
        _containsTokenPair(response.data as Map);
  }

  bool _isRefreshSuccessful(ResponseAdapter response) {
    return response.statusCode == 200 &&
        response.data is Map &&
        _containsTokenPair(response.data as Map);
  }

  Future<User> _fetchAndPersistUserFromMe({required String accessToken}) async {
    try {
      final meResponse = await _httpServiceAdapter.get(
        RequestAdapter(
          path: '/auth/me',
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (meResponse.statusCode != 200 || meResponse.data is! Map) {
        throw Exception('Falha ao obter perfil do usuário');
      }

      final meModel = MeModel.fromJson(meResponse.data);
      await _storage.setItem(StorageSecureEnum.auth_user, meModel.toJson());
      return meModel.toUser();
    } catch (_) {
      throw Exception('Falha ao obter perfil do usuário');
    }
  }

  @override
  Future<User> login(String username, String password) async {
    try {
      final response = await _httpServiceAdapter.post(
        RequestAdapter(
          path: '/auth/login',
          data: {'username': username, 'password': password},
        ),
      );

      if (!_isLoginSuccessful(response)) {
        throw Exception('falha ao realizar login: ${response.statusCode}');
      }

      final payload = response.data as Map;
      final authData = RefreshTokenModel(
        refreshToken: payload['refreshToken'],
        token: payload['accessToken'],
      );
      await _storage.setItem(StorageSecureEnum.auth_jwt, authData.toJson());

      return _fetchAndPersistUserFromMe(accessToken: authData.token);
    } on HttpError catch (e) {
      throw Exception('Login failed: ${e.statusMessage}');
    }
  }

  @override
  Future<User?> refreshSession(String refreshToken) async {
    try {
      if (refreshToken.trim().isEmpty) {
        await _storage.removeAll();
        return null;
      }

      final refreshResponse = await _httpServiceAdapter.post(
        RequestAdapter(
          path: '/auth/refresh',
          data: {'refreshToken': refreshToken, 'expiresInMins': 30},
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (!_isRefreshSuccessful(refreshResponse)) {
        await _storage.removeAll();
        return null;
      }

      final refreshPayload = refreshResponse.data as Map;
      final accessToken = refreshPayload['accessToken'] as String;
      final refreshedToken = refreshPayload['refreshToken'] as String;

      await _storage.setItem(
        StorageSecureEnum.auth_jwt,
        RefreshTokenModel(
          refreshToken: refreshedToken,
          token: accessToken,
        ).toJson(),
      );

      return await _fetchAndPersistUserFromMe(accessToken: accessToken);
    } catch (_) {
      await _storage.removeAll();
      return null;
    }
  }
}
