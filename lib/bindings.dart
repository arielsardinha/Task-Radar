import 'package:get_it/get_it.dart' show GetIt;
import 'package:dio/dio.dart' as dio;
import 'package:task_radar/data/interceptors/auth_interceptor.dart';
import 'package:task_radar/data/network/http_service_adapter.dart';
import 'package:task_radar/data/repositories/auth_repository.dart';
import 'package:task_radar/data/repositories/task_repository_impl.dart';
import 'package:task_radar/data/storage/storage_impl.dart';
import 'package:dio/io.dart' show IOHttpClientAdapter;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:sqflite/sqflite.dart' show Database, openDatabase;

sealed class Bindings {
  static Future<void> register() async {
    final instance = GetIt.instance;

    const apiBaseUrl = String.fromEnvironment('BASE_URL_DUMMYJSON');

    instance.registerLazySingleton(
      () => dio.Dio(
        dio.BaseOptions(
          baseUrl: apiBaseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20),
        ),
      ),
    );

    instance.get<dio.Dio>().httpClientAdapter = IOHttpClientAdapter(
      // ignore: deprecated_member_use
      onHttpClientCreate: (client) {
        // VNP que estou conectado está barrando minhas requisições por causa do certificado SSL,
        // então estou forçando a lib a aceitar qualquer certificado.
        client.badCertificateCallback = (_, _, _) => kDebugMode;
        return client;
      },
    );
    instance.registerLazySingleton<StorageImpl>(() => const StorageImpl());

    instance.registerLazySingleton(
      () => HttpServiceAdapterImp(client: instance.get<dio.Dio>()),
    );

    instance.registerLazySingleton<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(
        instance.get<HttpServiceAdapterImp>(),
        instance.get<StorageImpl>(),
      ),
    );

    instance.registerSingletonAsync<Database>(
      () async => await openDatabase('task_radar.db', version: 1),
    );

    instance.registerSingletonAsync<TaskRepositoryImpl>(() async {
      final database = await instance.getAsync<Database>();
      final repository = TaskRepositoryImpl(database: database);
      await repository.ensureSchema();
      return repository;
    }, dependsOn: [Database]);

    instance.get<dio.Dio>().interceptors.add(
      AuthInterceptor(
        client: instance.get<HttpServiceAdapterImp>(),
        storage: instance.get<StorageImpl>(),
      ),
    );

    await instance.allReady();
  }
}
