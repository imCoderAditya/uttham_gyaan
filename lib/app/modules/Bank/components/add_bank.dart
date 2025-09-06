// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/core/utils/validator_utils.dart';
import '../controllers/bank_controller.dart';

class AddBankView extends GetView<BankController> {
  const AddBankView({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16.w),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: 0.85.sh),
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
            // Header with gradient
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.headerGradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.account_balance,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      controller.accountHolderName.value.isEmpty
                          ? 'add_bank_details'.tr
                          : 'edit_bank_details'.tr,
                      style: AppTextStyles.headlineMedium().copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: Colors.white, size: 24.w),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      // Primary Bank Details Section
                      _buildSectionHeader(
                        'Primary Bank Details',
                        Icons.account_balance_wallet,
                      ),
                      SizedBox(height: 16.h),

                      _buildTextField(
                        label: 'account_holder_name'.tr,
                        obs: controller.accountHolderName,

                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
                          CapitalizeFirstLetterFormatter(),
                        ],
                        icon: Icons.person_outline,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'required'.tr
                                    : (RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)
                                        ? null
                                        : 'invalid_name'.tr),
                      ),

                      _buildTextField(
                        label: 'account_number'.tr,
                        obs: controller.accountNumber,
                        icon: Icons.numbers_outlined,

                        maxLength: 15,
                        keyboardType: TextInputType.number,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'required'.tr
                                    : (value.length >= 10 &&
                                            value.length <= 20 &&
                                            RegExp(r'^\d+$').hasMatch(value)
                                        ? null
                                        : 'invalid_account_number'.tr),
                      ),

                      _buildTextField(
                        label: 'ifsc_code'.tr,
                        obs: controller.ifscCode,
                        maxLength: 11,
                        inputFormatters: [UpperCaseTextFormatter()],
                        icon: Icons.code_outlined,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'required'.tr
                                    : (RegExp(
                                          r'^[A-Z]{4}0[A-Z0-9]{6}$',
                                        ).hasMatch(value)
                                        ? null
                                        : 'invalid_ifsc'.tr),
                      ),

                      _buildTextField(
                        label: 'bank_name'.tr,
                        obs: controller.bankName,
                        keyboardType: TextInputType.text,
                        icon: Icons.business_outlined,
                        validator:
                            (value) => value!.isEmpty ? 'required'.tr : null,
                      ),

                      SizedBox(height: 24.h),

                      // UPI & Digital Wallets Section
                      _buildSectionHeader(
                        'UPI & Digital Wallets',
                        Icons.payment,
                      ),
                      SizedBox(height: 16.h),

                      _buildTextField(
                        label: 'upi_id'.tr,
                        obs: controller.upiId,
                        icon: Icons.qr_code_2_outlined,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'required'.tr
                                    : (RegExp(
                                          r'^[\w.-]+@[\w.-]+$',
                                        ).hasMatch(value)
                                        ? null
                                        : 'invalid_upi'.tr),
                      ),

                      _buildTextField(
                        label: 'phone_pe'.tr,
                        obs: controller.phonePe,
                        icon: Icons.phone_android_outlined,
                        isOptional: true,
                        validator:
                            (value) =>
                                value!.isNotEmpty &&
                                        !RegExp(
                                          r'^[\w.-]+@[\w.-]+$',
                                        ).hasMatch(value)
                                    ? 'invalid_format'.tr
                                    : null,
                      ),

                      _buildTextField(
                        label: 'google_pay'.tr,
                        obs: controller.googlePay,
                        icon: Icons.g_mobiledata_outlined,
                        isOptional: true,
                        validator:
                            (value) =>
                                value!.isNotEmpty &&
                                        !RegExp(
                                          r'^[\w.-]+@[\w.-]+$',
                                        ).hasMatch(value)
                                    ? 'invalid_format'.tr
                                    : null,
                      ),

                      _buildTextField(
                        label: 'paytm'.tr,
                        obs: controller.paytm,
                        icon: Icons.wallet_outlined,
                        isOptional: true,
                        validator:
                            (value) =>
                                value!.isNotEmpty &&
                                        !RegExp(
                                          r'^[\w.-]+@[\w.-]+$',
                                        ).hasMatch(value)
                                    ? 'invalid_format'.tr
                                    : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                border: Border(
                  top: BorderSide(color: AppColors.dividerColor, width: 1.w),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSecondaryButton(
                      text: 'cancel'.tr,
                      onPressed: () => Get.back(),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    flex: 2,
                    child: _buildPrimaryButton(
                      text: 'save'.tr,
                      onPressed: controller.submit,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 20.w),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: AppTextStyles.subtitle().copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required RxString obs,
    required IconData icon,
    List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength, // ✅ Add maxLength
    bool isOptional = false,
    required String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Obx(
        () => Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
          child: TextFormField(
            initialValue: obs.value,
            keyboardType: keyboardType,
            maxLength: maxLength, // ✅ Apply maxLength
            inputFormatters: inputFormatters, // ✅ Apply inputFormatters
            onChanged: (value) => obs.value = value,
            validator: validator,
            style: AppTextStyles.body(),
            decoration: InputDecoration(
              counterText: '', // ✅ Hide counter if not needed
              labelText: isOptional ? '$label (Optional)' : label,
              labelStyle: AppTextStyles.caption(),
              prefixIcon: Container(
                margin: EdgeInsets.all(12.w),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 20.w),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 2.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 2.w,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.red, width: 1.w),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.red, width: 2.w),
              ),
              filled: true,
              fillColor: AppColors.surfaceColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(text, style: AppTextStyles.button),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 48.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.dividerColor, width: 1.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
