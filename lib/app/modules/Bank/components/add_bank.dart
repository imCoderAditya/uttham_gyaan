import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bank_controller.dart';

class AddBankView extends GetView<BankController> {
  const AddBankView({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(controller.accountHolderName.value.isEmpty ? 'add_bank_details'.tr : 'edit_bank_details'.tr),
      content: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                label: 'account_holder_name'.tr,
                obs: controller.accountHolderName,
                validator: (value) => value!.isEmpty ? 'required'.tr : (RegExp(r'^[a-zA-Z\s]+$').hasMatch(value) ? null : 'invalid_name'.tr),
              ),
              _buildTextField(
                label: 'account_number'.tr,
                obs: controller.accountNumber,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'required'.tr : (value.length >= 10 && value.length <= 20 && RegExp(r'^\d+$').hasMatch(value) ? null : 'invalid_account_number'.tr),
              ),
              _buildTextField(
                label: 'ifsc_code'.tr,
                obs: controller.ifscCode,
                validator: (value) => value!.isEmpty ? 'required'.tr : (RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value) ? null : 'invalid_ifsc'.tr),
              ),
              _buildTextField(
                label: 'bank_name'.tr,
                obs: controller.bankName,
                validator: (value) => value!.isEmpty ? 'required'.tr : null,
              ),
              _buildTextField(
                label: 'upi_id'.tr,
                obs: controller.upiId,
                validator: (value) => value!.isEmpty ? 'required'.tr : (RegExp(r'^[\w.-]+@[\w.-]+$').hasMatch(value) ? null : 'invalid_upi'.tr),
              ),
              _buildTextField(
                label: 'phone_pe'.tr,
                obs: controller.phonePe,
                validator: (value) => value!.isNotEmpty && !RegExp(r'^[\w.-]+@[\w.-]+$').hasMatch(value) ? 'invalid_format'.tr : null,
              ),
              _buildTextField(
                label: 'google_pay'.tr,
                obs: controller.googlePay,
                validator: (value) => value!.isNotEmpty && !RegExp(r'^[\w.-]+@[\w.-]+$').hasMatch(value) ? 'invalid_format'.tr : null,
              ),
              _buildTextField(
                label: 'paytm'.tr,
                obs: controller.paytm,
                validator: (value) => value!.isNotEmpty && !RegExp(r'^[\w.-]+@[\w.-]+$').hasMatch(value) ? 'invalid_format'.tr : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('cancel'.tr),
        ),
        ElevatedButton(
          onPressed: controller.submit,
          child: Text('save'.tr),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required RxString obs,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Obx(() => TextFormField(
        initialValue: obs.value,
        decoration: InputDecoration(labelText: label),
        keyboardType: keyboardType,
        onChanged: (value) => obs.value = value,
        validator: validator,
      )),
    );
  }
}