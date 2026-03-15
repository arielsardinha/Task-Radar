import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:task_radar/data/storage/storage_impl.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import 'package:task_radar/domain/user.dart';
import 'package:task_radar/global/providers/provider_connectivity.dart';
import 'package:task_radar/global/providers/provider_user.dart';
import 'package:task_radar/modules/login/bloc/login_bloc.dart';
import 'package:task_radar/modules/login/bloc/login_state.dart';
import 'package:task_radar/modules/login/login_screen.dart';

import '../../mocks.mocks.dart';

const dummyUser = User(
  id: '1',
  fullName: 'Usuario Teste',
  email: 'usuario@teste.com',
  phone: '11999999999',
  company: 'Task Radar',
  department: 'Produto',
  photo: 'https://dummyjson.com/icon/usuario/128',
  userType: UserType.moderator,
);

void main() {
  late MockAuthRepository authRepository;
  late MockStorageImpl storage;
  late LoginBloc loginBloc;
  late ProviderConnectivity providerConnectivity;

  setUpAll(() {
    provideDummy<User>(dummyUser);
  });

  setUp(() {
    authRepository = MockAuthRepository();
    storage = MockStorageImpl();
    loginBloc = LoginBloc(authRepository: authRepository);
    providerConnectivity = ProviderConnectivity();

    final getIt = GetIt.instance;
    if (getIt.isRegistered<StorageImpl>()) {
      getIt.unregister<StorageImpl>();
    }
    getIt.registerSingleton<StorageImpl>(storage);

    when(storage.setItem(any, any)).thenAnswer((_) async {});
    when(storage.removeItem(any)).thenAnswer((_) async {});
  });

  tearDown(() async {
    await loginBloc.close();
    await GetIt.instance.reset();
  });

  Future<void> settleBlocAsyncChain(WidgetTester tester) async {
    // Garante que operacoes assincronas disparadas pelo Bloc finalizem
    // antes das assercoes da arvore de widgets.
    await tester.runAsync(() async {
      await tester.pumpAndSettle();
    });
    await tester.pumpAndSettle();
  }

  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ProviderUser>(create: (_) => ProviderUser()),
          ChangeNotifierProvider<ProviderConnectivity>.value(
            value: providerConnectivity,
          ),
          Provider<LoginBloc>.value(value: loginBloc),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await settleBlocAsyncChain(tester);
  }

  Finder offlineLoginButtonFinder() =>
      find.byKey(const Key('LoginScreen.OutlinedButton.offlineLogin'));

    Finder usernameFieldFinder() =>
      find.byKey(const Key('LoginScreen.TextFormField.username'));

    Finder passwordFieldFinder() =>
      find.byKey(const Key('LoginScreen.TextFormField.password'));

    Finder submitButtonFinder() =>
      find.byKey(const Key('LoginScreen.ElevatedButton.submit'));

    Finder loadingIndicatorFinder() => find.byKey(
    const Key('LoginScreen.CircularProgressIndicator.authLoading'),
    );

  group('LoginScreen offline login', () {
    testWidgets('deve exibir botao de logar offline quando sem internet', (
      tester,
    ) async {
      providerConnectivity.setOnline(false);
      await pumpLoginScreen(tester);

      expect(offlineLoginButtonFinder(), findsOneWidget);
    });

    testWidgets('nao deve exibir botao de logar offline quando online', (
      tester,
    ) async {
      providerConnectivity.setOnline(true);
      await pumpLoginScreen(tester);

      expect(offlineLoginButtonFinder(), findsNothing);
    });

    testWidgets('deve entrar offline sem chamar login remoto', (tester) async {
      providerConnectivity.setOnline(false);
      when(authRepository.loginOffline()).thenAnswer((_) async => dummyUser);
      await pumpLoginScreen(tester);

      await tester.tap(offlineLoginButtonFinder());
      await settleBlocAsyncChain(tester);

      verifyNever(authRepository.login(any, any));
      verify(authRepository.loginOffline()).called(1);
    });
  });

  group('LoginScreen widget tests', () {
    testWidgets(
      'deve exibir todas as mensagens de validacao quando campos estiverem vazios',
      (tester) async {
        await pumpLoginScreen(tester);

        await tester.tap(submitButtonFinder());
        await settleBlocAsyncChain(tester);

        expect(find.text('Informe o nome de usuário'), findsOneWidget);
        expect(find.text('Informe a senha'), findsOneWidget);
        verifyNever(authRepository.login(any, any));
      },
    );

    testWidgets(
      'deve exibir validacao de senha quando apenas usuario for informado',
      (tester) async {
        await pumpLoginScreen(tester);

        await tester.enterText(usernameFieldFinder(), 'emilys');
        await tester.tap(submitButtonFinder());
        await settleBlocAsyncChain(tester);
        expect(find.text('Informe o nome de usuário'), findsNothing);
        expect(find.text('Informe a senha'), findsOneWidget);
        verifyNever(authRepository.login(any, any));
      },
    );

    testWidgets(
      'deve exibir validacao de usuario quando apenas senha for informada',
      (tester) async {
        await pumpLoginScreen(tester);

        await tester.enterText(passwordFieldFinder(), 'emilyspass');
        await tester.tap(submitButtonFinder());
        await settleBlocAsyncChain(tester);

        expect(find.text('Informe o nome de usuário'), findsOneWidget);
        expect(find.text('Informe a senha'), findsNothing);
        verifyNever(authRepository.login(any, any));
      },
    );

    testWidgets(
      'deve exibir loading enquanto autenticacao estiver em andamento',
      (tester) async {
        final completer = Completer<User>();
        when(
          authRepository.login('emilys', 'emilyspass'),
        ).thenAnswer((_) => completer.future);

        await pumpLoginScreen(tester);

        await tester.enterText(usernameFieldFinder(), 'emilys');
        await tester.enterText(passwordFieldFinder(), 'emilyspass');
        await tester.tap(submitButtonFinder());
        await tester.pump();

        expect(loginBloc.state, isA<LoginStateLoading>());

        completer.complete(dummyUser);
        await tester.pumpAndSettle();

        expect(loginBloc.state, isA<LoginStateSuccess>());
        expect(loadingIndicatorFinder(), findsNothing);
        verify(authRepository.login('emilys', 'emilyspass')).called(1);
      },
    );

    testWidgets('deve concluir autenticacao com sucesso sem feedback de erro', (
      tester,
    ) async {
      when(
        authRepository.login('emilys', 'emilyspass'),
      ).thenAnswer((_) async => dummyUser);

      await pumpLoginScreen(tester);

      await tester.enterText(usernameFieldFinder(), 'emilys');
      await tester.enterText(passwordFieldFinder(), 'emilyspass');
      await tester.tap(submitButtonFinder());
      await tester.pump();
      await settleBlocAsyncChain(tester);

      verify(authRepository.login('emilys', 'emilyspass')).called(1);
      expect(
        find.byKey(const Key('LoginScreen.Text.feedbackError')),
        findsNothing,
      );
      expect(loadingIndicatorFinder(), findsNothing);
    });

    testWidgets(
      'deve exibir feedback de erro e limpar senha quando autenticacao falhar',
      (tester) async {
        when(
          authRepository.login('emilys', 'emilyspass'),
        ).thenThrow(Exception('erro de autenticacao'));

        await pumpLoginScreen(tester);

        await tester.enterText(usernameFieldFinder(), 'emilys');
        await tester.enterText(passwordFieldFinder(), 'emilyspass');
        await tester.tap(submitButtonFinder());
        await tester.pump();
        await settleBlocAsyncChain(tester);

        verify(authRepository.login('emilys', 'emilyspass')).called(1);
        expect(
          find.byKey(const Key('LoginScreen.Text.feedbackError')),
          findsOneWidget,
        );

        final editableTexts = tester
            .widgetList<EditableText>(find.byType(EditableText))
            .toList();
        expect(editableTexts.length, greaterThanOrEqualTo(2));
        expect(editableTexts[1].controller.text, isEmpty);
      },
    );
  });
}
