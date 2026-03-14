import 'package:bloc/bloc.dart';
import 'package:task_radar/data/repositories/login_repository.dart';
import 'package:task_radar/modules/login/bloc/login_event.dart';
import 'package:task_radar/modules/login/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required LoginRepository loginRepository})
      : _loginRepository = loginRepository,
        super(const LoginStateInitial(obscurePassword: true)) {
    on<LoginEventTogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<LoginEventSubmit>(_onSubmit);
  }

  final LoginRepository _loginRepository;

  Future<void> _onTogglePasswordVisibility(
    LoginEventTogglePasswordVisibility event,
    Emitter<LoginState> emit,
  ) async {
    if (state is LoginStateLoading) return;

    final nextObscure = !state.obscurePassword;
    emit(LoginStateInitial(obscurePassword: nextObscure));
  }

  Future<void> _onSubmit(
    LoginEventSubmit event,
    Emitter<LoginState> emit,
  ) async {
    if (state is LoginStateLoading) return;

    emit(LoginStateLoading(obscurePassword: state.obscurePassword));

    try {
      final user = await _loginRepository.login(event.username, event.password);
      emit(LoginStateSuccess(user: user, obscurePassword: state.obscurePassword));
    } catch (_) {
      emit(
        LoginStateFailure(
          message:
              'Falha ao realizar login. Verifique suas credenciais e tente novamente.',
          obscurePassword: state.obscurePassword,
        ),
      );
    }
  }
}
