import 'package:flutter/material.dart';

class NewTaskBottomSheet extends StatefulWidget {
  const NewTaskBottomSheet({super.key});

  @override
  State<NewTaskBottomSheet> createState() => _NewTaskBottomSheetState();
}

class _NewTaskBottomSheetState extends State<NewTaskBottomSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nova tarefa',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(hintText: 'Nome da tarefa'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              minLines: 5,
              decoration: const InputDecoration(hintText: 'Descrição'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.onSurface.withValues(alpha: 0.1),
                foregroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
                disabledBackgroundColor: colorScheme.onSurface.withValues(
                  alpha: 0.1,
                ),
                disabledForegroundColor: colorScheme.onSurface.withValues(
                  alpha: 0.38,
                ),
                elevation: 0,
              ),
              child: const Text('Criar tarefa'),
            ),
          ],
        ),
      ),
    );
  }
}
