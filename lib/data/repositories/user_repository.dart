import 'package:task_radar/data/adapter/request_adapter.dart';
import 'package:task_radar/data/adapter/response_adapter.dart';
import 'package:task_radar/data/network/http_service_adapter.dart';
import 'package:sqflite/sqflite.dart' show Database;
import 'package:task_radar/domain/user.dart';
abstract interface class UserRepository {
  Future<List<User>> getUsers({int limit, int skip});
  Future<void> ensureScheme();
}

final class UserRepositoryImpl implements UserRepository {
  final HttpServiceAdapter _httpServiceAdapter;
 final Database _db;
  UserRepositoryImpl(this._httpServiceAdapter,{
     required Database database,
  }): _db = database;

  @override
  Future<List<User>> getUsers({int limit = 30, int skip = 0}) async {
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
        .map((json) => User.fromDummyJson(Map<String, dynamic>.from(json)))
        .toList(growable: false);
  }

  bool _isSuccess(ResponseAdapter response) {
    return response.statusCode == 200 && response.data is Map;
  }

  @override
  Future<void> ensureScheme() {
    return _db.execute('''
      CREATE TABLE IF NOT EXISTS logged_user (
        id          TEXT PRIMARY KEY,
        full_name   TEXT NOT NULL,
        email       TEXT NOT NULL,
        phone       TEXT NOT NULL,
        company     TEXT NOT NULL,
        department  TEXT NOT NULL,
        photo       TEXT NOT NULL,
        user_type   TEXT NOT NULL CHECK(user_type IN ('admin','moderator'))
      );
    ''');
  }
}
