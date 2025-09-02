import 'dart:convert';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/utils/logger_utils.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';
import 'package:uttham_gyaan/app/data/model/quiz/quiz_result_model.dart';
import 'package:uttham_gyaan/app/data/model/video/video_details_model.dart';
import 'package:uttham_gyaan/app/services/storage/local_storage_service.dart';

class VideoController extends GetxController {
  RxBool isLoading = false.obs;
  Rxn<VideoDetailsModel> videoDetailsModel = Rxn<VideoDetailsModel>();

  Rxn<QuizResultModel> quizResultModel = Rxn<QuizResultModel>();

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
        showQuizResultDialog(Get.context!, quizResultModel.value);
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

 void showQuizResultDialog(
  BuildContext context,
  QuizResultModel? quizResultModel,
) {
  if (quizResultModel?.data == null ||
      (quizResultModel?.data?.isEmpty ?? true)) {
    // No data case with enhanced styling
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade50,
                Colors.white,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.quiz_outlined,
                  size: 48,
                  color: Colors.orange.shade600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Quiz Results",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "No results available at the moment.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return;
  }

  // Enhanced quiz results dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade50,
                Colors.white,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryColor, AppColors.primaryColor],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.analytics_outlined,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Quiz Results",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${quizResultModel?.data?.length ?? 0} Results",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Results List
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: quizResultModel?.data!.length,
                    itemBuilder: (context, index) {
                      final result = quizResultModel?.data?[index];
                      final accuracy = result?.accuracyPercentage ?? 0;
                      
                      // Determine performance color
                      Color performanceColor;
                      IconData performanceIcon;
                      if (accuracy >= 80) {
                        performanceColor = Colors.green;
                        performanceIcon = Icons.emoji_events;
                      } else if (accuracy >= 60) {
                        performanceColor = Colors.orange;
                        performanceIcon = Icons.thumb_up;
                      } else {
                        performanceColor = Colors.red;
                        performanceIcon = Icons.trending_up;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Performance Icon
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: performanceColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  performanceIcon,
                                  color: performanceColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      result?.videoTitle ?? "Untitled Video",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _buildStatChip(
                                          Icons.quiz,
                                          "Attempted",
                                          "${result?.attempted ?? 0}",
                                          Colors.blue.shade600,
                                        ),
                                        const SizedBox(width: 8),
                                        _buildStatChip(
                                          Icons.check_circle,
                                          "Correct",
                                          "${result?.correct ?? 0}",
                                          Colors.green.shade600,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Accuracy Progress Bar
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Accuracy",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              "${accuracy.toStringAsFixed(1)}%",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: performanceColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: accuracy / 100,
                                            backgroundColor: Colors.grey.shade200,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              performanceColor,
                                            ),
                                            minHeight: 6,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Action Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child:  Text(
                      "close".tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Helper widget for stat chips
Widget _buildStatChip(IconData icon, String label, String value, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    ),
  );
}
}
