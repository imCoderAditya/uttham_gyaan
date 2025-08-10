import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/data/model/quiz/quiz_model.dart';

import '../controllers/quiz_controller.dart';

class QuizView extends StatefulWidget {
  final int? videoId;
  const QuizView({super.key, this.videoId});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  final controller = Get.put(QuizController());

  @override
  void initState() {
    debugPrint("Video Id: ${widget.videoId}");
    controller.getQuizReposne(videoId: widget.videoId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<QuizController>(
      init: QuizController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: _buildAppBar(context, controller),
          body: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingState();
            } else if (controller.quizModel.value?.data?.isEmpty ?? true) {
              return _buildEmptyState(context);
            } else if (controller.isQuizCompleted.value) {
              return _buildResultScreen(context, controller);
            } else {
              return _buildQuizContent(context, controller);
            }
          }),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, QuizController controller) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.headerGradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text('quiz_title'.tr, style: AppTextStyles.headlineMedium().copyWith(color: AppColors.white)),
      centerTitle: true,
      actions: [
        Obx(() {
          final totalQuestions = controller.quizModel.value?.data?.length ?? 0;
          if (totalQuestions > 0 && !controller.isQuizCompleted.value) {
            return Container(
              margin: EdgeInsets.only(right: 16.w, top: 8.h, bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '${controller.currentQuestionIndex.value + 1}/$totalQuestions',
                style: AppTextStyles.body().copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primaryColor),
          SizedBox(height: 16.h),
          Text('loading_quiz'.tr, style: AppTextStyles.body().copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Container(
        margin: EdgeInsets.all(24.w),
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10.r, offset: Offset(0, 4.h))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.quiz_outlined, size: 80.sp, color: AppColors.textSecondary),
            SizedBox(height: 16.h),
            Text('no_quiz_available'.tr, style: AppTextStyles.headlineMedium(), textAlign: TextAlign.center),
            SizedBox(height: 8.h),
            Text('quiz_will_be_available_soon'.tr, style: AppTextStyles.caption(), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizContent(BuildContext context, QuizController controller) {
    final currentQuiz = controller.getCurrentQuiz();
    if (currentQuiz == null) return _buildEmptyState(context);

    return Column(
      children: [
        // Progress Bar
        _buildProgressBar(controller),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Card
                _buildQuestionCard(context, currentQuiz, controller),

                SizedBox(height: 24.h),

                // Options
                _buildOptionsSection(context, currentQuiz, controller),

                SizedBox(height: 32.h),

                // Submit Button
                _buildSubmitButton(context, controller),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(QuizController controller) {
    final totalQuestions = controller.quizModel.value?.data?.length ?? 0;
    final currentIndex = controller.currentQuestionIndex.value;
    final progress = totalQuestions > 0 ? (currentIndex) / totalQuestions : 0.0;

    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'question'.tr} ${currentIndex + 1}',
                style: AppTextStyles.body().copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryColor),
              ),
              Text('${((progress * 100).toInt())}% ${'completed'.tr}', style: AppTextStyles.caption()),
            ],
          ),
          SizedBox(height: 8.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.primaryColor.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            minHeight: 6.h,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, Quiz currentQuiz, QuizController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15.r, offset: Offset(0, 5.h))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.quiz, color: AppColors.primaryColor, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'question'.tr,
                  style: AppTextStyles.body().copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            currentQuiz.questionText ?? 'no_question_text'.tr,
            style: AppTextStyles.headlineLarge().copyWith(height: 1.4, color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection(BuildContext context, Quiz currentQuiz, QuizController controller) {
    final options = currentQuiz.options ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'choose_answer'.tr,
          style: AppTextStyles.body().copyWith(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
        ),
        SizedBox(height: 16.h),
        ...options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          return _buildOptionTile(context, option, index, controller);
        }),
      ],
    );
  }

  Widget _buildOptionTile(BuildContext context, Option option, int index, QuizController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final isSelected = controller.selectedOptionIndex.value == index;

      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.selectOption(index, option.optionId ?? -1),
            borderRadius: BorderRadius.circular(16.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : colorScheme.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor : theme.dividerColor,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            blurRadius: 8.r,
                            offset: Offset(0, 2.h),
                          ),
                        ]
                        : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4.r, offset: Offset(0, 2.h))],
              ),
              child: Row(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? AppColors.primaryColor : Colors.blueGrey, width: 2),
                      color: isSelected ? AppColors.primaryColor : Colors.transparent,
                    ),
                    child: isSelected ? Icon(Icons.check, size: 16.sp, color: AppColors.white) : null,
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      option.optionText ?? 'no_option_text'.tr,
                      style: AppTextStyles.body().copyWith(
                        color: isSelected ? AppColors.primaryColor : colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSubmitButton(BuildContext context, QuizController controller) {
    return Obx(() {
      final isLastQuestion = controller.isLastQuestion();
      final canSubmit = controller.selectedOptionIndex.value != -1;
      final isSubmitting = controller.isSubmittingAnswer.value;

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed:
              () => canSubmit && !isSubmitting ? controller.submitAnswerAndProceed(videoId: widget.videoId) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.white,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            elevation: canSubmit ? 4 : 0,
          ),
          child:
              isSubmitting
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20.sp,
                        height: 20.sp,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'submitting'.tr,
                        style: AppTextStyles.body().copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLastQuestion ? 'submit_quiz'.tr : 'submit_answer'.tr,
                        style: AppTextStyles.body().copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        isLastQuestion ? Icons.check_circle : Icons.arrow_forward,
                        size: 20.sp,
                        color: AppColors.white,
                      ),
                    ],
                  ),
        ),
      );
    });
  }

  Widget _buildResultScreen(BuildContext context, QuizController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalQuestions = controller.getTotalQuestions();
    final answeredQuestions = controller.getAnsweredQuestionsCount();

    return Center(
      child: Container(
        margin: EdgeInsets.all(24.w),
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20.r, offset: Offset(0, 8.h))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(color: AppColors.sucessPrimary.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.emoji_events, size: 60.sp, color: AppColors.sucessPrimary),
            ),

            SizedBox(height: 24.h),

            // Completion Title
            Text(
              'quiz_completed'.tr,
              style: AppTextStyles.headlineLarge().copyWith(
                color: AppColors.sucessPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16.h),

            // Results Summary
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('total_questions'.tr, style: AppTextStyles.body().copyWith(color: AppColors.textSecondary)),
                      Text(
                        totalQuestions.toString(),
                        style: AppTextStyles.body().copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'answered_questions'.tr,
                        style: AppTextStyles.body().copyWith(color: AppColors.textSecondary),
                      ),
                      Text(
                        answeredQuestions.toString(),
                        style: AppTextStyles.body().copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.sucessPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Container(width: double.infinity, height: 1, color: theme.dividerColor),
                  SizedBox(height: 12.h),
                  Text('completion_rate'.tr, style: AppTextStyles.caption().copyWith(color: AppColors.textSecondary)),
                  SizedBox(height: 4.h),
                  Text(
                    '${((answeredQuestions / totalQuestions) * 100).toInt()}%',
                    style: AppTextStyles.headlineLarge().copyWith(
                      color: AppColors.sucessPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Thank you message
            Text(
              'thank_you_for_completing_quiz'.tr,
              style: AppTextStyles.body().copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 32.h),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: Text(
                      'back_to_course'.tr,
                      style: AppTextStyles.body().copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      side: BorderSide(color: AppColors.primaryColor),
                    ),
                    child: Text(
                      'retake_quiz'.tr,
                      style: AppTextStyles.body().copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
