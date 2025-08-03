// ignore_for_file: unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';
import 'package:uttham_gyaan/app/routes/app_pages.dart';
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
              referralPersonIdController.text.isEmpty ? null : int.parse(referralPersonIdController.text),
        },
      );

      if (response != null && response.statusCode == 201) {
        await commisionAPI(userId: response.data?["userId"] ?? "");
      } else {
        SnackBarView.showError(message: response.data['message'] ?? "");
      }
    } catch (e) {
      SnackBarView.showError(message: 'Something went wrong: $e'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> commisionAPI({int? userId, int? referredByUserID}) async {
    isLoading.value = true;
    try {
      final response = await BaseClient.post(
        api: EndPoint.commissionsAPI,
        data: {
          "OrderId": userId,
          "CustomerId": userId,
          'ReferalPersonId':
              referralPersonIdController.text.isEmpty ? null : int.parse(referralPersonIdController.text),
        },
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
}
