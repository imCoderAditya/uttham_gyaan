import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';

import '../controllers/certificate_controller.dart';

class CertificateView extends StatefulWidget {
  final String? courseId;
  const CertificateView({super.key, this.courseId});

  @override
  State<CertificateView> createState() => _CertificateViewState();
}

class _CertificateViewState extends State<CertificateView> {
  final controller = Get.put(CertificateController());

  @override
  void initState() {
    controller.fetchCertificate(widget.courseId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CertificateController>(
      init: CertificateController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: _buildAppBar(),
          body: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingView();
            } else if (controller.certificateModel.value == null) {
              return _buildErrorView();
            } else {
              return _buildCertificateContent(controller);
            }
          }),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('certificate'.tr, style: AppTextStyles.headlineMedium().copyWith(
        color:AppColors.white
      )),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.headerGradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      backgroundColor: AppColors.surfaceColor,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.white),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primaryColor),
          SizedBox(height: 16.h),
          Text('loading_certificate'.tr, style: AppTextStyles.body()),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.w, color: AppColors.red),
          SizedBox(height: 16.h),
          Text(
            'no_certificate_data'.tr,
            style: AppTextStyles.headlineMedium(),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'complete_course_message'.tr,
            style: AppTextStyles.body(),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => controller.fetchCertificate(widget.courseId),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('retry'.tr, style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateContent(CertificateController controller) {
    final data = controller.certificateModel.value!.data!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCertificateCard(data),
          SizedBox(height: 24.h),
          _buildProgressSection(data),
          SizedBox(height: 24.h),
          _buildQuizSection(data),
          SizedBox(height: 24.h),
          _buildTimeSection(data),
          if (data.certificateLink != null) ...[
            SizedBox(height: 24.h),
            _buildDownloadButton(data.certificateLink!),
          ],
        ],
      ),
    );
  }

  Widget _buildCertificateCard(dynamic data) {
    final isEligible = (data.overallCompletionPercentage ?? 0) >= 80.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.headerGradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            isEligible ? Icons.verified : Icons.pending,
            size: 48.w,
            color: AppColors.white,
          ),
          SizedBox(height: 16.h),
          Text(
            isEligible ? 'certificate_ready'.tr : 'in_progress'.tr,
            style: AppTextStyles.headlineLarge().copyWith(
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            isEligible
                ? 'congratulations_message'.tr
                : 'completion_requirement'.tr,
            style: AppTextStyles.body().copyWith(
              color: AppColors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(dynamic data) {
    return _buildSectionCard(
      title: 'course_progress'.tr,
      icon: Icons.trending_up,
      children: [
        _buildProgressTile(
          'overall_completion'.tr,
          data.overallCompletionPercentage ?? 0.0,
          AppColors.sucessPrimary,
        ),
        SizedBox(height: 12.h),
        _buildProgressTile(
          'video_completion'.tr,
          data.videoCompletionPercentage ?? 0.0,
          AppColors.primaryColor,
        ),
        SizedBox(height: 16.h),
        _buildStatRow(
          'videos_watched'.tr,
          '${data.videosCompleted ?? 0}/${data.totalVideos ?? 0}',
        ),
        _buildStatRow('course_started'.tr, _formatDate(data.courseStartedDate)),
        if (data.lastVideoActivity != null)
          _buildStatRow(
            'last_activity'.tr,
            _formatDate(data.lastVideoActivity),
          ),
      ],
    );
  }

  Widget _buildQuizSection(dynamic data) {
    return _buildSectionCard(
      title: 'quiz_performance'.tr,
      icon: Icons.quiz,
      children: [
        _buildProgressTile(
          'quiz_success_rate'.tr,
          data.quizSuccessRate ?? 0.0,
          AppColors.secondaryPrimary,
        ),
        SizedBox(height: 16.h),
        _buildStatRow(
          'quizzes_attempted'.tr,
          '${data.quizzesAttempted ?? 0}/${data.totalQuizzes ?? 0}',
        ),
        _buildStatRow('correct_answers'.tr, '${data.correctAnswers ?? 0}'),
        _buildStatRow('total_attempts'.tr, '${data.totalQuizAttempts ?? 0}'),
        if (data.lastQuizActivity != null)
          _buildStatRow('last_quiz'.tr, _formatDate(data.lastQuizActivity)),
      ],
    );
  }

  Widget _buildTimeSection(dynamic data) {
    return _buildSectionCard(
      title: 'time_investment'.tr,
      icon: Icons.access_time,
      children: [
        _buildStatRow(
          'total_watched'.tr,
          _formatDuration(data.totalWatchedMinutes ?? 0),
        ),
        _buildStatRow(
          'course_duration'.tr,
          _formatDuration(data.totalCourseDurationMinutes ?? 0),
        ),
        _buildStatRow(
          'average_completion'.tr,
          '${(data.averageVideoCompletionPercentage ?? 0).toStringAsFixed(1)}%',
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryColor, size: 24.w),
              SizedBox(width: 12.w),
              Text(title, style: AppTextStyles.headlineMedium()),
            ],
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildProgressTile(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.body()),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: AppTextStyles.body().copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: AppColors.dividerColor,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6.h,
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body()),
          Text(
            value,
            style: AppTextStyles.body().copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton(String certificateLink) {
    return certificateLink.isNotEmpty
        ? SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => controller.downloadCertificate(certificateLink),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sucessPrimary,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            icon: Icon(Icons.download, color: AppColors.white, size: 20.w),
            label: Text('download_certificate'.tr, style: AppTextStyles.button),
          ),
        )
        : SizedBox();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'not_available'.tr;
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDuration(int minutes) {
    if (minutes == 0) return '0 ${'minutes_short'.tr}';

    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours > 0) {
      return '$hours${'hours_short'.tr} $mins${'minutes_short_with_h'.tr}';
    } else {
      return '$mins${'minutes_short_with_h'.tr}';
    }
  }
}
