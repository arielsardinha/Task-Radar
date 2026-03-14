import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_radar/data/storage/refresh_token_model.dart';
import 'package:task_radar/data/storage/storage_impl.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';

void main() {
	TestWidgetsFlutterBinding.ensureInitialized();

	late StorageImpl<StorageSecureEnum> sut;

	setUp(() async {
		FlutterSecureStorage.setMockInitialValues({});
		sut = const StorageImpl<StorageSecureEnum>();
	});

	group('StorageImpl', () {
		test('setItem e getItem devem persistir e retornar os dados', () async {
			final data = <String, dynamic>{
				'refresh_token': 'refresh-token-value',
				'token': 'token-value',
			};

			await sut.setItem(StorageSecureEnum.auth_jwt, data);
			final result = await sut.getItem(StorageSecureEnum.auth_jwt);

			expect(result, data);
		});

		test('getItem deve retornar null quando a chave nao existir', () async {
			final result = await sut.getItem(StorageSecureEnum.auth_jwt);

			expect(result, isNull);
		});

		test('removeItem deve remover o valor armazenado', () async {
			await sut.setItem(StorageSecureEnum.auth_jwt, {
				'refresh_token': 'to-remove-refresh',
				'token': 'to-remove-token',
			});

			await sut.removeItem(StorageSecureEnum.auth_jwt);
			final result = await sut.getItem(StorageSecureEnum.auth_jwt);

			expect(result, isNull);
		});

		test('removeAll deve limpar todos os valores armazenados', () async {
			await sut.setItem(StorageSecureEnum.auth_jwt, {
				'refresh_token': 'refresh-before-clear',
				'token': 'token-before-clear',
			});

			await sut.removeAll();
			final result = await sut.getItem(StorageSecureEnum.auth_jwt);

			expect(result, isNull);
		});

		test('getItemToFactory deve mapear os dados usando fromJson', () async {
			await sut.setItem(StorageSecureEnum.auth_jwt, {
				'refresh_token': 'refresh-factory',
				'token': 'token-factory',
			});

			final model = await sut.getItemToFactory(
				StorageSecureEnum.auth_jwt,
				fromJson: RefreshTokenModel.fromJson,
			);

			expect(model, isNotNull);
			expect(model!.refreshToken, 'refresh-factory');
			expect(model.token, 'token-factory');
		});

		test('getItemToFactory deve retornar null quando o item nao existir', () async {
			var fromJsonCalled = false;

			final model = await sut.getItemToFactory(
				StorageSecureEnum.auth_jwt,
				fromJson: (json) {
					fromJsonCalled = true;
					return RefreshTokenModel.fromJson(json);
				},
			);

			expect(model, isNull);
			expect(fromJsonCalled, isFalse);
		});
	});
}
