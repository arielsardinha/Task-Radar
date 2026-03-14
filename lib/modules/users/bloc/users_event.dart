import 'package:task_radar/modules/users/bloc/users_state.dart';

abstract class UsersEvent {
  const UsersEvent();
}

final class UsersEventLoad extends UsersEvent {
  const UsersEventLoad();
}

final class UsersEventSearchChanged extends UsersEvent {
  final String query;

  const UsersEventSearchChanged(this.query);
}

final class UsersEventFilterChanged extends UsersEvent {
  final UsersFilter filter;

  const UsersEventFilterChanged(this.filter);
}
