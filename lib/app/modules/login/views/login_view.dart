// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/modules/login/controllers/login_controller.dart';
import 'package:uttham_gyaan/components/Snack_bar_view.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    _buildWelcomeSection(context),
                    SizedBox(height: 32.h),
                    _buildInputSection(context),
                    SizedBox(height: 32.h),
                    _buildLoginButton(context),
                    SizedBox(height: 24.h),
                    _buildRegisterLink(context),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isDark
                  ? [colorScheme.primary.withOpacity(0.8), colorScheme.secondary.withOpacity(0.6)]
                  : [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32.r), bottomRight: Radius.circular(32.r)),
        boxShadow: [BoxShadow(color: colorScheme.primary.withOpacity(0.3), blurRadius: 20.r, offset: Offset(0, 10.h))],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50.h,
            right: -50.w,
            child: Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
            ),
          ),
          Positioned(
            top: 50.h,
            left: -30.w,
            child: Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08)),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 2.w),
                  ),
                  child: Icon(Icons.school_outlined, size: 30.sp, color: Colors.white),
                ),
                SizedBox(height: 16.h),
                Text(
                  'app_name'.tr, // 'Uttham Gyaan'
                  style: AppTextStyles.headlineLarge().copyWith(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'welcome_back'.tr, // 'Welcome Back'
                  style: AppTextStyles.body().copyWith(color: Colors.white.withOpacity(0.9), fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'sign_in'.tr, // 'Sign In'
          style: AppTextStyles.headlineLarge().copyWith(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'sign_in_to_continue'.tr, // 'Please sign in to continue learning'
          style: AppTextStyles.body().copyWith(fontSize: 16.sp, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildInputSection(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          controller: controller.identifierController,
          label: 'identifier'.tr,
          maxLength: 10,
          counter: SizedBox(),
          hintText: 'enter_identifier'.tr,
          prefixIcon: Icons.person_outline,
          keyboardType: TextInputType.number,
          validator: (value) => value!.isEmpty ? 'enter_identifier'.tr : null,
        ),
        SizedBox(height: 20.h),
        Obx(
          () => _buildTextField(
            controller: controller.passwordController,
            label: 'password'.tr,
            hintText: 'enter_password'.tr,
            prefixIcon: Icons.lock_outline,
            obscureText: !controller.isPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
            validator: (value) {
              if (value!.isEmpty) return 'enter_password'.tr;
              if (value.length < 6) return 'password_min_length'.tr;
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    Widget? counter,
    int? maxLength,

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
            color: isDark ? Colors.black.withOpacity(0.2) : colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        maxLength: maxLength,

        keyboardType: keyboardType,
        style: AppTextStyles.body().copyWith(fontSize: 16.sp, color: colorScheme.onSurface),
        decoration: InputDecoration(
          counter: counter,
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(prefixIcon, color: colorScheme.onSurfaceVariant, size: 22.sp),
          suffixIcon: suffixIcon,
          labelStyle: AppTextStyles.body().copyWith(fontSize: 14.sp, color: colorScheme.onSurfaceVariant),
          hintStyle: AppTextStyles.body().copyWith(
            fontSize: 14.sp,
            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: colorScheme.primary, width: 2.w),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: colorScheme.error, width: 1.w),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          filled: true,
          fillColor: Colors.transparent,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                controller.isLoading.value
                    ? [colorScheme.primary.withOpacity(0.7), colorScheme.secondary.withOpacity(0.7)]
                    : [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow:
              controller.isLoading.value
                  ? []
                  : [BoxShadow(color: colorScheme.primary.withOpacity(0.4), blurRadius: 15.r, offset: Offset(0, 8.h))],
        ),
        child: ElevatedButton(
          onPressed: () {
            if (controller.identifierController.text.isEmpty) {
              SnackBarView.showError(message: "enter_mobile_number".tr);
              return;
            }

            if (controller.identifierController.text.length != 10 ||
                !RegExp(r'^[0-9]+$').hasMatch(controller.identifierController.text)) {
              SnackBarView.showError(message: "invalid_mobile_number".tr);
              return;
            }
            if (controller.passwordController.text.isEmpty) {
              SnackBarView.showError(message: "enter_password".tr);
              return;
            }
            controller.login();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          ),
          child:
              controller.isLoading.value
                  ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : Text(
                    'sign_in'.tr,
                    style: AppTextStyles.body().copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'no_account'.tr, // "Don't have an account?"
            style: AppTextStyles.body().copyWith(fontSize: 14.sp, color: colorScheme.onSurfaceVariant),
          ),
          GestureDetector(
            onTap: () => Get.toNamed('/register'),
            child: Text(
              'sign_up'.tr, // 'Sign Up'
              style: AppTextStyles.body().copyWith(
                fontSize: 14.sp,
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
