import 'package:adhikar/theme/color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColorScheme.light.background,
    cardColor: AppColorScheme.light.card,
    primaryColor: AppColorScheme.light.primary,
    colorScheme: ColorScheme.light(
      primary: AppColorScheme.light.primary,
      secondary: AppColorScheme.light.secondary,
      surface: AppColorScheme.light.surface,
      error: AppColorScheme.light.error,
      onPrimary: AppColorScheme.light.onPrimary,
      onSecondary: AppColorScheme.light.onSecondary,
      onSurface: AppColorScheme.light.onSurface,
      onError: AppColorScheme.light.onPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorScheme.light.background,
      foregroundColor: AppColorScheme.light.textPrimary,
      iconTheme: IconThemeData(color: AppColorScheme.light.iconPrimary),
      titleTextStyle: TextStyle(
        color: AppColorScheme.light.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColorScheme.light.background,
      selectedItemColor: AppColorScheme.light.primary,
      unselectedItemColor: AppColorScheme.light.iconSecondary,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColorScheme.light.textPrimary),
      bodyMedium: TextStyle(color: AppColorScheme.light.textSecondary),
      bodySmall: TextStyle(color: AppColorScheme.light.textTertiary),
    ),
    dividerColor: AppColorScheme.light.divider,
    hintColor: AppColorScheme.light.textHint,
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColorScheme.dark.background,
    cardColor: AppColorScheme.dark.card,
    primaryColor: AppColorScheme.dark.primary,
    colorScheme: ColorScheme.dark(
      primary: AppColorScheme.dark.primary,
      secondary: AppColorScheme.dark.secondary,
      surface: AppColorScheme.dark.surface,
      error: AppColorScheme.dark.error,
      onPrimary: AppColorScheme.dark.onPrimary,
      onSecondary: AppColorScheme.dark.onSecondary,
      onSurface: AppColorScheme.dark.onSurface,
      onError: AppColorScheme.dark.onPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorScheme.dark.background,
      foregroundColor: AppColorScheme.dark.textPrimary,
      iconTheme: IconThemeData(color: AppColorScheme.dark.iconPrimary),
      titleTextStyle: TextStyle(
        color: AppColorScheme.dark.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColorScheme.dark.background,
      selectedItemColor: AppColorScheme.dark.primary,
      unselectedItemColor: AppColorScheme.dark.iconSecondary,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColorScheme.dark.textPrimary),
      bodyMedium: TextStyle(color: AppColorScheme.dark.textSecondary),
      bodySmall: TextStyle(color: AppColorScheme.dark.textTertiary),
    ),
    dividerColor: AppColorScheme.dark.divider,
    hintColor: AppColorScheme.dark.textHint,
  );
}
