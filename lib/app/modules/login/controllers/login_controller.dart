import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';
import 'package:uttham_gyaan/app/modules/register/controllers/register_controller.dart';

import '../../../services/storage/local_storage_service.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://localhost:44352',
    headers: {'Content-Type': 'application/json'},
  ));

  final _storage = GetStorage();

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

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final response = await _dio.post(
        EndPoint.Login,
        data: {
          'Identifier': identifierController.text,
          'PasswordHash': passwordController.text,
        },
      );

      if (response.data['status'] == true) {
        await LocalStorageService.saveLogin(userId: response.data['userId'].toString());
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Login successful'.tr,
          backgroundColor: AppColors.sucessPrimary.withOpacity(0.1),
          colorText: AppColors.sucessPrimary,
        );
        Get.offAllNamed('/home');
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Login failed'.tr,
          backgroundColor: AppColors.red.withOpacity(0.1),
          colorText: AppColors.black,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e'.tr,
        backgroundColor: AppColors.red.withOpacity(0.1),
        colorText: AppColors.black,
      );
    } finally {
      isLoading.value = false;
    }
  }
}