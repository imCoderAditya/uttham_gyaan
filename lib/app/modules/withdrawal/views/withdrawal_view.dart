// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/data/model/withdrawal/withdrawal_transaction_model.dart';
import '../controllers/withdrawal_controller.dart';

class WithdrawalView extends GetView<WithdrawalController> {
  const WithdrawalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawalController>(
      init: WithdrawalController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: _buildAppBar(),
          body: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingState();
            }

            final withdrawalData =
                controller.withdrawalTransactionModel.value?.data;

            if (withdrawalData == null || withdrawalData.isEmpty) {
              return _buildEmptyState();
            }

            return _buildTransactionsList(withdrawalData);
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
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'withdrawal_history'.tr,
        style: AppTextStyles.headlineMedium().copyWith(color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.wallet, color: Colors.white, size: 24.sp),
          onPressed: () {
            controller.ammountController.clear();
            controller.commentsController.clear();
            showWithdrawalDialog();
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryColor,
            strokeWidth: 3,
          ),
          SizedBox(height: 16.h),
          Text('loading_transactions'.tr, style: AppTextStyles.subtitle()),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor.withOpacity(0.1),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 64.sp,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 24.h),
          Text('no_withdrawals_yet'.tr, style: AppTextStyles.headlineMedium()),
          SizedBox(height: 8.h),
          Text(
            'withdrawal_history_description'.tr,
            style: AppTextStyles.body().copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          ElevatedButton(
            onPressed: () => controller.fetchWithdrawal(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text('refresh'.tr, style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(List<WithdrawalTransaction> transactions) {
    return RefreshIndicator(
      onRefresh: () async => controller.fetchWithdrawal(),
      color: AppColors.primaryColor,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildSummaryCard(transactions)),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildTransactionCard(transactions[index]),
                childCount: transactions.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(List<WithdrawalTransaction> transactions) {
    double totalAmount = transactions.fold(
      0.0,
      (sum, item) => sum + (item.amount ?? 0),
    );
    int completedCount =
        transactions
            .where((t) => t.status?.toLowerCase() == 'completed')
            .length;
    int pendingCount =
        transactions.where((t) => t.status?.toLowerCase() == 'pending').length;

    return Container(
      margin: EdgeInsets.all(16.w),
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
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total_withdrawn'.tr,
                style: AppTextStyles.subtitle().copyWith(color: Colors.white70),
              ),
              Icon(Icons.trending_down, color: Colors.white70, size: 24.sp),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '\u{20B9}${totalAmount.toStringAsFixed(2)}',
            style: AppTextStyles.headlineLarge().copyWith(
              color: Colors.white,
              fontSize: 28.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'completed'.tr,
                  '$completedCount',
                  Icons.check_circle,
                  AppColors.sucessPrimary,
                ),
              ),
              Container(width: 1, height: 30.h, color: Colors.white24),
              Expanded(
                child: _buildStatItem(
                  'pending'.tr,
                  '$pendingCount',
                  Icons.schedule,
                  AppColors.secondaryPrimary,
                ),
              ),
              Container(width: 1, height: 30.h, color: Colors.white24),
              Expanded(
                child: _buildStatItem(
                  'total'.tr,
                  '${transactions.length}',
                  Icons.receipt,
                  Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTextStyles.headlineMedium().copyWith(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption().copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(WithdrawalTransaction transaction) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.dividerColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTransactionDetails(transaction),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildTransactionIcon(transaction),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                transaction.transactionType ?? 'withdrawal'.tr,
                                style: AppTextStyles.headlineMedium().copyWith(
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                '\u{20B9}${(transaction.amount ?? 0).toStringAsFixed(2)}',
                                style: AppTextStyles.headlineMedium().copyWith(
                                  fontSize: 16.sp,
                                  color: AppColors.red,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            transaction.description ?? 'no_description'.tr,
                            style: AppTextStyles.caption(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(transaction.createdAt),
                      style: AppTextStyles.small(),
                    ),
                    _buildStatusChip(transaction.status),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionIcon(WithdrawalTransaction transaction) {
    Color iconColor;
    IconData iconData;

    switch (transaction.status?.toLowerCase()) {
      case 'completed':
        iconColor = AppColors.sucessPrimary;
        iconData = Icons.check_circle;
        break;
      case 'pending':
        iconColor = AppColors.secondaryPrimary;
        iconData = Icons.schedule;
        break;
      case 'failed':
        iconColor = AppColors.red;
        iconData = Icons.error;
        break;
      default:
        iconColor = AppColors.textSecondary;
        iconData = Icons.account_balance_wallet;
    }

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(iconData, color: iconColor, size: 24.sp),
    );
  }

  Widget _buildStatusChip(String? status) {
    Color backgroundColor;
    Color textColor;
    String statusKey = status?.toLowerCase() ?? 'unknown';

    // Map status to translation key
    String displayStatus = statusKey.tr;

    switch (statusKey) {
      case 'completed':
        backgroundColor = AppColors.sucessPrimary.withOpacity(0.1);
        textColor = AppColors.sucessPrimary;
        break;
      case 'pending':
        backgroundColor = AppColors.secondaryPrimary.withOpacity(0.1);
        textColor = AppColors.secondaryPrimary;
        break;
      case 'failed':
        backgroundColor = AppColors.red.withOpacity(0.1);
        textColor = AppColors.red;
        break;
      default:
        backgroundColor = AppColors.textSecondary.withOpacity(0.1);
        textColor = AppColors.textSecondary;
        displayStatus = ''.tr;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        displayStatus.toUpperCase(),
        style: AppTextStyles.small().copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return ''.tr;

    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  void _showTransactionDetails(WithdrawalTransaction transaction) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.dividerColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'transaction_details'.tr,
              style: AppTextStyles.headlineMedium(),
            ),
            SizedBox(height: 20.h),
            _buildDetailRow(
              'amount'.tr,
              '\u{20B9}${(transaction.amount ?? 0).toStringAsFixed(2)}',
            ),
            _buildDetailRow('type'.tr, transaction.transactionType ?? 'N/A'),
            _buildDetailRow(
              'status'.tr,
              (transaction.status?.toLowerCase() ?? 'unknown').tr,
            ),
            _buildDetailRow('date'.tr, _formatDate(transaction.createdAt)),
            _buildDetailRow(
              'wallet_id'.tr,
              transaction.walletId?.toString() ?? 'N/A',
            ),
            _buildDetailRow(
              'user_id'.tr,
              transaction.userId?.toString() ?? 'N/A',
            ),
            if (transaction.description?.isNotEmpty == true)
              _buildDetailRow('description'.tr, transaction.description!),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              '$label:',
              style: AppTextStyles.body().copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTextStyles.body())),
        ],
      ),
    );
  }

  void showWithdrawalDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.dividerColor.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon at the top
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.wallet_travel,
                  size: 40.sp,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 20.h),
              // Title and subtitle
              Text(
                'withdrawal_request'.tr,
                style: AppTextStyles.headlineMedium().copyWith(fontSize: 20.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'enter_amount_to_withdraw'.tr,
                style: AppTextStyles.body().copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              // Amount input field
              TextField(
                controller: controller.ammountController,
                keyboardType: TextInputType.number,
                style: AppTextStyles.headlineLarge().copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: AppTextStyles.headlineLarge().copyWith(
                    color: AppColors.dividerColor,
                    fontWeight: FontWeight.bold,
                  ),
                  prefixText: '\u{20B9}',
                  prefixStyle: AppTextStyles.headlineLarge().copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 16.w,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              TextField(
                controller: controller.commentsController,
                keyboardType: TextInputType.text,
                style: AppTextStyles.subtitle().copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'comment'.tr,
                  hintStyle: AppTextStyles.headlineLarge().copyWith(
                    color: AppColors.dividerColor,
                    fontWeight: FontWeight.bold,
                  ),

                  prefixStyle: AppTextStyles.headlineLarge().copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 16.w,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h), // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dividerColor,
                        foregroundColor: AppColors.textSecondary,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'cancel'.tr,
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                     controller.validateAndSubmit();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text('withdraw'.tr, style: AppTextStyles.button),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
