import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/utils/logger_utils.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';
import 'package:uttham_gyaan/app/data/model/withdrawal/withdrawal_transaction_model.dart';
import 'package:uttham_gyaan/app/services/storage/local_storage_service.dart';
import 'package:uttham_gyaan/components/Snack_bar_view.dart';
import 'package:uttham_gyaan/components/global_loader.dart';

class WithdrawalController extends GetxController {
  final userId = LocalStorageService.getUserId();

  TextEditingController ammountController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  RxBool isLoading = RxBool(false);
  Rxn<WithdrawalTransactionModel> withdrawalTransactionModel =
      Rxn<WithdrawalTransactionModel>();

  Future<void> fetchWithdrawal() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.post(
        api: EndPoint.paymentsTransactions,
        data: {"userId": userId, "status": "All", "transactionType": "All"},
      );
      if (res != null && res.statusCode == 200) {
        withdrawalTransactionModel.value = withdrawalTransactionModelFromJson(
          json.encode(res.data),
        );
        LoggerUtils.debug(
          "WithdrawalTransactionModel ${json.encode(withdrawalTransactionModel.value)} ",
        );
      } else {
        LoggerUtils.error("Failed Response : ${res?.data}");
      }
    } catch (e) {
      LoggerUtils.error("error:$e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> withdrawalRequest() async {
    Future.microtask(() {
      GlobalLoader.show();
    });
    try {
      final res = await BaseClient.post(
        api: EndPoint.paymentsRequest,
        data: {
          "UserID": int.tryParse(userId.toString()),
          "Amount": double.tryParse(ammountController.text),
          "Comments": commentsController.text,
        },
      );
      if (res != null && res.statusCode == 200 && res.data["status"] == true) {
        await fetchWithdrawal();
        Get.back();
        GlobalLoader.hide();
        SnackBarView.showSuccess(message: res.data["message"] ?? "");
        LoggerUtils.debug("Withdrawal Request ${res.data} ");
      } else {
        GlobalLoader.hide();
        SnackBarView.showError(message: res.data["message"] ?? "");
        LoggerUtils.error("Withdrawal Request Failed: ${res?.data}");
      }
    } catch (e) {
      GlobalLoader.hide();
      LoggerUtils.error("error:$e");
    } finally {
      update();
    }
  }

  void validateAndSubmit() {
    String amountText = ammountController.text.trim();
    String commentText = commentsController.text.trim();

    // Check if amount is empty
    if (amountText.isEmpty) {
      SnackBarView.showError(message: "please_enter_amount".tr);
      return;
    }

    // Parse amount
    double? amount = double.tryParse(amountText);
    if (amount == null) {
      SnackBarView.showError(message: "invalid_amount".tr);
      return;
    }

    // Check minimum amount
    if (amount < 500) {
      SnackBarView.showError(message: "minimum_withdrawal_error".tr);
      return;
    }

    // Check if comment is empty
    if (commentText.isEmpty) {
      SnackBarView.showError(message: "please_enter_comment".tr);
      return;
    }

    withdrawalRequest();
  }

  @override
  void onInit() {
    fetchWithdrawal();
    super.onInit();
  }
}
