// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/modules/register/controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeSection(context),
                      SizedBox(height: 32.h),
                      _buildAnimatedTextField(
                        controller: controller.fullNameController,
                        label: 'full_name'.tr,
                        icon: Icons.person_outline_rounded,
                        validator: (value) => value!.isEmpty ? 'enter_your_name'.tr : null,
                      ),
                      SizedBox(height: 20.h),
                      _buildAnimatedTextField(
                        controller: controller.emailController,
                        label: 'email'.tr,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) return 'enter_your_email'.tr;
                          if (!GetUtils.isEmail(value)) return 'enter_a_valid_email'.tr;
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      _buildAnimatedTextField(
                        controller: controller.phoneController,
                        label: 'phone'.tr,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) return 'enter_your_phone_number'.tr;
                          if (!GetUtils.isPhoneNumber(value)) return 'enter_a_valid_phone_number'.tr;
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      _buildAnimatedTextField(
                        controller: controller.passwordController,
                        label: 'password'.tr,
                        icon: Icons.lock_outline_rounded,
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) return 'enter_a_password'.tr;
                          if (value.length < 6) return 'password_must_be_at_least_6_characters'.tr;
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      _buildEnhancedDropdownField(context, controller),
                      SizedBox(height: 20.h),
                      _buildAnimatedTextField(
                        controller: controller.referralPersonIdController,
                        label: 'referral_person_id'.tr,
                        icon: Icons.people_outline_rounded,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 40.h),
                      Obx(
                        () =>
                            controller.isLoading.value
                                ? _buildLoadingButton(context)
                                : _buildEnhancedRegisterButton(context, controller),
                      ),
                      SizedBox(height: 24.h),
                      _buildFooterText(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.headerGradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -50.h,
                right: -50.w,
                child: Container(
                  width: 150.w,
                  height: 150.h,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
                ),
              ),
              Positioned(
                top: 100.h,
                left: -30.w,
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2.w),
                      ),
                      child: Icon(Icons.person_add_rounded, size: 40.sp, color: AppColors.white),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'create_account'.tr,
                      style: AppTextStyles.headlineMedium().copyWith(
                        color: AppColors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6.w,
              height: 32.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'join_us_today'.tr,
                  style: AppTextStyles.headlineLarge().copyWith(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'fill_in_your_details_to_get_started'.tr,
                  style: AppTextStyles.body().copyWith(fontSize: 14.sp, color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final theme = Get.theme;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : colorScheme.primary.withOpacity(0.05),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyles.body().copyWith(
          fontSize: 16.sp,
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.caption().copyWith(fontSize: 14.sp, color: colorScheme.onSurfaceVariant),
          prefixIcon: Container(
            margin: EdgeInsets.only(left: 16.w, right: 12.w),
            child: Icon(icon, size: 24.sp, color: colorScheme.primary),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 52.w),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: colorScheme.primary, width: 2.w),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: colorScheme.error, width: 2.w),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          filled: true,
          fillColor: Colors.transparent,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildEnhancedDropdownField(BuildContext context, RegisterController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Use a list of non-localized keys for the values.
    final List<String> languageKeys = ['English', 'Hindi'];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : colorScheme.primary.withOpacity(0.05),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
            spreadRadius: 0,
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        // The 'value' must be a non-localized string that exists in the 'items' list.
        value: controller.languagePreference.value,
        decoration: InputDecoration(
          labelText: 'language_preference'.tr,
          labelStyle: AppTextStyles.caption().copyWith(fontSize: 14.sp, color: colorScheme.onSurfaceVariant),
          prefixIcon: Container(
            margin: EdgeInsets.only(left: 16.w, right: 12.w),
            child: Icon(Icons.language_outlined, size: 24.sp, color: colorScheme.primary),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 52.w),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: colorScheme.primary, width: 2.w),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          filled: true,
          fillColor: Colors.transparent,
        ),
        style: AppTextStyles.body().copyWith(
          fontSize: 16.sp,
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        dropdownColor: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        // Map over the non-localized keys.
        items:
            languageKeys.map((String languageKey) {
              return DropdownMenuItem<String>(
                // The value of the item is the non-localized key.
                value: languageKey,
                // The child displays the localized text for the key.
                child: Text(
                  languageKey.tr,
                  style: AppTextStyles.body().copyWith(fontSize: 16.sp, color: colorScheme.onSurface),
                ),
              );
            }).toList(),
        onChanged: (value) => controller.languagePreference.value = value!,
      ),
    );
  }

  Widget _buildEnhancedRegisterButton(BuildContext context, RegisterController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.register,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'create_account'.tr,
                  style: AppTextStyles.body().copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(Icons.arrow_forward_rounded, color: AppColors.white, size: 20.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary.withOpacity(0.7), colorScheme.secondary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              'creating_account'.tr,
              style: AppTextStyles.body().copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterText(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'agreement_prefix'.tr,
          style: AppTextStyles.caption().copyWith(fontSize: 12.sp, color: colorScheme.onSurfaceVariant),
          children: [
            TextSpan(
              text: 'terms_of_service'.tr,
              style: AppTextStyles.caption().copyWith(
                fontSize: 12.sp,
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: 'and'.tr,
              style: AppTextStyles.caption().copyWith(fontSize: 12.sp, color: colorScheme.onSurfaceVariant),
            ),
            TextSpan(
              text: 'privacy_policy'.tr,
              style: AppTextStyles.caption().copyWith(
                fontSize: 12.sp,
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
