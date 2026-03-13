import 'package:get_it/get_it.dart' show GetIt;
import 'package:dio/dio.dart' as dio;
import 'package:task_radar/data/interceptors/auth_interceptor.dart';
import 'package:task_radar/data/network/http_service_adapter.dart';
import 'package:task_radar/data/storage/storage.dart';
import 'package:task_radar/data/storage/storage_impl.dart';

sealed class Bindings {
  static void register() {
    final instance = GetIt.instance;
    instance.registerLazySingleton(() => dio.Dio());
    instance.registerLazySingleton(() => StorageImpl());

    instance.registerLazySingleton(
      () => HttpServiceAdapterImp(client: instance.get<dio.Dio>()),
    );
    instance.get<dio.Dio>().interceptors.add(
      AuthInterceptor(
        client: instance.get<dio.Dio>(),
        storage: instance.get<Storage>(),
      ),
    );
  }
}
