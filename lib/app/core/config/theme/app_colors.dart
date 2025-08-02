// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  // Branding Colors
  static const Color primaryColor = Color.fromARGB(255, 121, 25, 210); // Doctor Blue
  static const Color accentColor = Color.fromARGB(255, 214, 24, 231); // Cyan Accent

  // Success & Alerts
  static const Color secondaryPrimary = Color(0xFFDEA604); // Golden Yellow
  static const Color sucessPrimary = Color(0xFF4CAF50); // Medical Green

  // Light Theme
  static const Color lightBackground = Color.fromARGB(255, 255, 241, 253);
  static const Color lightSurface = Color.fromARGB(255, 255, 255, 255);
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightDivider = Color(0xFFE0E0E0);

  // Dark Theme
  static const Color darkBackground = Color.fromARGB(255, 0, 0, 0);
  static const Color darkSurface = Color.fromARGB(255, 28, 0, 28);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);
  static const Color darkDivider = Color(0xFF2C2C2C);
  static const Color red = Color.fromARGB(255, 252, 2, 2);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Theme-aware getters
  static Color get backgroundColor => Get.isDarkMode ? darkBackground : lightBackground;
  static Color get surfaceColor => Get.isDarkMode ? darkSurface : lightSurface;
  static Color get textPrimary => Get.isDarkMode ? darkTextPrimary : lightTextPrimary;
  static Color get textSecondary => Get.isDarkMode ? darkTextSecondary : lightTextSecondary;
  static Color get dividerColor => Get.isDarkMode ? darkDivider : lightDivider;

  static List<Color> get headerGradientColors =>
      Get.isDarkMode
          ? [AppColors.primaryColor, AppColors.accentColor]
          : [AppColors.primaryColor, AppColors.accentColor];
}
