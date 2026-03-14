import 'package:flutter/material.dart';

final class ThemeModeModel {
  final String mode;

  const ThemeModeModel({required this.mode});

  factory ThemeModeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModeModel(mode: (json['mode'] as String? ?? 'light').trim());
  }

  Map<String, dynamic> toJson() {
    return {'mode': mode};
  }

  ThemeMode toThemeMode() {
    return switch (mode) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  static ThemeModeModel fromThemeMode(ThemeMode themeMode) {
    return ThemeModeModel(
      mode: switch (themeMode) {
        ThemeMode.dark => 'dark',
        ThemeMode.light => 'light',
        ThemeMode.system => 'system',
      },
    );
  }
}
