import 'package:flutter/material.dart';
import 'package:task_radar/data/storage/storage.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import 'package:task_radar/data/storage/theme_mode_model.dart';

class ProviderTheme extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> loadFromStorage(Storage storage) async {
    final savedTheme = await storage.getItemToFactory(
      StorageSecureEnum.app_theme,
      fromJson: ThemeModeModel.fromJson,
    );

    final resolvedTheme = savedTheme?.toThemeMode() ?? ThemeMode.light;
    if (resolvedTheme == _themeMode) {
      return;
    }

    _themeMode = resolvedTheme;
    notifyListeners();
  }

  Future<void> setThemeMode({
    required ThemeMode themeMode,
    required Storage storage,
  }) async {
    if (_themeMode == themeMode) {
      return;
    }

    _themeMode = themeMode;
    notifyListeners();

    await storage.setItem(
      StorageSecureEnum.app_theme,
      ThemeModeModel.fromThemeMode(themeMode).toJson(),
    );
  }

  Future<void> toggleTheme(Storage storage) async {
    final nextMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(themeMode: nextMode, storage: storage);
  }
}
