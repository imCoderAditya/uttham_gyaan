// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/core/config/theme/theme_controller.dart';
import 'package:uttham_gyaan/app/core/contants/constant.dart';
import 'package:uttham_gyaan/app/modules/mycourse/views/mycourse_view.dart';
import 'package:uttham_gyaan/app/modules/profile/controllers/profile_controller.dart';
import 'package:uttham_gyaan/app/routes/app_pages.dart';
import 'package:uttham_gyaan/app/services/storage/local_storage_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      width: 280.w,
      child: Column(
        children: [
          // Drawer Header
          _buildDrawerHeader(context),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.home_rounded,
                  title: 'home'.tr,
                  onTap: () => Get.back(),
                ),
                // _buildMenuItem(context, icon: Icons.school_rounded, title: 'courses'.tr, onTap: () => Get.back()),
                _buildMenuItem(
                  context,
                  icon: Icons.bookmark_rounded,
                  title: 'my_courses'.tr,
                  onTap: () => {Get.back(), Get.to(MycourseView(isMenuDisable: true,))},
                ),
                // _buildMenuItem(context, icon: Icons.download_rounded, title: 'downloads'.tr, onTap: () => Get.back()),
                // _buildMenuItem(context, icon: Icons.favorite_rounded, title: 'favorites'.tr, onTap: () => Get.back()),
                _buildMenuItem(
                  context,
                  icon: Icons.person_rounded,
                  title: 'profile'.tr,
                  onTap: () => {Get.back(), Get.toNamed(Routes.PROFILE)},
                ),

                // Divider
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  height: 1.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.dividerColor.withOpacity(0.1),
                        theme.dividerColor,
                        theme.dividerColor.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),

                // Settings Section
                _buildSectionHeader(context, 'settings'.tr),

                // Theme Toggle
                _buildThemeToggleItem(context),

                // Language Toggle
                _buildLanguageToggleItem(context),

                // _buildMenuItem(
                //   context,
                //   icon: Icons.notifications_rounded,
                //   title: 'notifications'.tr,
                //   onTap: () => Get.back(),
                // ),
                // _buildMenuItem(
                //   context,
                //   icon: Icons.privacy_tip_rounded,
                //   title: 'privacy_policy'.tr,
                //   onTap: () => Get.back(),
                // ),
                // _buildMenuItem(
                //   context,
                //   icon: Icons.help_rounded,
                //   title: 'help_support'.tr,
                //   onTap: () => Get.back(),
                // ),
                // _buildMenuItem(
                //   context,
                //   icon: Icons.info_rounded,
                //   title: 'about'.tr,
                //   onTap: () => Get.back(),
                // ),

                // Divider
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  height: 1.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.dividerColor.withOpacity(0.1),
                        theme.dividerColor,
                        theme.dividerColor.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),

                _buildMenuItem(
                  context,
                  icon: Icons.logout_rounded,
                  title: 'logout'.tr,
                  onTap: () {
                    Get.back();
                    _showLogoutDialog(context);
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),

          // App Version
          _buildAppVersion(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Builder(
      builder: (context) {
        return Container(
          height: 260.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.headerGradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(35.r),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.3),
                        width: 2.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: 40.sp,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // User Name
                  Text(
                    "${'welcome_'.tr} ${controller.profileModel.value?.data?.fullName ?? ""}",
                    style: AppTextStyles.headlineMedium().copyWith(
                      color: AppColors.white,
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // User Email or Status
                  Text(
                    'explore_courses'.tr,
                    style: AppTextStyles.caption().copyWith(
                      color: AppColors.white.withOpacity(0.85),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 16.w, 8.h),
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            title.toUpperCase(),
            style: AppTextStyles.caption().copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        leading: Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color:
                isDestructive
                    ? AppColors.red.withOpacity(0.1)
                    : colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: isDestructive ? AppColors.red : colorScheme.primary,
            size: 22.sp,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.body().copyWith(
            color: isDestructive ? AppColors.red : null,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing:
            trailing ??
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: AppTextStyles.caption().color,
            ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  Widget _buildThemeToggleItem(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: Obx(
        () => ListTile(
          leading: Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              themeController.isDarkMode.value
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              color: colorScheme.primary,
              size: 22.sp,
            ),
          ),
          title: Text(
            themeController.isDarkMode.value ? 'dark_mode'.tr : 'light_mode'.tr,
            style: AppTextStyles.body().copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Transform.scale(
            scale: 0.8,
            child: Switch(
              value: themeController.isDarkMode.value,
              onChanged: (value) => themeController.toggleTheme(),
              activeColor: colorScheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          onTap: () => themeController.toggleTheme(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageToggleItem(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: ExpansionTile(
        leading: Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.language_rounded,
            color: colorScheme.primary,
            size: 22.sp,
          ),
        ),
        title: Text(
          'language'.tr,
          style: AppTextStyles.body().copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          Get.locale?.languageCode == 'hi' ? 'hindi'.tr : 'english'.tr,
          style: AppTextStyles.caption().copyWith(fontSize: 13.sp),
        ),
        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        childrenPadding: EdgeInsets.only(left: 32.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        children: [
          _buildLanguageOption(context, 'English', 'en', 'US'),
          _buildLanguageOption(context, 'हिंदी', 'hi', 'IN'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String title,
    String languageCode,
    String countryCode,
  ) {
    final isSelected = Get.locale?.languageCode == languageCode;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListTile(
        title: Text(
          title,
          style: AppTextStyles.body().copyWith(
            color: isSelected ? colorScheme.primary : null,
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        trailing:
            isSelected
                ? Icon(
                  Icons.check_circle_rounded,
                  color: colorScheme.primary,
                  size: 20.sp,
                )
                : null,
        onTap: () => _changeLanguage(Locale(languageCode, countryCode)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  Widget _buildAppVersion(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16.sp,
            color: AppTextStyles.caption().color,
          ),
          SizedBox(width: 8.w),
          Text(
            '${'version'.tr} 1.0.0',
            style: AppTextStyles.caption().copyWith(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  void _changeLanguage(Locale locale) {
    changeLanguage(locale);
    Get.forceAppUpdate();
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Get.dialog(
      AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'logout'.tr,
          style: AppTextStyles.headlineMedium().copyWith(fontSize: 18.sp),
        ),
        content: Text(
          'logout_confirmation'.tr,
          style: AppTextStyles.body().copyWith(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'cancel'.tr,
              style: AppTextStyles.button.copyWith(
                color: AppTextStyles.caption().color,
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            ),
            child: Text(
              'logout'.tr,
              style: AppTextStyles.button.copyWith(
                color: AppColors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performLogout() async {
    await LocalStorageService.logout();
  }
}
