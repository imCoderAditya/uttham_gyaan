import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../services/storage/local_storage_service.dart';
import '../../../services/storage/storage_keys.dart';
import '../views/register_view.dart';
import '../views/weview_payment.dart';



class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final referralPersonIdController = TextEditingController();
  final languagePreference = 'English'.obs;
  final isLoading = false.obs;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://uttamgyanapi.veteransoftwares.com',
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
      final response = await _dio.post(
        EndPoint.Register,
        data: {
          'FullName': fullNameController.text,
          'Email': emailController.text,
          'Phone': phoneController.text,
          'Password': passwordController.text,
          'LanguagePreference': languagePreference.value,
          'ReferalPersonId': int.parse(referralPersonIdController.text),
        },
      );

      if (response.data['status'] == true) {
        await LocalStorageService.saveLogin(userId: response.data['userId'].toString());
        Get.snackbar(
          'Success',
          response.data['message'],
          backgroundColor: AppColors.sucessPrimary.withOpacity(0.1),
          colorText: AppColors.sucessPrimary,
        );
        Get.to(() => WebViewScreen(url: response.data['redirectUrl'],uid :response.data['userId'].toString()));
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Registration failed'.tr,
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