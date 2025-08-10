import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/data/model/quiz/quiz_model.dart';
import 'package:uttham_gyaan/app/modules/video/controllers/video_controller.dart';
import 'package:uttham_gyaan/app/services/storage/local_storage_service.dart';
import 'package:uttham_gyaan/components/Snack_bar_view.dart';

class QuizController extends GetxController {
  final userId = LocalStorageService.getUserId();
  final controller = Get.find<VideoController>();
  // Existing observable variables
  Rxn<QuizModel> quizModel = Rxn<QuizModel>();

  final isLoading = false.obs;

  // Quiz functionality variables
  final currentQuestionIndex = 0.obs;
  final selectedOptionIndex = (-1).obs;
  final quizOptionId = (-1).obs;
  final isQuizCompleted = false.obs;
  final isSubmittingAnswer = false.obs;

  // Store answers for each question
  final Map<int, Map<String, dynamic>> userAnswers = {};

  Future<void> getQuizReposne({int? videoId}) async {
    try {
      isLoading.value = true;
      final res = await BaseClient.get(
        api: "https://uttamgyanapi.veteransoftwares.com/api/QuizResponse/unanswered?userId=$userId&videoId=$videoId",
      );

      if (res != null && res.statusCode == 200) {
        quizModel.value = quizModelFromJson(json.encode(res.data));
        log("Response: ${json.encode(quizModel.value)}");
        // Reset quiz state when new data is loaded
        resetQuiz();
      } else {
        debugPrint("Failed Response");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Get current quiz question
  Quiz? getCurrentQuiz() {
    final quizData = quizModel.value?.data;
    if (quizData != null && currentQuestionIndex.value >= 0 && currentQuestionIndex.value < quizData.length) {
      return quizData[currentQuestionIndex.value];
    }
    return null;
  }

  // Select an option for current question
  void selectOption(int optionIndex, int optionId) {
    selectedOptionIndex.value = optionIndex;
    quizOptionId.value = optionId;
  }

  // Submit current answer and move to next question or complete quiz
  Future<void> submitAnswerAndProceed({int? videoId}) async {
    if (selectedOptionIndex.value == -1) {
      SnackBarView.showError(message: 'please_select_an_answer'.tr);

      return;
    }

    // Get current quiz data
    final currentQuiz = getCurrentQuiz();
    if (currentQuiz == null) return;

    // Store the answer
    userAnswers[currentQuestionIndex.value] = {
      'quizId': currentQuiz.quizId,
      'selectedOptionId': quizOptionId.value,
      'selectedOptionIndex': selectedOptionIndex.value,
    };

    // Submit answer to API
    await submitCurrentAnswer(currentQuiz.quizId!, quizOptionId.value);

    if (isLastQuestion()) {
      await controller.fetchVideo(videoId);
    }
    // Check if this was the last question
    final totalQuestions = quizModel.value?.data?.length ?? 0;
    if (currentQuestionIndex.value >= totalQuestions - 1) {
      // Last question - show results
      isQuizCompleted.value = true;
    } else {
      // Move to next question
      currentQuestionIndex.value++;
      // Reset selection for next question
      selectedOptionIndex.value = -1;
      quizOptionId.value = -1;
    }
  }

  // Submit answer to API
  Future<void> submitCurrentAnswer(int quizId, int selectedOptionId) async {
    try {
      isSubmittingAnswer.value = true;
      final response = await BaseClient.post(
        api: "https://uttamgyanapi.veteransoftwares.com/api/QuizResponse/record-response",
        data: {"UserID": userId, "QuizID": quizId, "SelectedOptionID": selectedOptionId},
      );

      if (response != null && response.statusCode == 200) {
        debugPrint("Answer submitted successfully for Quiz ID: $quizId");
      } else {
        debugPrint("Failed to submit answer for Quiz ID: $quizId");
      }
    } catch (e) {
      debugPrint("Error submitting answer: $e");
    } finally {
      isSubmittingAnswer.value = false;
    }
  }

  // Check if current question is the last one
  bool isLastQuestion() {
    final totalQuestions = quizModel.value?.data?.length ?? 0;
    return currentQuestionIndex.value >= totalQuestions - 1;
  }

  // Get quiz progress percentage
  double getProgress() {
    final totalQuestions = quizModel.value?.data?.length ?? 0;
    if (totalQuestions == 0) return 0.0;
    return (currentQuestionIndex.value + 1) / totalQuestions;
  }

  // Get total answered questions
  int getAnsweredQuestionsCount() {
    return userAnswers.length;
  }

  // Get total questions
  int getTotalQuestions() {
    return quizModel.value?.data?.length ?? 0;
  }

  // Reset quiz to start over
  void resetQuiz() {
    currentQuestionIndex.value = 0;
    selectedOptionIndex.value = -1;
    quizOptionId.value = -1;
    isQuizCompleted.value = false;
    isSubmittingAnswer.value = false;
    userAnswers.clear();
  }

  // Refresh quiz data
  Future<void> refreshQuiz({int? videoId}) async {
    await getQuizReposne(videoId: videoId);
  }

  // Check if user has answered current question
  bool hasAnsweredCurrentQuestion() {
    return userAnswers.containsKey(currentQuestionIndex.value);
  }
}
