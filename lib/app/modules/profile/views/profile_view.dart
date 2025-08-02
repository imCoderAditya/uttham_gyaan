// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Placeholder user data. In a real app, this would come from the controller.
    final userData = {
      "fullName": "Ravi Kumar",
      "email": "ravi.kumar@example.com",
      "profileImageUrl": "https://randomuser.me/api/portraits/men/86.jpg",
    };

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [_buildProfileHeader(context, userData), SizedBox(height: 24.h), _buildMenuOptions(context)],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.headerGradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text('profile'.tr, style: AppTextStyles.headlineMedium().copyWith(color: AppColors.white)),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Map<String, dynamic> userData) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.headerGradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundColor: colorScheme.surface,
            backgroundImage: NetworkImage(userData["profileImageUrl"]!),
            child:
                userData["profileImageUrl"] == null
                    ? Icon(Icons.person_outline, size: 50.sp, color: colorScheme.primary)
                    : null,
          ),
          SizedBox(height: 12.h),
          Text(userData["fullName"]!, style: AppTextStyles.headlineLarge().copyWith(color: AppColors.white)),
          SizedBox(height: 4.h),
          Text(userData["email"]!, style: AppTextStyles.body().copyWith(color: AppColors.white.withOpacity(0.8))),
        ],
      ),
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          _buildOptionCard(context, Icons.school_outlined, 'my_courses'.tr, () {
            // Get.toNamed('/my-courses');
          }),
          _buildOptionCard(context, Icons.account_balance_wallet_outlined, 'my_wallet'.tr, () {
            // Get.toNamed('/wallet');
          }),
          _buildOptionCard(context, Icons.settings_outlined, 'account_settings'.tr, () {
            // Get.toNamed('/account-settings');
          }),
          _buildOptionCard(context, Icons.language_outlined, 'language'.tr, () {
            // Show language selection dialog
          }),
          _buildOptionCard(context, Icons.help_outline, 'help_and_support'.tr, () {
            // Open help and support section
          }),
          _buildOptionCard(context, Icons.logout_outlined, 'logout'.tr, () {
            // Show confirmation dialog and log out
          }, isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: isDestructive ? AppColors.red.withOpacity(0.1) : colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 24.sp, color: isDestructive ? AppColors.red : colorScheme.primary),
              SizedBox(width: 20.w),
              Text(
                title,
                style: AppTextStyles.body().copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? AppColors.red : colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, size: 24.sp, color: AppTextStyles.caption().color),
            ],
          ),
        ),
      ),
    );
  }
}
