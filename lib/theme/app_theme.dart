import 'package:flutter/material.dart';

class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color success;
  final Color successContainer;
  final Color pending;

  const AppSemanticColors({
    required this.success,
    required this.successContainer,
    required this.pending,
  });

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? successContainer,
    Color? pending,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      pending: pending ?? this.pending,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) {
      return this;
    }

    return AppSemanticColors(
      success: Color.lerp(success, other.success, t) ?? success,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t) ??
          successContainer,
      pending: Color.lerp(pending, other.pending, t) ?? pending,
    );
  }
}

sealed class AppTheme {
  static const Color _seed = Color(0xFF6750A4);
  static const Color _lightScaffold = Color(0xFFFFFFFF);
  static const Color _darkScaffold = Color(0xFF070417);

  static const AppSemanticColors _lightSemantic = AppSemanticColors(
    success: Color(0xFF31CD84),
    successContainer: Color(0x1F31CD84),
    pending: Color(0xFFD9D2E9),
  );

  static const AppSemanticColors _darkSemantic = AppSemanticColors(
    success: Color(0xFF7EE2B2),
    successContainer: Color(0x2A7EE2B2),
    pending: Color(0xFF8A829A),
  );

  static ThemeData get light => _buildTheme(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF6750A4),
      onPrimary: const Color(0xFFFFFFFF),
      primaryContainer: const Color(0xFFEADDFF),
      onPrimaryContainer: const Color(0xFF4F378A),
      secondary: const Color(0xFF625B71),
      onSecondary: const Color(0xFFFFFFFF),
      secondaryContainer: const Color(0xFFE8DEF8),
      onSecondaryContainer: const Color(0xFF4A4459),
      error: const Color(0xFFB3261E),
      onError: const Color(0xFFFFFFFF),
      surface: const Color(0xFFFEF7FF),
      onSurface: const Color(0xFF1D1B20),
      onSurfaceVariant: const Color(0xFF49454F),
      outline: const Color(0xFF79747E),
      outlineVariant: const Color(0xFFCAC4D0),
      surfaceContainer: const Color(0xFFF3EDF7),
      inverseSurface: const Color(0xFF322F35),
      onInverseSurface: const Color(0xFFF5EFF7),
      inversePrimary: const Color(0xFFD0BCFF),
      scrim: const Color(0xFF000000),
    ),
    scaffoldBackground: _lightScaffold,
    semanticColors: _lightSemantic,
  );

  static ThemeData get dark => _buildTheme(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ).copyWith(
      surface: const Color(0xFF070417),
      inverseSurface: const Color(0xFFEAE6F2),
      onInverseSurface: const Color(0xFF322F35),
      inversePrimary: const Color(0xFF6750A4),
      scrim: const Color(0xFF000000),
    ),
    scaffoldBackground: _darkScaffold,
    semanticColors: _darkSemantic,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
    required AppSemanticColors semanticColors,
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
      extensions: <ThemeExtension<dynamic>>[semanticColors],
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
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        closeIconColor: colorScheme.onInverseSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
