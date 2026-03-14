import 'package:task_radar/data/models/me_model.dart';
import 'package:task_radar/domain/user.dart';

enum UsersStateStatus { initial, loading, success, failure }

enum UsersFilter { all, admin, moderator }

final class UsersState {
  final UsersStateStatus status;
  final List<UsersViewData> allUsers;
  final List<UsersViewData> visibleUsers;
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
    List<UsersViewData>? allUsers,
    List<UsersViewData>? visibleUsers,
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

final class UsersViewData {
  final int? id;
  final String fullName;
  final String email;
  final UserType role;
  final String photo;

  const UsersViewData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.photo,
  });

  factory UsersViewData.fromMeModel(MeModel me) {
    final firstName = (me.firstName ?? '').trim();
    final lastName = (me.lastName ?? '').trim();
    final normalizedRole = (me.role ?? '').trim().toLowerCase();
    final composedName = [firstName, lastName]
        .where((part) => part.isNotEmpty)
        .join(' ')
        .trim();

    return UsersViewData(
      id: me.id,
      fullName: composedName.isEmpty ? 'Sem nome' : composedName,
      email: (me.email ?? '').trim(),
      role: normalizedRole == 'admin' ? UserType.admin : UserType.moderator,
      photo: (me.image ?? '').trim(),
    );
  }

  String get initial {
    final normalized = fullName.trim();
    if (normalized.isEmpty) {
      return '?';
    }

    return normalized.substring(0, 1).toUpperCase();
  }
}
