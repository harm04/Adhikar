import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Custom color scheme model
class CustomColorScheme {
  final Color primaryLight;
  final Color primaryDark;
  final Color secondaryLight;
  final Color secondaryDark;

  const CustomColorScheme({
    required this.primaryLight,
    required this.primaryDark,
    required this.secondaryLight,
    required this.secondaryDark,
  });

  CustomColorScheme copyWith({
    Color? primaryLight,
    Color? primaryDark,
    Color? secondaryLight,
    Color? secondaryDark,
  }) {
    return CustomColorScheme(
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      secondaryLight: secondaryLight ?? this.secondaryLight,
      secondaryDark: secondaryDark ?? this.secondaryDark,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'primaryLight': primaryLight.value,
      'primaryDark': primaryDark.value,
      'secondaryLight': secondaryLight.value,
      'secondaryDark': secondaryDark.value,
    };
  }

  // Create from JSON
  factory CustomColorScheme.fromJson(Map<String, dynamic> json) {
    return CustomColorScheme(
      primaryLight: Color(json['primaryLight'] ?? 0xFF4338CA),
      primaryDark: Color(json['primaryDark'] ?? 0xFF2C2573),
      secondaryLight: Color(json['secondaryLight'] ?? 0xFFA3C2EB),
      secondaryDark: Color(json['secondaryDark'] ?? 0xFFA3C2EB),
    );
  }
}

// Default color scheme
const defaultColorScheme = CustomColorScheme(
  primaryLight: Color(0xFF4338CA), // Indigo-600
  primaryDark: Color(0xFF2C2573), // Original dark blue
  secondaryLight: Color(0xFFA3C2EB), // Light blue
  secondaryDark: Color(0xFFA3C2EB), // Same for both modes
);

// Color customization provider
class ColorCustomizationNotifier extends StateNotifier<CustomColorScheme> {
  ColorCustomizationNotifier() : super(defaultColorScheme) {
    _loadColors();
  }

  static const String _colorsKey = 'custom_colors';

  Future<void> _loadColors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final colorsJson = prefs.getString(_colorsKey);

      if (colorsJson != null) {
        final Map<String, dynamic> colorsMap = {};
        final parts = colorsJson.split(',');
        for (String part in parts) {
          final keyValue = part.split(':');
          if (keyValue.length == 2) {
            colorsMap[keyValue[0]] = int.parse(keyValue[1]);
          }
        }
        state = CustomColorScheme.fromJson(colorsMap);
      }
    } catch (e) {
      // If loading fails, keep default colors
      state = defaultColorScheme;
    }
  }

  Future<void> _saveColors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final colorsJson = state.toJson();
      final colorString = colorsJson.entries
          .map((e) => '${e.key}:${e.value}')
          .join(',');
      await prefs.setString(_colorsKey, colorString);
    } catch (e) {
      // Handle save error silently
    }
  }

  void updatePrimaryLight(Color color) {
    state = state.copyWith(primaryLight: color);
    _saveColors();
  }

  void updatePrimaryDark(Color color) {
    state = state.copyWith(primaryDark: color);
    _saveColors();
  }

  void updateSecondaryLight(Color color) {
    state = state.copyWith(secondaryLight: color);
    _saveColors();
  }

  void updateSecondaryDark(Color color) {
    state = state.copyWith(secondaryDark: color);
    _saveColors();
  }

  void resetToDefaults() {
    state = defaultColorScheme;
    _saveColors();
  }
}

final colorCustomizationProvider =
    StateNotifierProvider<ColorCustomizationNotifier, CustomColorScheme>(
      (ref) => ColorCustomizationNotifier(),
    );
