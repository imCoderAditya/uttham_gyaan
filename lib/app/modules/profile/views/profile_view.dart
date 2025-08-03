// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/data/model/profile/profile_model.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: CustomScrollView(
            slivers: [
              Obx(() => _buildSliverAppBar(context, controller.profileModel.value?.data)),
              Obx(
                () => SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 24.h),
                      _buildProfileInfoCard(context, controller.profileModel.value?.data),
                      SizedBox(height: 32.h),
                      _buildContactInfoCard(context, controller.profileModel.value?.data),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ProfileData? userData) {
    return SliverAppBar(
      expandedHeight: 320.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.accentColor, AppColors.primaryColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Decorative elements
              Positioned(
                top: -80.h,
                right: -80.w,
                child: Container(
                  width: 200.w,
                  height: 200.h,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white.withOpacity(0.08)),
                ),
              ),
              Positioned(
                top: 120.h,
                left: -60.w,
                child: Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white.withOpacity(0.05)),
                ),
              ),
              Positioned(
                bottom: 100.h,
                right: 20.w,
                child: Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white.withOpacity(0.06)),
                ),
              ),
              // Profile content
              Positioned(
                bottom: 60.h,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // Profile avatar with enhanced styling
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppColors.white.withOpacity(0.3), AppColors.white.withOpacity(0.1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.15),
                                blurRadius: 25.r,
                                offset: Offset(0, 12.h),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 65.r,
                            backgroundColor: AppColors.white,
                            child: CircleAvatar(
                              radius: 58.r,
                              backgroundColor: AppColors.lightSurface,
                              child: Icon(Icons.person_outline_rounded, size: 60.sp, color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                        // Enhanced verification badge
                        if (userData?.isVerified == true)
                          Positioned(
                            bottom: 8.h,
                            right: 8.w,
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.sucessPrimary, AppColors.sucessPrimary.withOpacity(0.8)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.white, width: 3.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.sucessPrimary.withOpacity(0.4),
                                    blurRadius: 12.r,
                                    offset: Offset(0, 4.h),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.verified_rounded, size: 20.sp, color: AppColors.white),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // User name with enhanced styling
                    Text(
                      userData?.fullName ?? "loading".tr,
                      style: AppTextStyles.headlineLarge().copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.sp,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(color: AppColors.black.withOpacity(0.4), offset: Offset(0, 3.h), blurRadius: 6.r),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Verification status chip
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color:
                            userData?.isVerified == true
                                ? AppColors.sucessPrimary.withOpacity(0.2)
                                : AppColors.secondaryPrimary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color:
                              userData?.isVerified == true
                                  ? AppColors.sucessPrimary.withOpacity(0.4)
                                  : AppColors.secondaryPrimary.withOpacity(0.4),
                          width: 1.5.w,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            userData?.isVerified == true ? Icons.verified_user_rounded : Icons.pending_outlined,
                            size: 16.sp,
                            color: userData?.isVerified == true ? AppColors.sucessPrimary : AppColors.secondaryPrimary,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            userData?.isVerified == true ? "verified_account".tr : "pending_verification".tr,
                            style: AppTextStyles.caption().copyWith(
                              color:
                                  userData?.isVerified == true ? AppColors.sucessPrimary : AppColors.secondaryPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // App bar when collapsed
      title: Text(
        'profile'.tr,
        style: AppTextStyles.headlineMedium().copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Edit profile action
          },
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.edit_outlined, color: AppColors.white, size: 20.sp),
          ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildProfileInfoCard(BuildContext context, ProfileData? userData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.08), blurRadius: 20.r, offset: Offset(0, 8.h))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryColor, AppColors.accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(Icons.person_rounded, color: AppColors.white, size: 24.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "personal_information".tr,
                      style: AppTextStyles.headlineMedium().copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "your_profile_details".tr,
                      style: AppTextStyles.caption().copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildInfoRow(context, Icons.badge_outlined, "full_name".tr, userData?.fullName ?? "not_provided".tr),
          SizedBox(height: 20.h),
          _buildInfoRow(
            context,
            Icons.verified_user_outlined,
            "account_status".tr,
            userData?.isVerified == true ? "verified".tr : "unverified".tr,
            valueColor: userData?.isVerified == true ? AppColors.sucessPrimary : AppColors.secondaryPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoCard(BuildContext context, ProfileData? userData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.08), blurRadius: 20.r, offset: Offset(0, 8.h))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accentColor, AppColors.red.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(Icons.contact_mail_rounded, color: AppColors.white, size: 24.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "contact_information".tr,
                      style: AppTextStyles.headlineMedium().copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "how_to_reach_you".tr,
                      style: AppTextStyles.caption().copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildInfoRow(context, Icons.email_outlined, "email_address".tr, userData?.email ?? "not_provided".tr),
          SizedBox(height: 20.h),
          _buildInfoRow(context, Icons.phone_outlined, "mobile_number".tr, userData?.phone ?? "not_provided".tr),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18.sp, color: AppColors.primaryColor),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption().copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: AppTextStyles.body().copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
