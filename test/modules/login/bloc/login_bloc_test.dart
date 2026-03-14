import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_radar/domain/user.dart';
import 'package:task_radar/modules/login/bloc/login_bloc.dart';
import 'package:task_radar/modules/login/bloc/login_event.dart';
import 'package:task_radar/modules/login/bloc/login_state.dart';

import '../../../mocks.mocks.dart';

const dummyUser = User(
  fullName: 'Usuario Teste',
  email: 'usuario@teste.com',
  phone: '11999999999',
  company: 'Task Radar',
  department: 'Produto',
  photo: 'https://dummyjson.com/icon/usuario/128',
  userType: UserType.moderator,
);

void main() {
  late MockLoginRepository loginRepository;
  late LoginBloc loginBloc;

  setUpAll(() {
    provideDummy<User>(dummyUser);
  });

  setUp(() {
    loginRepository = MockLoginRepository();
    loginBloc = LoginBloc(loginRepository: loginRepository);
  });

  tearDown(() async {
    await loginBloc.close();
  });

  test('deve emitir Loading e Success ao autenticar com sucesso', () async {
    when(loginRepository.login('emilys', 'emilyspass')).thenAnswer((_) async => dummyUser);

    loginBloc.add(LoginEventSubmit(username: 'emilys', password: 'emilyspass'));

    await expectLater(
      loginBloc.stream,
      emitsInOrder([
        isA<LoginStateLoading>(),
        isA<LoginStateSuccess>(),
      ]),
    );

    verify(loginRepository.login('emilys', 'emilyspass')).called(1);
  });

  test('deve emitir Loading e Failure ao falhar autenticacao', () async {
    when(loginRepository.login('emilys', 'emilyspass')).thenThrow(Exception('erro'));

    loginBloc.add(LoginEventSubmit(username: 'emilys', password: 'emilyspass'));

    await expectLater(
      loginBloc.stream,
      emitsInOrder([
        isA<LoginStateLoading>(),
        isA<LoginStateFailure>(),
      ]),
    );

    verify(loginRepository.login('emilys', 'emilyspass')).called(1);
  });

  test('deve alternar obscurePassword com evento de visibilidade', () async {
    expect(loginBloc.state.obscurePassword, isTrue);

    loginBloc.add(LoginEventTogglePasswordVisibility());

    await expectLater(
      loginBloc.stream,
      emits(
        isA<LoginStateInitial>().having(
          (state) => state.obscurePassword,
          'obscurePassword',
          isFalse,
        ),
      ),
    );
  });
}
