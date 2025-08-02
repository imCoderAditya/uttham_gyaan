import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/theme/app_colors.dart'; // Adjust path if needed
import '../controllers/nav_controller.dart';

class NavView extends GetView<NavController> {
  const NavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final index = controller.currentIndex.value;
        return controller.page[index];
      }),
      bottomNavigationBar: Obx(
        () => CurvedNavigationBar(
          index: controller.currentIndex.value,
          height: 60,

          backgroundColor: Colors.transparent,
          color: AppColors.primaryColor,
          buttonBackgroundColor: AppColors.accentColor,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          items: <Widget>[
            Icon(Icons.home, size: 30, color: AppColors.white),
            Icon(Icons.school, size: 30, color: AppColors.white),
            Icon(Icons.wallet_rounded, size: 30, color: AppColors.white),
            Icon(Icons.person, size: 30, color: AppColors.white),
          ],
          onTap: (index) {
            controller.changeTab(index);
          },
        ),
      ),
    );
  }
}
