@Tags(['integration'])
library;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_radar/data/network/http_service_adapter.dart';
import 'package:task_radar/data/repositories/auth_repository.dart';
import 'package:task_radar/data/storage/storage_impl.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';

void main() {
  const apiBaseUrl = String.fromEnvironment('BASE_URL_DUMMYJSON');
  const loginUsername = String.fromEnvironment('LOGIN_USERNAME');
  const loginPassword = String.fromEnvironment('LOGIN_PASSWORD');

  group('AuthRepository Integration', () {
    late StorageImpl storage;
    late AuthRepositoryImpl sut;

    setUpAll(() {
      FlutterSecureStorage.setMockInitialValues({});
      expect(
        apiBaseUrl.isNotEmpty,
        isTrue,
        reason:
            'Informe API_BASE_URL ou BASE_URL_DUMMYJSON via --dart-define-from-file.',
      );
      expect(
        loginUsername.isNotEmpty,
        isTrue,
        reason: 'Informe LOGIN_USERNAME via --dart-define.',
      );
      expect(
        loginPassword.isNotEmpty,
        isTrue,
        reason: 'Informe LOGIN_PASSWORD via --dart-define.',
      );
    });

    setUp(() async {
      storage = const StorageImpl();
      await storage.removeAll();
      sut = AuthRepositoryImpl(
        HttpServiceAdapterImp(
          client: Dio(
            BaseOptions(
              baseUrl: apiBaseUrl,
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20),
              sendTimeout: const Duration(seconds: 20),
            ),
          ),
        ),
        storage,
      );
    });

    test('deve autenticar na API e persistir os tokens', () async {
      await sut.login(loginUsername, loginPassword);
      final authData = await storage.getItem(StorageSecureEnum.auth_jwt);
      expect(authData, isNotNull);
      expect(authData!['token'], isA<String>());
      expect((authData['token'] as String).isNotEmpty, isTrue);
      expect(authData['refresh_token'], isA<String>());
      expect((authData['refresh_token'] as String).isNotEmpty, isTrue);
    });

    test(
      'deve realizar refresh da sessao com sucesso e persistir dados do token',
      () async {
        await sut.login(loginUsername, loginPassword);

        final beforeRefreshAuth = await storage.getItem(
          StorageSecureEnum.auth_jwt,
        );
        final refreshToken = beforeRefreshAuth?['refresh_token'] as String?;
        expect(refreshToken, isNotNull);
        expect(refreshToken!.isNotEmpty, isTrue);

        final user = await sut.refreshSession(refreshToken);

        final authData = await storage.getItem(StorageSecureEnum.auth_jwt);
        expect(user, isNotNull);
        expect(authData, isNotNull);
        expect(authData!['token'], isA<String>());
        expect((authData['token'] as String).isNotEmpty, isTrue);
        expect(authData['refresh_token'], isA<String>());
        expect((authData['refresh_token'] as String).isNotEmpty, isTrue);
      },
    );
  });
}
