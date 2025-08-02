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
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, 'register'.tr),
                SizedBox(height: 16.h),
                _buildTextField(
                  controller: controller.fullNameController,
                  label: 'Full Name'.tr,
                  validator: (value) => value!.isEmpty ? 'Enter your name'.tr : null,
                ),
                SizedBox(height: 12.h),
                _buildTextField(
                  controller: controller.emailController,
                  label: 'Email'.tr,
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter your email'.tr;
                    if (!GetUtils.isEmail(value)) return 'Enter a valid email'.tr;
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                _buildTextField(
                  controller: controller.phoneController,
                  label: 'Phone'.tr,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter your phone number'.tr;
                    if (!GetUtils.isPhoneNumber(value)) return 'Enter a valid phone number'.tr;
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                _buildTextField(
                  controller: controller.passwordController,
                  label: 'Password'.tr,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter a password'.tr;
                    if (value.length < 6) return 'Password must be at least 6 characters'.tr;
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                _buildDropdownField(context, controller),
                SizedBox(height: 12.h),
                _buildTextField(
                  controller: controller.referralPersonIdController,
                  label: 'Referral Person ID'.tr,
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter referral ID'.tr : null,
                ),
                SizedBox(height: 24.h),
                Obx(() => controller.isLoading.value
                    ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
                    : _buildRegisterButton(context, controller)),
              ],
            ),
          ),
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
      title: Text(
        'Register'.tr,
        style: AppTextStyles.headlineMedium().copyWith(
          color: AppColors.white,
          fontSize: 20.sp,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: AppTextStyles.headlineLarge().copyWith(
              fontSize: 22.sp,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
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
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyles.body().copyWith(
          fontSize: 14.sp,
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.caption().copyWith(
            fontSize: 12.sp,
            color: colorScheme.onSurfaceVariant,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          filled: true,
          fillColor: Colors.transparent,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context, RegisterController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: controller.languagePreference.value,
        decoration: InputDecoration(
          labelText: 'Language Preference'.tr,
          labelStyle: AppTextStyles.caption().copyWith(
            fontSize: 12.sp,
            color: colorScheme.onSurfaceVariant,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          filled: true,
          fillColor: Colors.transparent,
        ),
        style: AppTextStyles.body().copyWith(
          fontSize: 14.sp,
          color: colorScheme.onSurface,
        ),
        items: ['English', 'Hindi', 'Spanish'].map((String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Text(language),
          );
        }).toList(),
        onChanged: (value) => controller.languagePreference.value = value!,
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, RegisterController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: controller.register,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'Register'.tr,
          style: AppTextStyles.body().copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

