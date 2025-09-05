import 'dart:convert';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/utils/logger_utils.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';
import 'package:uttham_gyaan/app/data/model/quiz/quiz_result_model.dart';
import 'package:uttham_gyaan/app/data/model/video/video_details_model.dart';
import 'package:uttham_gyaan/app/services/storage/local_storage_service.dart';

import '../../../data/model/certificate_model/certificate_model.dart';

class VideoController extends GetxController {
  RxBool isLoading = false.obs;
  Rxn<VideoDetailsModel> videoDetailsModel = Rxn<VideoDetailsModel>();

  Rxn<QuizResultModel> quizResultModel = Rxn<QuizResultModel>();
  Rxn<CourseProgressModel> courseProgressModel = Rxn<CourseProgressModel>();

  Future<void> fetchVideo(int? videoId) async {
    try {
      final userId = LocalStorageService.getUserId();
      final res = await BaseClient.get(
        api: "${EndPoint.myCourseVideos}?videoId=$videoId&userId=$userId",
      );
      if (res != null && res.statusCode == 200) {
        videoDetailsModel.value = videoDetailsModelFromJson(
          json.encode(res.data),
        );

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

  Future<void> updateProgressBar({
    int? videoId,
    int? courseId,
    int? currentTime,
    double? completionPercentage,
    bool? isCompleted,
  }) async {
    try {
      final userId = LocalStorageService.getUserId();
      final res = await BaseClient.post(
        api: EndPoint.userVideoProgress,
        data: {
          "UserID": userId,
          "VideoID": videoId,
          "CourseID": courseId,
          "WatchedDurationMinutes": currentTime,
          "CompletionPercentage": completionPercentage,
          "IsCompleted": isCompleted,
        },
      );
      if (res != null && res.statusCode == 200) {
        LoggerUtils.debug("Response: ${res.data}");
        await fetchVideo(videoId);
      } else {
        debugPrint("Failed Response");
      }
    } catch (e) {
      LoggerUtils.debug("Message : $e");
    } finally {
      update();
    }
  }
  Future<void> fetchCourseProgress({int? courseId}) async {
    try {
      final userId = LocalStorageService.getUserId();
      final res = await BaseClient.get(
        api: "${EndPoint.courseProgressSummary}?userId=$userId&courseId=$courseId",
      );
      if (res != null && res.statusCode == 200) {
        courseProgressModel.value = courseProgressModelFromJson(
          json.encode(res.data),
        );
        LoggerUtils.debug("Course Progress Response: ${res.data}");
      } else {
        debugPrint("Failed Course Progress Response");
      }
    } catch (e) {
      LoggerUtils.debug("Course Progress Error: $e");
    } finally {
      update();
    }
  }
  RxBool isMatched = false.obs;
  Rxn<QuizResult> quizResult = Rxn<QuizResult>();
  Future<void> getQuizResult({int? videoId}) async {
    final userId = LocalStorageService.getUserId();
    try {
      isLoading.value = true;
      final res = await BaseClient.get(
        api:
            "https://uttamgyanapi.veteransoftwares.com/api/QuizResponse/userresult?userId=$userId&VideoId=$videoId",
      );

      if (res != null && res.statusCode == 200) {
        quizResultModel.value = quizResultModelFromJson(json.encode(res.data));
        log("Response Quiz Result: ${json.encode(quizResultModel.value)}");
        for (int i = 0; i < (quizResultModel.value?.data?.length ?? 0); i++) {
          debugPrint("videoId=${quizResultModel.value?.data?[i].videoId}");
          if (videoId == quizResultModel.value?.data?[i].videoId) {
            isMatched.value = true;
            quizResult.value = quizResultModel.value?.data?[i];
          } else {
            isMatched.value = false;
          }
          debugPrint("${isMatched.value}");
        }
      } else {
        debugPrint("Failed Response");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
