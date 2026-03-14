import 'package:flutter/material.dart';

sealed class AppTheme {
  static const Color _lightPrimary = Color(0xFF6750A4);
  static const Color _lightOnPrimary = Color(0xFFFFFFFF);
  static const Color _lightOutline = Color(0xFF79747E);
  static const Color _lightOnSurfaceVariant = Color(0xFF49454F);
  static const Color _lightSurface = Color(0xFFFEF7FF);
  static const Color _lightBackground = Color(0xFFE7E7E7);
  static const Color _lightOnSurface = Color(0xFF1D1B20);

  static const Color _darkPrimary = Color(0xFFB39DDB);
  static const Color _darkOnPrimary = Color(0xFF2E1F55);
  static const Color _darkOutline = Color(0xFF9A93A8);
  static const Color _darkOnSurfaceVariant = Color(0xFFC9C4D0);
  static const Color _darkSurface = Color(0xFF070417);
  static const Color _darkBackground = Color(0xFF070417);
  static const Color _darkOnSurface = Color(0xFFEAE6F2);

  static ThemeData get light => _buildTheme(
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: _lightPrimary,
      onPrimary: _lightOnPrimary,
      secondary: Color(0xFF625B71),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFB3261E),
      onError: Color(0xFFFFFFFF),
      surface: _lightSurface,
      onSurface: _lightOnSurface,
      outline: _lightOutline,
      onSurfaceVariant: _lightOnSurfaceVariant,
    ),
    scaffoldBackground: _lightBackground,
  );

  static ThemeData get dark => _buildTheme(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: _darkPrimary,
      onPrimary: _darkOnPrimary,
      secondary: Color(0xFFCCC2DC),
      onSecondary: Color(0xFF332D41),
      error: Color(0xFFF2B8B5),
      onError: Color(0xFF601410),
      surface: _darkSurface,
      onSurface: _darkOnSurface,
      outline: _darkOutline,
      onSurfaceVariant: _darkOnSurfaceVariant,
    ),
    scaffoldBackground: _darkBackground,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      splashFactory: InkRipple.splashFactory,
    );

    final textTheme = base.textTheme.copyWith(
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontSize: 16,
        height: 24 / 16,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(
        fontSize: 16,
        height: 24 / 16,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: base.textTheme.bodySmall?.copyWith(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.4,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: base.textTheme.displaySmall?.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.96,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        elevation: 0,
        centerTitle: false,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: textTheme.bodySmall,
        floatingLabelStyle: textTheme.bodySmall,
        hintStyle: textTheme.bodyLarge,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: const StadiumBorder(),
          elevation: 0,
          textStyle: textTheme.titleMedium,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 56),
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          foregroundColor: colorScheme.onSurface,
          textStyle: textTheme.titleMedium,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
          shape: const CircleBorder(),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        focusElevation: 4,
        hoverElevation: 4,
        shape: const CircleBorder(),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.18),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return (textTheme.bodySmall ?? const TextStyle()).copyWith(
            color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          );
        }),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        modalBackgroundColor: colorScheme.surface,
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        dragHandleColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.45),
        dragHandleSize: const Size(32, 4),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.5),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.surface,
        contentTextStyle: textTheme.bodyLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
