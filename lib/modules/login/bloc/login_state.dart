import 'package:task_radar/domain/user.dart';

abstract class LoginState {
  final bool obscurePassword;

  const LoginState({required this.obscurePassword});
}

final class LoginStateInitial extends LoginState {
  const LoginStateInitial({required super.obscurePassword});
}

final class LoginStateLoading extends LoginState {
  const LoginStateLoading({required super.obscurePassword});
}

final class LoginStateFailure extends LoginState {
  final String message;

  const LoginStateFailure({
    required this.message,
    required super.obscurePassword,
  });
}

final class LoginStateSuccess extends LoginState {
  final User user;

  const LoginStateSuccess({
    required this.user,
    required super.obscurePassword,
  });
}
