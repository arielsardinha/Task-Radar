import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef EditTaskSubmitCallback =
    Future<void> Function({required String name, required String description});
typedef DeleteTaskCallback = Future<void> Function();

class EditTaskBottomSheet extends StatefulWidget {
  final String initialName;
  final String initialDescription;
  final EditTaskSubmitCallback onSave;
  final DeleteTaskCallback onDelete;

  const EditTaskBottomSheet({
    super.key,
    required this.initialName,
    required this.initialDescription,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditTaskBottomSheet> createState() => _EditTaskBottomSheetState();
}

class _EditTaskBottomSheetState extends State<EditTaskBottomSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descriptionController = TextEditingController(
      text: widget.initialDescription,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final canSave =
        !_isSubmitting &&
        _nameController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty;

    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.fromLTRB(16, 4, 16, 24 + bottomInset),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Editar tarefa',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(hintText: 'Nome da tarefa'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                minLines: 5,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(hintText: 'Descrição'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: canSave
                    ? () async {
                        setState(() => _isSubmitting = true);
                        try {
                          await widget.onSave(
                            name: _nameController.text.trim(),
                            description: _descriptionController.text.trim(),
                          );
                          if (context.mounted) {
                            GoRouter.of(context).pop();
                          }
                        } finally {
                          if (mounted) {
                            setState(() => _isSubmitting = false);
                          }
                        }
                      }
                    : null,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Salvar'),
              ),
              const SizedBox(height: 8),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: _isSubmitting
                    ? null
                    : () async {
                        final confirmed = await _showDeleteConfirmation();
                        if (confirmed != true) {
                          return;
                        }

                        await widget.onDelete();
                        if (context.mounted) {
                          GoRouter.of(context).pop();
                        }
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete_outline),
                    const SizedBox(width: 8),
                    const Text('Excluir'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: const Color(0xFFECE6F0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Excluir tarefa?',
                  style: textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'A tarefa desaparecerá e não poderá ser recuperada.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => dialogContext.pop(false),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFFF383C),
                      ),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => dialogContext.pop(true),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFFF383C),
                      ),
                      child: const Text('Excluir'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
