import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_radar/components/botton_navigator/navigation_bar_enum.dart';

class TaskRadarBottomNavigator extends StatelessWidget {
  final NavigationBarEnum page;

  const TaskRadarBottomNavigator({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3EDF7),
          borderRadius: BorderRadius.circular(80),
        ),
        child: Row(
          children: NavigationBarEnum.values
              .map(
                (item) => Expanded(
                  child: _NavigationItem(
                    item: item,
                    isSelected: page == item,
                    onTap: () {
                      if (page == item) {
                        return;
                      }

                      context.go(item.route);
                    },
                    labelStyle: textTheme.labelMedium ?? const TextStyle(),
                    selectedColor: colorScheme.onSurface,
                    unselectedColor: colorScheme.onSurfaceVariant,
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final NavigationBarEnum item;
  final bool isSelected;
  final VoidCallback onTap;
  final TextStyle labelStyle;
  final Color selectedColor;
  final Color unselectedColor;

  const _NavigationItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.labelStyle,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final label = switch (item) {
      NavigationBarEnum.home => 'Início',
      NavigationBarEnum.tasks => 'Tarefas',
      NavigationBarEnum.profile => 'Perfil',
    };

    final icon = switch (item) {
      NavigationBarEnum.home => Icons.home_outlined,
      NavigationBarEnum.tasks => Icons.task_alt_outlined,
      NavigationBarEnum.profile => Icons.account_circle_outlined,
    };

    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFE8DEF8)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 24,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: labelStyle.copyWith(
                  color: isSelected ? selectedColor : unselectedColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
