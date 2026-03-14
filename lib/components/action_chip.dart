import 'package:flutter/material.dart';

class FilterChipComponent extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChipComponent({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      avatar: isSelected ? const Icon(Icons.check, size: 16) : null,
      side: BorderSide(color: colorScheme.outlineVariant),
      backgroundColor: isSelected
          ? colorScheme.secondaryContainer
          : colorScheme.surfaceContainerHigh,
      labelStyle: TextStyle(
        color: isSelected
            ? colorScheme.onSecondaryContainer
            : colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
