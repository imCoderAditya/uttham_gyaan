// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';
import 'package:uttham_gyaan/app/routes/app_pages.dart';
import 'package:uttham_gyaan/app/services/storage/local_storage_service.dart';
import 'package:uttham_gyaan/components/Snack_bar_view.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    GetStorage.init();
  }

  @override
  void onClose() {
    identifierController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      final response = await BaseClient.post(
        api: EndPoint.Login,
        data: {'Identifier': identifierController.text, 'PasswordHash': passwordController.text},
      );

      final user = response.data?["User"] ?? "";
      if (response != null && response.statusCode == 200) {
        // Save UserID and LanguagePreference on successful login
        await LocalStorageService.saveLogin(userId: user["UserID"].toString());

        // SnackBarView.showSuccess(message: response.data['Message']);
        Get.offAllNamed(Routes.NAV);
      } else {
        SnackBarView.showWarning(message: response.data['Message'] ?? 'login_failed'.tr);
      }
    } catch (e) {
      SnackBarView.showWarning(message: 'something_went_wrong'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
