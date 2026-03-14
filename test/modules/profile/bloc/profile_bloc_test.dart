import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_radar/data/models/me_model.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import 'package:task_radar/modules/profile/bloc/profile_bloc.dart';
import 'package:task_radar/modules/profile/bloc/profile_event.dart';
import 'package:task_radar/modules/profile/bloc/profile_state.dart';

import '../../../mocks.mocks.dart';

void main() {
  late MockStorageImpl storage;
  late ProfileBloc profileBloc;

  const meModel = MeModel(
    id: 7,
    firstName: 'Emily',
    lastName: 'Santos',
    email: 'emilysantos@gmail.com',
    phone: '(49) 9923155780',
    image: 'https://cdn.example.com/photo.png',
    role: 'moderator',
    company: MeCompanyModel(
      name: 'Senai Solucoes Digitais',
      department: 'Squad Apps',
    ),
  );

  setUp(() {
    storage = MockStorageImpl();
    profileBloc = ProfileBloc(storage: storage);
  });

  tearDown(() async {
    await profileBloc.close();
  });

  test(
    'deve emitir loading e success quando carregar o usuario do storage',
    () async {
      when(
        storage.getItemToFactory(
          StorageSecureEnum.auth_user,
          fromJson: anyNamed('fromJson'),
        ),
      ).thenAnswer((_) async => meModel);

      profileBloc.add(ProfileEventLoad());

      await expectLater(
        profileBloc.stream,
        emitsInOrder([
          isA<ProfileStateLoading>(),
          isA<ProfileStateSuccess>()
              .having((s) => s.profile.firstName, 'firstName', 'Emily')
              .having((s) => s.profile.fullName, 'fullName', 'Emily Santos')
              .having((s) => s.profile.email, 'email', 'emilysantos@gmail.com')
              .having((s) => s.profile.type, 'type', 'Moderador'),
        ]),
      );
    },
  );

  test(
    'deve emitir loading e failure quando nao houver usuario no storage',
    () async {
      when(
        storage.getItemToFactory(
          StorageSecureEnum.auth_user,
          fromJson: anyNamed('fromJson'),
        ),
      ).thenAnswer((_) async => null);

      profileBloc.add(ProfileEventLoad());

      await expectLater(
        profileBloc.stream,
        emitsInOrder([
          isA<ProfileStateLoading>(),
          isA<ProfileStateFailure>().having(
            (s) => s.message,
            'message',
            'Nao foi possivel carregar as informacoes, por favor tente novamente.',
          ),
        ]),
      );
    },
  );

  test('deve limpar storage e emitir logged out no logout', () async {
    when(storage.removeAll()).thenAnswer((_) async {});

    profileBloc.add(ProfileEventLogout());

    await expectLater(profileBloc.stream, emits(isA<ProfileStateLoggedOut>()));

    verify(storage.removeAll()).called(1);
  });
}
