import 'package:task_radar/domain/user.dart';

enum UsersStateStatus { initial, loading, success, failure }

enum UsersFilter { all, admin, moderator }

final class UsersState {
  final UsersStateStatus status;
  final List<User> allUsers;
  final List<User> visibleUsers;
  final UsersFilter filter;
  final String query;
  final String? message;

  const UsersState({
    required this.status,
    required this.allUsers,
    required this.visibleUsers,
    required this.filter,
    required this.query,
    required this.message,
  });

  const UsersState.initial()
    : status = UsersStateStatus.initial,
      allUsers = const [],
      visibleUsers = const [],
      filter = UsersFilter.all,
      query = '',
      message = null;

  UsersState copyWith({
    UsersStateStatus? status,
    List<User>? allUsers,
    List<User>? visibleUsers,
    UsersFilter? filter,
    String? query,
    String? message,
    bool clearMessage = false,
  }) {
    return UsersState(
      status: status ?? this.status,
      allUsers: allUsers ?? this.allUsers,
      visibleUsers: visibleUsers ?? this.visibleUsers,
      filter: filter ?? this.filter,
      query: query ?? this.query,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}
