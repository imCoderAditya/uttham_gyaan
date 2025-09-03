import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uttham_gyaan/app/core/utils/logger_utils.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';
import 'package:uttham_gyaan/app/data/model/bookCourse/book_course_moel.dart';
import 'package:uttham_gyaan/app/data/model/course/course_model.dart';
import 'package:uttham_gyaan/app/data/model/video/course_video_model.dart';
import 'package:uttham_gyaan/app/data/repositories/api_repo.dart';
import 'package:uttham_gyaan/app/modules/profile/controllers/profile_controller.dart';
import 'package:uttham_gyaan/app/routes/app_pages.dart';
import 'package:uttham_gyaan/app/services/rezerpay_service/rezerpay_service.dart';
import 'package:uttham_gyaan/app/services/storage/local_storage_service.dart';
import 'package:uttham_gyaan/components/global_loader.dart';

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

  void startPayment({
    String? name,
    String? description,
    double? amount,
    int? paymentID,
  }) {
    // Create the service instance
    razorpayService = RazorPayService(
      onPaymentSuccess: (PaymentSuccessResponse response) {
        log("✅ Payment Success: $response");
        paymentStatusUpdate(
          paymentID: paymentID,
          transactionID: response.paymentId,
        );
        // handle success (maybe call your backend to verify)
      },
      onPaymentError: (PaymentFailureResponse response) {
        log("❌ Payment Failed: ${response.code} - ${response.message}");
        paymentStatusUpdate(paymentID: paymentID, transactionID: "");
        // show error to user
      },
      onExternalWallet: (ExternalWalletResponse response) {
        log("💳 External Wallet Selected: ${response.walletName}");
      },
    );
    try {
      razorpayService?.openCheckout(
        amountInRupees: 1 ,
        name: name ?? "",
        description: "Payment",
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

  Rxn<BookCourseModel> bookCourseModel = Rxn<BookCourseModel>();

  Future<void> orderPlace({int? courseID, CourseData? courseData}) async {
    GlobalLoader.show();
    try {
      final userId = LocalStorageService.getUserId();
      final res = await BaseClient.post(
        api: EndPoint.paymentsOrder,
        data: {"CourseID": courseID, "UserID": int.parse(userId.toString())},
      );

      if (res != null && res.statusCode == 200) {
        bookCourseModel.value = bookCourseModelFromJson(json.encode(res.data));
        GlobalLoader.hide();
        if (bookCourseModel.value?.statusCode == 200) {
          startPayment(
            paymentID: bookCourseModel.value?.paymentId,
            amount: bookCourseModel.value?.mrp,
            name: courseData?.title ?? "",
            description: courseData?.description ?? "",
          );
        }
      } else {
        GlobalLoader.hide();
        LoggerUtils.error("Failed To Book Course API${res.data}");
      }
    } catch (e) {
      GlobalLoader.hide();
      LoggerUtils.error("Error: $e");
    } finally {
      update();
    }
  }

  Future<void> paymentStatusUpdate({
    int? paymentID,
    String? transactionID,
  }) async {
    GlobalLoader.show();
    try {
      final res = await BaseClient.post(
        api: EndPoint.paymentStatusUpdate,
        data: {"PaymentID": paymentID, "TransactionID": transactionID},
      );

      if (res != null && res.statusCode == 200) {
        if (res.data["StatusCode"] == 200) {
          GlobalLoader.hide();
          Get.offNamed(Routes.MYCOURSE);
        }
      } else {
        GlobalLoader.hide();
        LoggerUtils.error("Failed To Book Course API${res.data}");
      }
    } catch (e) {
      GlobalLoader.hide();
      LoggerUtils.error("Error: $e");
    } finally {
      update();
    }
  }
}
