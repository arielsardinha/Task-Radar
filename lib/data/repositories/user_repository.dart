import 'package:task_radar/data/adapter/request_adapter.dart';
import 'package:task_radar/data/adapter/response_adapter.dart';
import 'package:task_radar/data/models/me_model.dart';
import 'package:task_radar/data/network/http_service_adapter.dart';

abstract interface class UserRepository {
  Future<List<MeModel>> getUsers({int limit, int skip});
}

final class UserRepositoryImpl implements UserRepository {
  final HttpServiceAdapter _httpServiceAdapter;

  UserRepositoryImpl(this._httpServiceAdapter);

  @override
  Future<List<MeModel>> getUsers({int limit = 30, int skip = 0}) async {
    final response = await _httpServiceAdapter.get(
      RequestAdapter(
        path: '/users',
        queryParams: {
          'limit': limit,
          'skip': skip,
          'select': 'firstName,lastName,email,image,role',
        },
      ),
    );

    if (!_isSuccess(response)) {
      throw Exception('Falha ao consultar usuários.');
    }

    final payload = response.data as Map;
    final usersRaw = payload['users'];
    if (usersRaw is! List) {
      throw Exception('Resposta inválida ao consultar usuários.');
    }

    return usersRaw
        .whereType<Map>()
        .map((json) => MeModel.fromJson(Map<String, dynamic>.from(json)))
        .toList(growable: false);
  }

  bool _isSuccess(ResponseAdapter response) {
    return response.statusCode == 200 && response.data is Map;
  }
}
