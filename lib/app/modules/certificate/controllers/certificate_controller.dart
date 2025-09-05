import 'dart:convert';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uttham_gyaan/app/core/utils/logger_utils.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';
import 'package:uttham_gyaan/app/data/model/certificate/cartificate_model.dart';
import 'package:uttham_gyaan/app/services/storage/local_storage_service.dart';

class CertificateController extends GetxController {
  var isLoading = false.obs;
  Rxn<CertificateModel> certificateModel = Rxn<CertificateModel>();
  final userId = LocalStorageService.getUserId();
  Future<void> fetchCertificate(String? courseId) async {
    try {
      final res = await BaseClient.get(
        api: "${EndPoint.certificateAPI}?userId=$userId&courseId=$courseId",
      );
      if (res != null && res.statusCode == 200) {
        certificateModel.value = certificateModelFromJson(
          json.encode(res.data),
        );
      } else {
        LoggerUtils.error("error : ${json.encode(res?.data)}");
      }
    } catch (e) {
      LoggerUtils.debug("Error: $e");
    }
  }

  /// Download certificate PDF
  Future<void> downloadCertificate(String certificateLink) async {
    try {
      final Uri url = Uri.parse(certificateLink);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        Get.snackbar(
          'Success',
          'Certificate download started',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Could not open certificate link',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download certificate: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
