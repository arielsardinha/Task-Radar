import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_radar/components/botton_navigator/navigation_bar_enum.dart';
import 'package:task_radar/domain/user.dart';
import 'package:task_radar/global/providers/provider_user.dart';
import 'package:provider/provider.dart';

class TaskRadarBottomNavigator extends StatelessWidget {
  final NavigationBarEnum page;

  const TaskRadarBottomNavigator({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final items = _navigationItems(context);

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(80),
        ),
        child: Row(
          children: items
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

  List<NavigationBarEnum> _navigationItems(BuildContext context) {
    final providerUser = Provider.of<ProviderUser?>(context, listen: false);
    final isAdmin = providerUser?.user.userType == UserType.admin;

    if (isAdmin) {
      return const [
        NavigationBarEnum.home,
        NavigationBarEnum.tasks,
        NavigationBarEnum.users,
        NavigationBarEnum.profile,
      ];
    }

    return const [
      NavigationBarEnum.home,
      NavigationBarEnum.tasks,
      NavigationBarEnum.profile,
    ];
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
      NavigationBarEnum.users => 'Usuários',
      NavigationBarEnum.profile => 'Perfil',
    };

    final icon = switch (item) {
      NavigationBarEnum.home => Icons.home_outlined,
      NavigationBarEnum.tasks => Icons.task_alt_outlined,
      NavigationBarEnum.users => Icons.group_outlined,
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
                      ? Theme.of(context).colorScheme.secondaryContainer
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
