import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/utils/logger_utils.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';
import 'package:uttham_gyaan/app/data/model/video/video_details_model.dart';

class VideoController extends GetxController {
RxBool isLoading = false.obs;
  Rxn<VideoDetailsModel> videoDetailsModel = Rxn<VideoDetailsModel>();

  Future<void> fetchVideo(int? videoId) async {
    try {
      final res = await BaseClient.get(api: "${EndPoint.myCourseVideos}?videoId=$videoId&userId=1");
      if (res != null && res.statusCode == 200) {
        videoDetailsModel.value = videoDetailsModelFromJson(json.encode(res.data));
        LoggerUtils.debug("Response: ${res.data}");
      } else {
        debugPrint("Failed Response");
      }
    } catch (e) {
      LoggerUtils.debug("Message : $e");
    } finally {
      update();
    }
  }

  //TODO: Implement VideoController

  final count = 0.obs;



  void increment() => count.value++;

}
