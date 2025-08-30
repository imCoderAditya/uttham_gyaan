import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uttham_gyaan/app/core/utils/logger_utils.dart';
import 'package:uttham_gyaan/app/data/model/video/course_video_model.dart';
import 'package:uttham_gyaan/app/data/repositories/api_repo.dart';
import 'package:uttham_gyaan/app/modules/profile/controllers/profile_controller.dart';
import 'package:uttham_gyaan/app/services/rezerpay_service/rezerpay_service.dart';

class CourseDetailsController extends GetxController {
  APIRepo apiRepo = APIRepo();

  RxInt? courseId = RxInt(1);
  final Rxn<VideoModel> _videoModel = Rxn<VideoModel>();

  Rxn<VideoModel> get videoModel => _videoModel;
  RxBool isLoading = false.obs;
  Future<void> fetchAllCourseVideo() async {
    isLoading.value = true;
    try {
      final res = await apiRepo.fetchAllCourseVideo(courseId: courseId?.value);

      if (res != null) {
        _videoModel.value = videoModelFromJson(json.encode(res.data));
        LoggerUtils.debug(json.encode(_videoModel.value), tag: "Response");
      } else {
        LoggerUtils.debug(jsonEncode(res.data), tag: "Response");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      await Future.delayed(Duration(milliseconds: 100));
      isLoading.value = false;
      update();
    }
  }

  final profileController =
      Get.isRegistered()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());

  RazorPayService? razorpayService;

  void startPayment({String? name, String? description, double? amount}) {
    // Create the service instance
    razorpayService = RazorPayService(
      onPaymentSuccess: (PaymentSuccessResponse response) {
        log("✅ Payment Success: ${response.paymentId}");
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
        key: "rzp_live_RAhdFjSs3ekRw0",
        amountInRupees: amount ?? 0,
        name: name ?? "",
        description: description ?? "Payment",
        contact: profileController.profileModel.value?.data?.phone,
        email: profileController.profileModel.value?.data?.email,
      );
    } catch (e) {
      debugPrint("❌ Error in startPayment: $e");
    }
  }

  @override
  void onReady() {
    fetchAllCourseVideo();
    super.onReady();
  }

  @override
  void onClose() {
    razorpayService?.dispose(); // cleanup
    super.onClose();
  }
}
