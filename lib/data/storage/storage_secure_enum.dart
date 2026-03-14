import 'package:task_radar/data/models/me_model.dart';
import 'package:task_radar/data/storage/refresh_token_model.dart';
import 'package:task_radar/data/storage/storage.dart';
import 'package:task_radar/data/storage/theme_mode_model.dart';

enum StorageSecureEnum<T extends Object> implements StorageEnum<T> {
  auth_jwt<RefreshTokenModel>(key: 'auth_jwt'),
  auth_user<MeModel>(key: 'auth_user'),
  app_theme<ThemeModeModel>(key: 'app_theme');

  @override
  final String key;

  const StorageSecureEnum({required this.key});
}
