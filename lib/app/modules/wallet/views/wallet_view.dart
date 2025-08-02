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

    // final dashboardData = {
    //   "FullName": "Ravi Kumar",
    //   "TotalPayments": 19,
    //   "TotalSpent": 4600.00,
    //   "CoursesEnrolled": 6,
    //   "TotalReferrals": 0,
    //   "ConvertedReferrals": 0,
    //   "TotalCommissionEarned": 0.00,
    //   "PendingCommission": 1400.00,
    //   "RejectedCommission": 0.00,
    // };

    return GetBuilder(
      init: WalletController(),
      builder: (controller) {
        return Scaffold(
          drawer: AppDrawer(),
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: _buildAppBar(context),
          body: Obx(() {
            final dashboardData = controller.walletModel.value?.data;
            return controller.walletModel.value == null
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreeting(context, dashboardData?.fullName ?? ""),
                      SizedBox(height: 24.h),
                      _buildMetricsGrid(context, dashboardData),
                      SizedBox(height: 24.h),
                      _buildReferralCard(context, dashboardData),
                    ],
                  ),
                );
          }),
        );
      },
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
    return Text('hello'.trParams({'name': name}), style: AppTextStyles.headlineMedium());
  }

  Widget _buildMetricsGrid(BuildContext context, WalletData? data) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard(context, 'total_spent'.tr, '₹${data?.totalSpent?.toStringAsFixed(2)}'),
        _buildMetricCard(
          context,
          'pending_commission'.tr,
          '₹${data?.totalCommissionEarned?.toStringAsFixed(2)}',
          AppColors.sucessPrimary,
        ),
        _buildMetricCard(context, 'total_payments'.tr, data?.totalPayments.toString() ?? ""),
        _buildMetricCard(context, 'courses_enrolled'.tr, data?.coursesEnrolled?.toString() ?? ""),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, [Color? accentColor]) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: AppTextStyles.body().copyWith(color: AppTextStyles.caption().color)),
          SizedBox(height: 8.h),
          Text(value, style: AppTextStyles.headlineMedium().copyWith(color: accentColor ?? colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildReferralCard(BuildContext context, WalletData? data) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('referral_stats'.tr, style: AppTextStyles.headlineMedium()),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildReferralStat(context, 'total_referrals'.tr, data?.totalReferrals?.toString() ?? ""),
              _buildReferralStat(context, 'converted'.tr, data?.convertedReferrals.toString() ?? ""),
              _buildReferralStat(
                context,
                'commission_earned'.tr,
                '₹${data?.totalCommissionEarned?.toStringAsFixed(2)}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReferralStat(BuildContext context, String title, String value) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headlineMedium().copyWith(fontSize: 28.sp)),
        SizedBox(height: 4.h),
        Text(title, style: AppTextStyles.body().copyWith(color: AppTextStyles.caption().color)),
      ],
    );
  }
}
