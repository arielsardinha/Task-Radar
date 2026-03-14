import 'package:dio/dio.dart' show Dio;
import 'package:mockito/annotations.dart' show GenerateNiceMocks, MockSpec;
import 'package:task_radar/data/network/http_service_adapter.dart';
import 'package:task_radar/data/repositories/auth_repository.dart';

import 'package:task_radar/data/storage/storage.dart';

@GenerateNiceMocks([MockSpec<Storage>()])
@GenerateNiceMocks([MockSpec<HttpServiceAdapter>()])
@GenerateNiceMocks([MockSpec<Dio>()])
@GenerateNiceMocks([MockSpec<AuthRepository>()])
void main() {}
