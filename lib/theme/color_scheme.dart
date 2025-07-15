import 'package:flutter/material.dart';

/// Centralized color scheme for light and dark themes
/// This provides a single source of truth for all app colors
class AppColorScheme {
  // Light theme colors
  static const LightColors light = LightColors();

  // Dark theme colors
  static const DarkColors dark = DarkColors();
}

/// Light theme color definitions
class LightColors {
  const LightColors();

  // Primary colors
  Color get primary => const Color.fromRGBO(44, 37, 115, 1);
  Color get secondary => const Color.fromRGBO(163, 194, 235, 1);

  // Background colors
  Color get background => Colors.white;
  Color get surface => Colors.white;
  Color get card => const Color.fromARGB(255, 233, 233, 233);

  // Content colors
  Color get onBackground => Colors.black;
  Color get onSurface => Colors.black;
  Color get onCard => Colors.black;
  Color get onPrimary => Colors.white;
  Color get onSecondary => Colors.black;

  // Text colors
  Color get textPrimary => Colors.black;
  Color get textSecondary => Colors.black87;
  Color get textTertiary => Colors.black54;
  Color get textHint => Colors.grey;

  // Status colors
  Color get error => Colors.red;
  Color get success => Colors.green;
  Color get warning => Colors.orange;
  Color get info => Colors.blue;

  // Border and divider colors
  Color get border => Colors.grey.shade300;
  Color get divider => Colors.grey.shade300;

  // Icon colors
  Color get iconPrimary => Colors.black;
  Color get iconSecondary => Colors.grey;
}

/// Dark theme color definitions
class DarkColors {
  const DarkColors();

  // Primary colors
  Color get primary => const Color.fromRGBO(44, 37, 115, 1);
  Color get secondary => const Color.fromRGBO(163, 194, 235, 1);

  // Background colors
  Color get background => Colors.black;
  Color get surface => const Color.fromARGB(255, 20, 20, 40);
  Color get card => const Color.fromARGB(255, 20, 20, 40);

  // Content colors
  Color get onBackground => Colors.white;
  Color get onSurface => Colors.white;
  Color get onCard => Colors.white;
  Color get onPrimary => Colors.white;
  Color get onSecondary => Colors.black;

  // Text colors
  Color get textPrimary => Colors.white;
  Color get textSecondary => Colors.white70;
  Color get textTertiary => Colors.white54;
  Color get textHint => Colors.grey;

  // Status colors
  Color get error => Colors.red;
  Color get success => Colors.green;
  Color get warning => Colors.orange;
  Color get info => Colors.blue;

  // Border and divider colors
  Color get border => Colors.grey.shade700;
  Color get divider => Colors.grey.shade700;

  // Icon colors
  Color get iconPrimary => Colors.white;
  Color get iconSecondary => Colors.grey;
}

/// Extension to easily access theme colors from BuildContext
extension AppColorsExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  LightColors get lightColors => AppColorScheme.light;
  DarkColors get darkColors => AppColorScheme.dark;

  // Dynamic colors that change based on current theme
  Color get primaryColor =>
      isDarkMode ? darkColors.primary : lightColors.primary;
  Color get secondaryColor =>
      isDarkMode ? darkColors.secondary : lightColors.secondary;
  Color get backgroundColor =>
      isDarkMode ? darkColors.background : lightColors.background;
  Color get surfaceColor =>
      isDarkMode ? darkColors.surface : lightColors.surface;
  Color get cardColor => isDarkMode ? darkColors.card : lightColors.card;
  Color get textPrimaryColor =>
      isDarkMode ? darkColors.textPrimary : lightColors.textPrimary;
  Color get textSecondaryColor =>
      isDarkMode ? darkColors.textSecondary : lightColors.textSecondary;
  Color get textTertiaryColor =>
      isDarkMode ? darkColors.textTertiary : lightColors.textTertiary;
  Color get textHintColor =>
      isDarkMode ? darkColors.textHint : lightColors.textHint;
  Color get errorColor => isDarkMode ? darkColors.error : lightColors.error;
  Color get successColor =>
      isDarkMode ? darkColors.success : lightColors.success;
  Color get warningColor =>
      isDarkMode ? darkColors.warning : lightColors.warning;
  Color get infoColor => isDarkMode ? darkColors.info : lightColors.info;
  Color get borderColor => isDarkMode ? darkColors.border : lightColors.border;
  Color get dividerColor =>
      isDarkMode ? darkColors.divider : lightColors.divider;
  Color get iconPrimaryColor =>
      isDarkMode ? darkColors.iconPrimary : lightColors.iconPrimary;
  Color get iconSecondaryColor =>
      isDarkMode ? darkColors.iconSecondary : lightColors.iconSecondary;
}
