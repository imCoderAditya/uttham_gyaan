// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';

class SnackBarView {
  static OverlayEntry? _currentEntry;

  static void _showOverlay(OverlayEntry entry, Duration duration) {
    // Close existing one if open
    _currentEntry?.remove();
    _currentEntry = entry;

    final overlay = Overlay.of(Get.overlayContext ?? Get.context!);
    overlay.insert(_currentEntry!);

    Future.delayed(duration, () {
      _currentEntry?.remove();
      _currentEntry = null;
    });
  }

  static void dismiss() {
    _currentEntry?.remove();
    _currentEntry = null;
  }

  static void showError({
    required String message,
    Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    IconData icon = Icons.error_outline,
    VoidCallback? onActionPressed,
  }) {
    final entry = _buildOverlayEntry(
      message: message,
      icon: icon,
      colors: [Color(0xFFDE033F), Color(0xFFDE033F).withOpacity(0.8)],
      shadowColor: Color(0xFFDE033F),
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
    _showOverlay(entry, duration);
  }

  static void showSuccess({
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    IconData icon = Icons.check_circle_outline,
    VoidCallback? onActionPressed,
  }) {
    final entry = _buildOverlayEntry(
      message: message,
      icon: icon,
      colors: [Color(0xFF4CAF50), Color(0xFF2E7D32).withOpacity(0.9)],
      shadowColor: Color(0xFF4CAF50),
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
    _showOverlay(entry, duration);
  }

  static void showWarning({
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    IconData icon = Icons.warning_amber_outlined,
    VoidCallback? onActionPressed,
  }) {
    final entry = _buildOverlayEntry(
      message: message,
      icon: icon,
      colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
      shadowColor: Color(0xFFFF9800),
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
    _showOverlay(entry, duration);
  }

  static void showInfo({
    required String message,
    Duration duration = const Duration(seconds: 3),
    IconData icon = Icons.info_outline,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final entry = _buildOverlayEntry(
      message: message,
      icon: icon,
      colors: [Color(0xFF001737), Color(0xFF001737).withOpacity(0.8)],
      shadowColor: Color(0xFF001737),
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      bottom: 80,
    );
    _showOverlay(entry, duration);
  }

  static void showCustom({
    required String message,
    required List<Color> colors,
    Color? shadowColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final entry = _buildOverlayEntry(
      message: message,
      icon: icon,
      colors: colors,
      shadowColor: shadowColor ?? colors.first,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
    _showOverlay(entry, duration);
  }

  static OverlayEntry _buildOverlayEntry({
    required String message,
    required List<Color> colors,
    required Color shadowColor,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
    double bottom = 40,
  }) {
    return OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: bottom,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: shadowColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    if (icon != null)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                        child: Icon(icon, color: Colors.white, size: 20),
                      ),
                    if (icon != null) const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (actionLabel != null)
                      GestureDetector(
                        onTap: onActionPressed ?? () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            actionLabel,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
