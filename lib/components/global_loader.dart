import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalLoader {
  static void show() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  'loading_text'.tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hide() {
    Get.back(); // 👈 this is causing the crash
  }
}
