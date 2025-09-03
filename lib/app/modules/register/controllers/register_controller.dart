// ignore_for_file: unused_field, deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';
import 'package:uttham_gyaan/app/routes/app_pages.dart';
import 'package:uttham_gyaan/app/services/rezerpay_service/rezerpay_service.dart';
import 'package:uttham_gyaan/components/Snack_bar_view.dart';

import '../../../services/storage/local_storage_service.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final referralPersonIdController = TextEditingController();
  final languagePreference = 'English'.obs;
  final isLoading = false.obs;

  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    GetStorage.init();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    referralPersonIdController.dispose();
    super.onClose();
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final response = await BaseClient.post(
        api: EndPoint.Register,
        data: {
          'FullName': fullNameController.text,
          'Email': emailController.text,
          'Phone': phoneController.text,
          'Password': passwordController.text,
          'LanguagePreference': languagePreference.value,
          'ReferalPersonId':
              referralPersonIdController.text.isEmpty
                  ? null
                  : int.parse(referralPersonIdController.text),
        },
      );

      if (response != null && response.statusCode == 201) {
        int userId = response.data?["userId"] ?? "";
        debugPrint("===>$userId");
        await startPayment(
          name: fullNameController.text,
          description: "payment",
          amount: 1000,
          userId: userId.toString(),
        );
      } else {
        SnackBarView.showError(message: response.data['message'] ?? "");
      }
    } catch (e) {
      SnackBarView.showError(message: 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> commisionAPI({String? userId, String? transactionID}) async {
    isLoading.value = true;
    try {
      final response = await BaseClient.post(
        api: EndPoint.commissionsAPI,
        data: {"CustomerId": userId, "TransactionID": transactionID},
      );
      if (response != null && response.statusCode == 200) {
        await LocalStorageService.saveLogin(userId: userId.toString());
        Get.offAllNamed(Routes.NAV);
      } else {
        SnackBarView.showError(message: "Registration failed");
      }
    } catch (e) {
      SnackBarView.showError(message: "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  RazorPayService? razorpayService;

  Future<void> startPayment({
    String? name,
    String? description,
    double? amount,
    String? userId,
  }) async {
    // Create the service instance
    razorpayService = RazorPayService(
      onPaymentSuccess: (PaymentSuccessResponse response) {
        log("✅ Payment Success: $response");
        commisionAPI(
          userId: userId.toString(),
          transactionID: response.paymentId,
        );
        // handle success (maybe call your backend to verify)
      },
      onPaymentError: (PaymentFailureResponse response) {
        log("❌ Payment Failed: ${response.code} - ${response.message}");

        // show error to user
      },
      onExternalWallet: (ExternalWalletResponse response) {
        log("💳 External Wallet Selected: ${response.walletName}");
      },
    );
    try {
      razorpayService?.openCheckout(
        amountInRupees: amount ?? 0,
        name: name ?? "",
        description: "Payment",
        contact: phoneController.text,
        email: emailController.text,
      );
    } catch (e) {
      debugPrint("❌ Error in startPayment: $e");
    }
  }
}
