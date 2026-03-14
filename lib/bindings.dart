import 'package:get_it/get_it.dart' show GetIt;
import 'package:dio/dio.dart' as dio;
import 'package:task_radar/data/interceptors/auth_interceptor.dart';
import 'package:task_radar/data/network/http_service_adapter.dart';
import 'package:task_radar/data/repositories/login_repository.dart';
import 'package:task_radar/data/storage/storage_impl.dart';

sealed class Bindings {
  static void register() {
    final instance = GetIt.instance;

    const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
    const fallbackBaseUrl = String.fromEnvironment('BASE_URL_DUMMYJSON');
    final resolvedBaseUrl = apiBaseUrl.isNotEmpty ? apiBaseUrl : fallbackBaseUrl;

    instance.registerLazySingleton(
      () => dio.Dio(
        dio.BaseOptions(
          baseUrl: resolvedBaseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20),
        ),
      ),
    );
    instance.registerLazySingleton(() => StorageImpl());

    instance.registerLazySingleton(
      () => HttpServiceAdapterImp(client: instance.get<dio.Dio>()),
    );

    instance.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(
        instance.get<HttpServiceAdapterImp>(),
        instance.get<StorageImpl>(),
      ),
    );

    instance.get<dio.Dio>().interceptors.add(
      AuthInterceptor(
        client: instance.get<HttpServiceAdapterImp>(),
        storage: instance.get<StorageImpl>(),
      ),
    );
  }
}
