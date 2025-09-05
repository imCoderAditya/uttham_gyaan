// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/core/utils/date_utils.dart';
import 'package:uttham_gyaan/app/data/model/commissions/commissions_model.dart';
import '../controllers/bank_controller.dart';

class CommissionsScreen extends GetView<BankController> {
  const CommissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankController>(
      init: BankController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: _buildAppBar(),
          body: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingState();
            }

            if (controller.error.isNotEmpty) {
              return _buildErrorState(controller);
            }

            final commissions = controller.filteredCommissions;
            return _buildCommissionsContent(controller, commissions);
          }),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
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
        'your_commissions'.tr,
        style: AppTextStyles.headlineMedium().copyWith(color: Colors.white),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.w),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 8.w),
          child: IconButton(
            icon: Icon(Icons.refresh, color: Colors.white, size: 24.w),
            onPressed: controller.fetchCommissions,
            tooltip: 'refresh'.tr,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  blurRadius: 20.r,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
              strokeWidth: 3.w,
            ),
          ),
          SizedBox(height: 24.h),
          Text('loading_commissions'.tr, style: AppTextStyles.subtitle()),
        ],
      ),
    );
  }

  Widget _buildErrorState(BankController controller) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.red.withOpacity(0.1),
              blurRadius: 20.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: AppColors.red,
                size: 48.w,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "oops_something_wrong".tr,
              style: AppTextStyles.headlineMedium(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              controller.error.value,
              style: AppTextStyles.caption().copyWith(color: AppColors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Container(
              width: double.infinity,
              height: 48.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.headerGradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ElevatedButton(
                onPressed: controller.fetchCommissions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text('retry'.tr, style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommissionsContent(BankController controller, List commissions) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Earnings Card
          _buildTotalEarningsCard(controller),
          SizedBox(height: 24.h),

          // Filter and Sort Section
          _buildFiltersSection(controller),
          SizedBox(height: 24.h),

          // Commissions List Header
          Row(
            children: [
              Icon(Icons.list_alt, color: AppColors.primaryColor, size: 20.w),
              SizedBox(width: 8.w),
              Text(
                'commission_history'.tr,
                style: AppTextStyles.subtitle().copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Commissions Cards
          commissions.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context,index){
                return  _buildCommissionCard(commissions[index]);
              }, separatorBuilder:(context,index) =>SizedBox(), itemCount: commissions.length)
              
        ],
      ),
    );
  }

  Widget _buildTotalEarningsCard(BankController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.headerGradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 15.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "total_earnings".tr,
                style: AppTextStyles.subtitle().copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            '\u20B9${controller.commissionResponse.value.totalSuccessAmount.toStringAsFixed(2)}',
            style: AppTextStyles.headlineLarge().copyWith(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Colors.white.withOpacity(0.8),
                size: 16.w,
              ),
              SizedBox(width: 4.w),
              Text(
                "from_successful_referrals".tr,
                style: AppTextStyles.caption().copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(BankController controller) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdown(
              value: controller.filterStatus.value,
              items: [
                {'value': 'all', 'label': 'All Statuses'},
                {'value': 'Success', 'label': 'Success'},
              ],
              onChanged: (value) => controller.setFilter(value!),
              hint: "filter_by_status".tr,
              icon: Icons.filter_list,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildDropdown(
              value: controller.sortBy.value,
              items: const [
                {'value': 'none', 'label': 'No Sort'},
                {'value': 'amount', 'label': 'By Amount'},
                {'value': 'date', 'label': 'By Date'},
              ],
              onChanged: (value) => controller.setSort(value!),
              hint: 'sort_by'.tr,
              icon: Icons.sort,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<Map<String, String>> items,
    required Function(String?) onChanged,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.dividerColor),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(icon, color: AppColors.primaryColor, size: 18.w),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item['value'],
                      child: Text(
                        item['label']!,
                        style: AppTextStyles.caption(),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          hint: Text(hint, style: AppTextStyles.caption()),
        ),
      ),
    );
  }

  Widget _buildCommissionCard(Commission commission) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.dividerColor, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.primaryColor,
                      size: 16.w,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        commission.referredUserName.toString().capitalize??"",
                        style: AppTextStyles.body().copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'ID: ${commission.commissionId}',
                        style: AppTextStyles.small().copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color:
                      commission.status == 'Success'
                          ? AppColors.sucessPrimary.withOpacity(0.1)
                          : AppColors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  commission.status,
                  style: AppTextStyles.small().copyWith(
                    color:
                        commission.status == 'Success'
                            ? AppColors.sucessPrimary
                            : AppColors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Amount and Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.moving_rounded,
                    color: AppColors.secondaryPrimary,
                    size: 18.w,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '\u20B9${commission.amount.toStringAsFixed(2)}',
                    style: AppTextStyles.subtitle().copyWith(
                      color: AppColors.secondaryPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.textSecondary,
                    size: 14.w,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                  AppDateUtils.extractDate(commission.generatedDate, 4),
                    style: AppTextStyles.small().copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.dividerColor,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 48.w,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text("no_commissions_yet".tr, style: AppTextStyles.headlineMedium()),
          SizedBox(height: 8.h),
          Text(
            "start_referring".tr,
            style: AppTextStyles.caption(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
