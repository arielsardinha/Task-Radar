import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:task_radar/modules/tasks/components/edit_task_bottom_sheet.dart';

void main() {
  Future<void> pumpFrames(WidgetTester tester, [int frames = 6]) async {
    for (var i = 0; i < frames; i++) {
      await tester.pump(const Duration(milliseconds: 80));
    }
  }

  Future<void> pumpHost(
    WidgetTester tester, {
    required Future<void> Function({
      required String name,
      required String description,
    })
    onSave,
    required Future<void> Function() onDelete,
    String initialName = 'Tarefa inicial',
    String initialDescription = 'Descricao inicial',
  }) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  key: const Key('open-edit-bottom-sheet'),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      builder: (_) => EditTaskBottomSheet(
                        initialName: initialName,
                        initialDescription: initialDescription,
                        onSave: onSave,
                        onDelete: onDelete,
                      ),
                    );
                  },
                  child: const Text('Abrir'),
                ),
              ),
            );
          },
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.byKey(const Key('open-edit-bottom-sheet')));
    await pumpFrames(tester, 5);
  }

  Finder fieldsInSheet() {
    return find.descendant(
      of: find.byType(BottomSheet),
      matching: find.byType(TextFormField),
    );
  }

  group('EditTaskBottomSheet', () {
    testWidgets('renderiza valores iniciais e permite salvar', (tester) async {
      var saveCalls = 0;

      await pumpHost(
        tester,
        onSave: ({required name, required description}) async {
          saveCalls++;
          expect(name, 'Tarefa inicial');
          expect(description, 'Descricao inicial');
        },
        onDelete: () async {},
      );

      expect(find.text('Editar tarefa'), findsOneWidget);
      final fields = fieldsInSheet();
      expect(find.text('Tarefa inicial'), findsOneWidget);
      expect(find.text('Descricao inicial'), findsOneWidget);

      final saveButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Salvar'),
      );
      expect(saveButton.onPressed, isNotNull);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar'));
      await pumpFrames(tester, 8);

      expect(saveCalls, 1);
      expect(find.text('Editar tarefa'), findsNothing);
      expect(fields, findsNothing);
    });

    testWidgets('mostra validacao quando nome ou descricao vazios', (
      tester,
    ) async {
      var saveCalls = 0;

      await pumpHost(
        tester,
        onSave: ({required name, required description}) async {
          saveCalls++;
        },
        onDelete: () async {},
      );

      final fields = fieldsInSheet();
      await tester.enterText(fields.at(0), '');
      await pumpFrames(tester, 2);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar'));
      await pumpFrames(tester, 2);

      expect(find.text('Informe o nome da tarefa'), findsOneWidget);
      expect(saveCalls, 0);

      await tester.enterText(fields.at(0), 'Nome ok');
      await tester.enterText(fields.at(1), '');
      await pumpFrames(tester, 2);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar'));
      await pumpFrames(tester, 2);

      expect(find.text('Informe a descrição'), findsOneWidget);
      expect(saveCalls, 0);
    });

    testWidgets('mostra loading durante submit e fecha ao concluir', (
      tester,
    ) async {
      final completer = Completer<void>();

      await pumpHost(
        tester,
        onSave: ({required name, required description}) => completer.future,
        onDelete: () async {},
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final deleteButton = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Excluir').first,
      );
      expect(deleteButton.onPressed, isNull);

      completer.complete();
      await pumpFrames(tester, 8);

      expect(find.text('Editar tarefa'), findsNothing);
    });

    testWidgets('cancelar exclusao nao dispara callback', (tester) async {
      var deleteCalls = 0;

      await pumpHost(
        tester,
        onSave: ({required name, required description}) async {},
        onDelete: () async {
          deleteCalls++;
        },
      );

      await tester.tap(find.widgetWithText(TextButton, 'Excluir').first);
      await pumpFrames(tester, 4);

      expect(find.text('Excluir tarefa?'), findsOneWidget);
      expect(
        find.text('A tarefa desaparecerá e não poderá ser recuperada.'),
        findsOneWidget,
      );

      await tester.tap(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.text('Cancelar'),
        ),
      );
      await pumpFrames(tester, 4);

      expect(deleteCalls, 0);
      expect(find.text('Editar tarefa'), findsOneWidget);
    });

    testWidgets('confirmar exclusao dispara callback e fecha modal', (
      tester,
    ) async {
      var deleteCalls = 0;

      await pumpHost(
        tester,
        onSave: ({required name, required description}) async {},
        onDelete: () async {
          deleteCalls++;
        },
      );

      await tester.tap(find.widgetWithText(TextButton, 'Excluir').first);
      await pumpFrames(tester, 4);

      await tester.tap(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.text('Excluir'),
        ),
      );
      await pumpFrames(tester, 8);

      expect(deleteCalls, 1);
      expect(find.text('Editar tarefa'), findsNothing);
    });
  });
}
