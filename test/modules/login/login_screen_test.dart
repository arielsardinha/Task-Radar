import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:async';
import 'package:task_radar/modules/login/login_screen.dart';
import 'package:task_radar/modules/login/view_models/login_view_model.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockLoginRepository loginRepository;
  late LoginViewModel viewModel;

  setUp(() {
    loginRepository = MockLoginRepository();
    viewModel = LoginViewModel(loginRepository: loginRepository);
  });

  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(viewModel: viewModel)),
    );
    await tester.pumpAndSettle();
  }

  Finder usernameFieldFinder() =>
      find.byKey(const Key('LoginScreen.TextFormField.username'));

  Finder passwordFieldFinder() =>
      find.byKey(const Key('LoginScreen.TextFormField.password'));

  Finder submitButtonFinder() =>
      find.byKey(const Key('LoginScreen.ElevatedButton.submit'));

  Finder loadingIndicatorFinder() => find.byKey(
    const Key('LoginScreen.CircularProgressIndicator.authLoading'),
  );

  group('LoginScreen widget tests', () {
    testWidgets(
      'deve exibir todas as mensagens de validacao quando campos estiverem vazios',
      (tester) async {
        await pumpLoginScreen(tester);

        await tester.tap(submitButtonFinder());
        await tester.pumpAndSettle();

        expect(find.text('Informe o nome de usuário'), findsOneWidget);
        expect(find.text('Informe a senha'), findsOneWidget);
        verifyNever(loginRepository.login(any, any));
      },
    );

    testWidgets(
      'deve exibir validacao de senha quando apenas usuario for informado',
      (tester) async {
        await pumpLoginScreen(tester);

        await tester.enterText(usernameFieldFinder(), 'emilys');
        await tester.tap(submitButtonFinder());
        await tester.pumpAndSettle();
        expect(find.text('Informe o nome de usuário'), findsNothing);
        expect(find.text('Informe a senha'), findsOneWidget);
        verifyNever(loginRepository.login(any, any));
      },
    );

    testWidgets(
      'deve exibir validacao de usuario quando apenas senha for informada',
      (tester) async {
        await pumpLoginScreen(tester);

        await tester.enterText(passwordFieldFinder(), 'emilyspass');
        await tester.tap(submitButtonFinder());
        await tester.pumpAndSettle();

        expect(find.text('Informe o nome de usuário'), findsOneWidget);
        expect(find.text('Informe a senha'), findsNothing);
        verifyNever(loginRepository.login(any, any));
      },
    );
  
    testWidgets(
      'deve exibir loading enquanto autenticacao estiver em andamento',
      (tester) async {
        final completer = Completer<void>();
        when(
          loginRepository.login('emilys', 'emilyspass'),
        ).thenAnswer((_) => completer.future);

        await pumpLoginScreen(tester);

        await tester.enterText(usernameFieldFinder(), 'emilys');
        await tester.enterText(passwordFieldFinder(), 'emilyspass');
        await tester.tap(submitButtonFinder());
        await tester.pump();

        expect(loadingIndicatorFinder(), findsOneWidget);

        completer.complete();
        await tester.pumpAndSettle();

        expect(loadingIndicatorFinder(), findsNothing);
        verify(loginRepository.login('emilys', 'emilyspass')).called(1);
      },
    );

    testWidgets(
      'deve concluir autenticacao com sucesso sem feedback de erro',
      (tester) async {
        when(
          loginRepository.login('emilys', 'emilyspass'),
        ).thenAnswer((_) async {});

        await pumpLoginScreen(tester);

        await tester.enterText(usernameFieldFinder(), 'emilys');
        await tester.enterText(passwordFieldFinder(), 'emilyspass');
        await tester.tap(submitButtonFinder());
        await tester.pump();
        await tester.pumpAndSettle();

        verify(loginRepository.login('emilys', 'emilyspass')).called(1);
        expect(find.byKey(const Key('LoginScreen.Text.feedbackError')), findsNothing);
        expect(loadingIndicatorFinder(), findsNothing);
      },
    );

    testWidgets(
      'deve exibir feedback de erro e limpar senha quando autenticacao falhar',
      (tester) async {
        when(
          loginRepository.login('emilys', 'emilyspass'),
        ).thenThrow(Exception('erro de autenticacao'));

        await pumpLoginScreen(tester);

        await tester.enterText(usernameFieldFinder(), 'emilys');
        await tester.enterText(passwordFieldFinder(), 'emilyspass');
        await tester.tap(submitButtonFinder());
        await tester.pump();
        await tester.pumpAndSettle();

        verify(loginRepository.login('emilys', 'emilyspass')).called(1);
        expect(find.byKey(const Key('LoginScreen.Text.feedbackError')), findsOneWidget);

        final editableTexts = tester
            .widgetList<EditableText>(find.byType(EditableText))
            .toList();
        expect(editableTexts.length, greaterThanOrEqualTo(2));
        expect(editableTexts[1].controller.text, isEmpty);
      },
    );
  });
}
