// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart'
    show AppTextStyles;

import '../controllers/bank_controller.dart';

class BankView extends GetView<BankController> {
  const BankView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankController>(
      init: BankController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: _buildAppBar(),
          body: Obx(() {
            final bank = controller.bank.value;
            if (bank == null) {
              return _buildEmptyState();
            } else {
              return _buildBankDetails(bank);
            }
          }),
          floatingActionButton: _buildFloatingActionButton(),
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
        'bank_details'.tr,
        style: AppTextStyles.headlineMedium().copyWith(color: Colors.white),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.w),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32.w),
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.1),
              blurRadius: 20.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.headerGradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance,
                size: 48.w,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'no_bank_details'.tr,
              style: AppTextStyles.headlineMedium(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'add_your_bank_details_to_receive_payments'.tr,
              style: AppTextStyles.caption(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
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
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 8.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: controller.openDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: Icon(Icons.add, color: Colors.white, size: 20.w),
                label: Text('add_bank_details'.tr, style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankDetails(dynamic bank) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Bank Card Header
          Container(
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
                    Icon(
                      Icons.account_balance,
                      color: Colors.white,
                      size: 24.w,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      bank.bankName ?? 'bank_name'.tr,
                      style: AppTextStyles.headlineMedium().copyWith(
                        color: Colors.white,
                        fontSize: 20.sp
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  bank.accountHolderName ?? '',
                  style: AppTextStyles.subtitle().copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  _maskAccountNumber(bank.accountNumber ?? ''),
                  style: AppTextStyles.body().copyWith(
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Bank Details Section
          _buildSection(
            title: 'Bank Information',
            icon: Icons.account_balance_outlined,
            children: [
              _buildDetailCard(
                'account_holder_name'.tr,
                bank.accountHolderName ?? '',
                Icons.person_outline,
              ),
              _buildDetailCard(
                'account_number'.tr,
                bank.accountNumber ?? '',
                Icons.numbers_outlined,
                isSensitive: true,
              ),
              _buildDetailCard(
                'ifsc_code'.tr,
                bank.ifscCode ?? '',
                Icons.code_outlined,
              ),
              _buildDetailCard(
                'bank_name'.tr,
                bank.bankName ?? '',
                Icons.business_outlined,
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // UPI & Digital Wallets Section
          _buildSection(
            title: 'UPI & Digital Wallets',
            icon: Icons.payment,
            children: [
              if (bank.upiId?.isNotEmpty == true)
                _buildDetailCard(
                  'upi_id'.tr,
                  bank.upiId ?? '',
                  Icons.qr_code_2_outlined,
                ),
              if (bank.phonePe?.isNotEmpty == true)
                _buildDetailCard(
                  'phone_pe'.tr,
                  bank.phonePe ?? '',
                  Icons.phone_android_outlined,
                ),
              if (bank.googlePay?.isNotEmpty == true)
                _buildDetailCard(
                  'google_pay'.tr,
                  bank.googlePay ?? '',
                  Icons.g_mobiledata_outlined,
                ),
              if (bank.paytm?.isNotEmpty == true)
                _buildDetailCard(
                  'paytm'.tr,
                  bank.paytm ?? '',
                  Icons.wallet_outlined,
                ),
            ],
          ),

          SizedBox(height: 100.h), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryColor, size: 20.w),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: AppTextStyles.subtitle().copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Section Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    String label,
    String value,
    IconData icon, {
    bool isSensitive = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.dividerColor, width: 1.w),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 18.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption()),
                SizedBox(height: 4.h),
                Text(
                  isSensitive ? _maskAccountNumber(value) : value,
                  style: AppTextStyles.body().copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isSensitive)
            IconButton(
              onPressed: () => _showSensitiveData(value),
              icon: Icon(
                Icons.visibility_outlined,
                color: AppColors.textSecondary,
                size: 20.w,
              ),
            ),
          IconButton(
            onPressed: () => _copyToClipboard(value),
            icon: Icon(
              Icons.copy_outlined,
              color: AppColors.primaryColor,
              size: 18.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Obx(
      () => Container(
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
              blurRadius: 12.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: controller.openDialog,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(
            controller.bank.value == null ? Icons.add : Icons.edit,
            color: Colors.white,
            size: 24.w,
          ),
        ),
      ),
    );
  }

  String _maskAccountNumber(String accountNumber) {
    if (accountNumber.length <= 4) return accountNumber;
    return '•' * (accountNumber.length - 4) +
        accountNumber.substring(accountNumber.length - 4);
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)); // Copy text to clipboard
    Get.snackbar(
      'Copied',
      'Copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }

  void _showSensitiveData(String data) {
    Get.dialog(
      AlertDialog(
        title: Text('Account Number'),
        content: SelectableText(
          data,
          style: AppTextStyles.body().copyWith(
            letterSpacing: 1.5,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Close')),
        ],
      ),
    );
  }
}
