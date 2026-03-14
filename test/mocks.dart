import 'package:dio/dio.dart' show Dio;
import 'package:mockito/annotations.dart' show GenerateNiceMocks, MockSpec;
import 'package:sqflite/sqflite.dart' show Database, Transaction;
import 'package:task_radar/data/network/http_service_adapter.dart';
import 'package:task_radar/data/repositories/auth_repository.dart';
import 'package:task_radar/data/storage/storage.dart';

@GenerateNiceMocks([MockSpec<Storage>()])
@GenerateNiceMocks([MockSpec<HttpServiceAdapter>()])
@GenerateNiceMocks([MockSpec<Dio>()])
@GenerateNiceMocks([MockSpec<AuthRepository>()])
@GenerateNiceMocks([MockSpec<Database>()])
@GenerateNiceMocks([MockSpec<Transaction>()])
void main() {}
