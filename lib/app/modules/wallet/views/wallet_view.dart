// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/data/model/wallet/wallet_model.dart';
import 'package:uttham_gyaan/components/app_drawer.dart';

import '../controllers/wallet_controller.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder(
      autoRemove: false,
      init: WalletController(),
      builder: (controller) {
        return Scaffold(
          drawer: AppDrawer(),
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: _buildAppBar(context),
          body: Obx(() {
            final dashboardData = controller.walletModel.value?.data;
            return controller.walletModel.value == null
                ? _buildLoadingState()
                : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreeting(context, dashboardData?.fullName ?? ""),
                      SizedBox(height: 24.h),
                      _buildBalanceCard(context, dashboardData),
                      SizedBox(height: 24.h),
                      _buildQuickStats(context, dashboardData),
                      SizedBox(height: 24.h),
                      _buildReferralSection(context, dashboardData),
                    ],
                  ),
                );
          }),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        strokeWidth: 3,
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
      title: Text('my_wallet'.tr, style: AppTextStyles.headlineMedium().copyWith(color: AppColors.white)),
    );
  }

  Widget _buildGreeting(BuildContext context, String name) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 600),
      child: Text(
        "${'hello'.tr} $name",
        style: AppTextStyles.headlineMedium().copyWith(fontSize: 24.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, WalletData? data) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.accentColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(color: AppColors.sucessPrimary.withOpacity(0.3), blurRadius: 20.r, offset: Offset(0, 8.h)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total_balance'.tr,
                style: AppTextStyles.body().copyWith(color: Colors.white.withOpacity(0.9), fontSize: 16.sp),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(Icons.account_balance_wallet, color: Colors.white, size: 20.sp),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '₹${(data?.totalCommissionEarned ?? 0.0).toStringAsFixed(2)}',
            style: AppTextStyles.headlineMedium().copyWith(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'available_commission'.tr,
            style: AppTextStyles.caption().copyWith(color: Colors.white.withOpacity(0.8), fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, WalletData? data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'overView'.tr,
          style: AppTextStyles.headlineMedium().copyWith(fontSize: 20.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 16.h),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 1.2,
          children: [
            _buildEnhancedMetricCard(
              context,
              'total_spent'.tr,
              '₹${data?.totalSpent?.toStringAsFixed(2)}',
              Icons.credit_card,
              Colors.blue,
            ),
            _buildEnhancedMetricCard(
              context,
              'total_payments'.tr,
              data?.totalPayments.toString() ?? "0",
              Icons.payment,
              Colors.orange,
            ),
            _buildEnhancedMetricCard(
              context,
              'courses_enrolled'.tr,
              data?.coursesEnrolled?.toString() ?? "0",
              Icons.school,
              Colors.purple,
            ),
            _buildEnhancedMetricCard(
              context,
              'pending_commission'.tr,
              '₹${data?.totalCommissionEarned?.toStringAsFixed(2)}',
              Icons.hourglass_empty,
              AppColors.sucessPrimary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnhancedMetricCard(BuildContext context, String title, String value, IconData icon, Color accentColor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: accentColor.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.06),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: accentColor, size: 20.sp),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.headlineMedium().copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                title,
                style: AppTextStyles.caption().copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReferralSection(BuildContext context, WalletData? data) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'referral_program'.tr,
          style: AppTextStyles.headlineMedium().copyWith(fontSize: 20.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 16.h),
        AnimatedContainer(
          duration: Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: colorScheme.outline.withOpacity(0.1), width: 1),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.06),
                blurRadius: 15.r,
                offset: Offset(0, 5.h),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.people, color: Colors.white, size: 24.sp),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'referral_stats'.tr,
                    style: AppTextStyles.headlineMedium().copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildReferralStatCard(
                    context,
                    'total_referrals'.tr,
                    data?.totalReferrals?.toString() ?? "0",
                    Icons.person_add,
                    Colors.blue,
                  ),
                  Container(width: 1, height: 60.h, color: colorScheme.outline.withOpacity(0.2)),
                  _buildReferralStatCard(
                    context,
                    'converted'.tr,
                    data?.convertedReferrals.toString() ?? "0",
                    Icons.done_all,
                    Colors.green,
                  ),
                  Container(width: 1, height: 60.h, color: colorScheme.outline.withOpacity(0.2)),
                  _buildReferralStatCard(
                    context,
                    'commission_earned'.tr,
                    '₹${data?.totalCommissionEarned?.toStringAsFixed(2)}',
                    Icons.monetization_on,
                    AppColors.sucessPrimary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReferralStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10.r)),
          child: Icon(icon, color: color, size: 20.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: AppTextStyles.headlineMedium().copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          style: AppTextStyles.caption().copyWith(fontSize: 11.sp, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
