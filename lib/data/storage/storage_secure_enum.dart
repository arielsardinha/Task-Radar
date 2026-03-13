import 'package:task_radar/data/storage/refresh_token_model.dart';
import 'package:task_radar/data/storage/storage.dart';

enum StorageSecureEnum<T extends Object> implements StorageEnum<T> {
  auth_jwt<RefreshTokenModel>(key: 'auth_jwt');

  @override
  final String key;

  const StorageSecureEnum({required this.key});
}
