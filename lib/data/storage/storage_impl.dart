import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_radar/data/storage/storage.dart';

class StorageImpl<T extends StorageEnum> implements Storage<T> {
  static const _initialKey = 'SalaryFits_';

  final FlutterSecureStorage secureStorage;

  const StorageImpl({FlutterSecureStorage? secureStorage})
    : secureStorage =
          secureStorage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(
              migrateOnAlgorithmChange: true,
              resetOnError: true,
            ),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  Future<Map<String, dynamic>?> _getInfoInSecureStorage(T key) async {
    final item = await secureStorage.read(key: "$_initialKey${key.key}");
    if (item != null) return jsonDecode(item);

    return null;
  }

  @override
  Future<Map<String, dynamic>?> getItem(T key) async {
    return await _getInfoInSecureStorage(key);
  }

  @override
  Future<void> removeAll() async {
    await secureStorage.deleteAll();
  }

  @override
  Future<void> removeItem(T key) async {
    await secureStorage.delete(key: "$_initialKey${key.key}");
  }

  @override
  Future<void> setItem(T key, Map<String, dynamic> data) async {
    final jsonData = jsonEncode(data);
    await secureStorage.write(key: "$_initialKey${key.key}", value: jsonData);
  }

  @override
  Future<B?> getItemToFactory<B extends Object, C extends StorageEnum<B>>(
    C key, {
    required B Function(Map<String, dynamic> json) fromJson,
  }) async {
    final data = await getItem(key as T);
    if (data == null) {
      return null;
    }

    return fromJson(data);
  }
}
