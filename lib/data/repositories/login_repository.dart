import 'package:task_radar/data/adapter/http_error_adapter.dart';
import 'package:task_radar/data/adapter/request_adapter.dart';
import 'package:task_radar/data/adapter/response_adapter.dart';
import 'package:task_radar/data/network/http_service_adapter.dart';
import 'package:task_radar/data/storage/refresh_token_model.dart';
import 'package:task_radar/data/storage/storage.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';

abstract interface class LoginRepository {
  Future<void> login(String name, String password);
}

final class LoginRepositoryImpl implements LoginRepository {
  final Storage _storage;
  final HttpServiceAdapter _httpServiceAdapter;

  LoginRepositoryImpl(this._httpServiceAdapter, this._storage);

  bool _isLoginSuccessful(ResponseAdapter response) {
    return response.statusCode == 200 &&
        response.data is Map &&
        (response.data as Map).containsKey('accessToken') &&
        (response.data as Map).containsKey('refreshToken');
  }

  @override
  Future<void> login(String name, String password) async {
    try {
      final response = await _httpServiceAdapter.post(
        RequestAdapter(
          path: "/auth/login",
          data: {"username": name, "password": password},
        ),
      );

      if (_isLoginSuccessful(response)) {
        await _storage.setItem(
          StorageSecureEnum.auth_jwt,
          RefreshTokenModel(
            refreshToken: response.data['refreshToken'],
            token: response.data['accessToken'],
          ).toJson(),
        );
      } else {
        throw Exception("falha ao realizar login: ${response.statusCode}");
      }
    } on HttpError catch (e) {
      throw Exception("Login failed: ${e.statusMessage}");
    }
  }
}
