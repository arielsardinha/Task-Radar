abstract class LoginEvent {}

final class LoginEventTogglePasswordVisibility extends LoginEvent {}

final class LoginEventSubmit extends LoginEvent {
  final String username;
  final String password;

  LoginEventSubmit({required this.username, required this.password});
}
