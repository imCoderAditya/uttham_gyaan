import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../controllers/bank_controller.dart';

class BankView extends GetView<BankController> {
  const BankView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankController>(init:BankController(),

      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title:  Text('bank_details'.tr),
            centerTitle: true,
          ),
          body: Obx(() {
            final bank = controller.bank.value;
            if (bank == null) {
              return  Center(
                child: Text(
                  'no_bank_details'.tr,
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildDetailRow('account_holder_name'.tr, bank.accountHolderName),
                    _buildDetailRow('account_number'.tr, bank.accountNumber),
                    _buildDetailRow('ifsc_code'.tr, bank.ifscCode),
                    _buildDetailRow('bank_name'.tr, bank.bankName),
                    _buildDetailRow('upi_id'.tr, bank.upiId),
                    _buildDetailRow('phone_pe'.tr, bank.phonePe),
                    _buildDetailRow('google_pay'.tr, bank.googlePay),
                    _buildDetailRow('paytm'.tr, bank.paytm),
                       ],
                ),
              );
            }
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: controller.openDialog,
            child: Icon(controller.bank.value == null ? Icons.add : Icons.edit),
          ),
        );
      }
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
