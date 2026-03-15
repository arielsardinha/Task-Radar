import 'package:bloc/bloc.dart';
import 'package:task_radar/data/repositories/user_repository.dart';
import 'package:task_radar/domain/user.dart';
import 'package:task_radar/modules/users/bloc/users_event.dart';
import 'package:task_radar/modules/users/bloc/users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UserRepository _userRepository;

  UsersBloc({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(const UsersState.initial()) {
    on<UsersEventLoad>(_onLoad);
    on<UsersEventSearchChanged>(_onSearchChanged);
    on<UsersEventFilterChanged>(_onFilterChanged);
  }

  Future<void> _onLoad(UsersEventLoad event, Emitter<UsersState> emit) async {
    emit(state.copyWith(status: UsersStateStatus.loading, clearMessage: true));

    try {
      final users = await _userRepository.getUsers(limit: 30, skip: 0);

      final visible = _applyView(
        users: users,
        query: state.query,
        filter: state.filter,
      );

      emit(
        state.copyWith(
          status: UsersStateStatus.success,
          allUsers: users,
          visibleUsers: visible,
          clearMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: UsersStateStatus.failure,
          message: 'Nao foi possivel carregar os usuarios.',
        ),
      );
    }
  }

  void _onSearchChanged(
    UsersEventSearchChanged event,
    Emitter<UsersState> emit,
  ) {
    final visible = _applyView(
      users: state.allUsers,
      query: event.query,
      filter: state.filter,
    );

    emit(
      state.copyWith(
        status: UsersStateStatus.success,
        query: event.query,
        visibleUsers: visible,
        clearMessage: true,
      ),
    );
  }

  void _onFilterChanged(
    UsersEventFilterChanged event,
    Emitter<UsersState> emit,
  ) {
    final visible = _applyView(
      users: state.allUsers,
      query: state.query,
      filter: event.filter,
    );

    emit(
      state.copyWith(
        status: UsersStateStatus.success,
        filter: event.filter,
        visibleUsers: visible,
        clearMessage: true,
      ),
    );
  }

  List<User> _applyView({
    required List<User> users,
    required String query,
    required UsersFilter filter,
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    return users
        .where((user) {
          final byRole = switch (filter) {
            UsersFilter.all => true,
            UsersFilter.admin => user.userType == UserType.admin,
            UsersFilter.moderator => user.userType == UserType.moderator,
          };

          if (!byRole) {
            return false;
          }

          if (normalizedQuery.isEmpty) {
            return true;
          }

          return user.fullName.toLowerCase().contains(normalizedQuery);
        })
        .toList(growable: false);
  }
}
