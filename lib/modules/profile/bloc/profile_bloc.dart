import 'package:bloc/bloc.dart';
import 'package:task_radar/data/storage/storage_impl.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import 'package:task_radar/domain/user.dart';
import 'package:task_radar/modules/profile/bloc/profile_event.dart';
import 'package:task_radar/modules/profile/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final StorageImpl _storage;

  ProfileBloc({required StorageImpl storage})
    : _storage = storage,
      super(const ProfileStateInitial()) {
    on<ProfileEventLoad>(_onLoad);
    on<ProfileEventRetry>(_onRetry);
    on<ProfileEventLogout>(_onLogout);
  }

  Future<void> _onLoad(
    ProfileEventLoad event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileStateLoading());

    try {
      final me = await _storage.getItemToFactory(
        StorageSecureEnum.auth_user,
        fromJson: User.fromStorageJson,
      );

      if (me == null) {
        throw Exception('no-user');
      }

      emit(ProfileStateSuccess(profile: ProfileViewData.fromUser(me)));
    } catch (_) {
      emit(
        const ProfileStateFailure(
          message:
              'Nao foi possivel carregar as informacoes, por favor tente novamente.',
        ),
      );
    }
  }

  Future<void> _onRetry(
    ProfileEventRetry event,
    Emitter<ProfileState> emit,
  ) async {
    await _onLoad(ProfileEventLoad(), emit);
  }

  Future<void> _onLogout(
    ProfileEventLogout event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _storage.removeAll();
      emit(const ProfileStateLoggedOut());
    } catch (_) {
      emit(
        const ProfileStateFailure(
          message: 'Nao foi possivel sair da conta, por favor tente novamente.',
        ),
      );
    }
  }
}
