import 'package:flutter/material.dart';

/// Clinical/minimal visual direction (Checkpoint 3): neutral grays with a
/// single signal accent color, used consistently for progress and primary
/// actions across the app.
abstract final class AppColors {
  static const Color signal = Color(0xFF0F766E); // teal — primary accent
  static const Color signalDark = Color(0xFF5EEAD4);

  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF4F4F5);
  static const Color neutral200 = Color(0xFFE4E4E7);
  static const Color neutral400 = Color(0xFFA1A1AA);
  static const Color neutral600 = Color(0xFF52525B);
  static const Color neutral800 = Color(0xFF27272A);
  static const Color neutral900 = Color(0xFF18181B);

  static const Color danger = Color(0xFFB91C1C);
  static const Color success = Color(0xFF15803D);
}

abstract final class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.signal,
      brightness: Brightness.light,
    ).copyWith(surface: AppColors.neutral50, error: AppColors.danger);

    return _base(colorScheme);
  }

  /// Dark-mode-first execution, used throughout but especially on the
  /// Trends screen per the confirmed Checkpoint 3 direction.
  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.signalDark,
      brightness: Brightness.dark,
    ).copyWith(surface: AppColors.neutral900, error: AppColors.danger);

    return _base(colorScheme);
  }

  static ThemeData _base(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(fontWeight: FontWeight.w700),
        headlineSmall: TextStyle(fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(height: 1.4),
        bodyMedium: TextStyle(height: 1.4),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(minimumSize: const Size(0, 48)),
      ),
    );
  }
}
