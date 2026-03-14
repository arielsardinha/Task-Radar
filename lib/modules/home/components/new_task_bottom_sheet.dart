import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef NewTaskSubmitCallback =
    Future<void> Function({required String name, required String description});

class NewTaskBottomSheet extends StatefulWidget {
  final NewTaskSubmitCallback onSubmit;

  const NewTaskBottomSheet({super.key, required this.onSubmit});

  @override
  State<NewTaskBottomSheet> createState() => _NewTaskBottomSheetState();
}

class _NewTaskBottomSheetState extends State<NewTaskBottomSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final canSubmit =
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
                onPressed: canSubmit
                    ? () async {
                        setState(() {
                          _isSubmitting = true;
                        });

                        try {
                          await widget.onSubmit(
                            name: _nameController.text.trim(),
                            description: _descriptionController.text.trim(),
                          );
                          if (context.mounted) {
                            GoRouter.of(context).pop();
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isSubmitting = false;
                            });
                          }
                        }
                      }
                    : null,
                child: Visibility(
                  visible: _isSubmitting,
                  replacement: const Text('Criar tarefa'),
                  child: const SizedBox(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
