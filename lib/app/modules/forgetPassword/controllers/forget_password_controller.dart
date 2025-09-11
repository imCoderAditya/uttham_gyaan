import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';
import 'package:uttham_gyaan/components/Snack_bar_view.dart';
import 'package:uttham_gyaan/components/global_loader.dart';

class ForgetPasswordController extends GetxController {
  // Controllers
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Observable variables
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    mobileController.dispose();
    super.onClose();
  }

  // Reset password function
  Future<void> resetPassword() async {
    GlobalLoader.show();
    try {
      final res = await BaseClient.post(
        api: EndPoint.forgetrequest,
        data: {"Email": emailController.text, "Mobile": mobileController.text},
      );

      if (res != null && res.statusCode == 201) {
        SnackBarView.showError(
          message: res.data["message"] ?? "",
          duration: Duration(seconds: 4),
        );
      } else {
        SnackBarView.showError(message: res.data["message"] ?? "");
      }
    } catch (e) {
      SnackBarView.showError(message: "something_went_wrong".tr);
    } finally {
      GlobalLoader.hide();
    }
  }

  // Clear form
  void clearForm() {
    mobileController.clear();
  }
}
