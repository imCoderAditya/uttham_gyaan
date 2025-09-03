// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/core/contants/constant.dart';
import 'package:uttham_gyaan/app/data/model/course/course_model.dart';
import 'package:uttham_gyaan/app/data/model/video/course_video_model.dart';
import 'package:uttham_gyaan/components/html_ui.dart';

import '../controllers/course_details_controller.dart';

class CourseDetailsView extends GetView<CourseDetailsController> {
  final CourseData? courseData;
  const CourseDetailsView({super.key, this.courseData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final controller = Get.put(CourseDetailsController());

    controller.courseId?.value = courseData?.courseId ?? 1;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : AppColors.white,
      body: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          // Custom App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 280.h,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Course Thumbnail/Video Player
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary.withOpacity(0.8),
                          colorScheme.secondary.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child:
                        courseData?.thumbnailUrl != null
                            ? Image.network(
                              courseData!.thumbnailUrl!,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      _buildPlaceholderThumbnail(context),
                            )
                            : _buildPlaceholderThumbnail(context),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Play Button
                  Center(
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.play_arrow_rounded,
                          size: 40.sp,
                          color: colorScheme.primary,
                        ),
                        onPressed: () {
                          _showVideoPlayer(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () => Get.back(),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: IconButton(
                  icon: Icon(Icons.share, color: AppColors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),

          // Course Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Header Info
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10.w,
                      right: 10.w,
                      top: 10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Course Title
                        Text(
                          courseData?.title ?? 'Course Title',
                          style: AppTextStyles.headlineLarge().copyWith(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Course Stats Row
                        Row(
                          children: [
                            _buildStatChip(
                              icon: Icons.access_time,
                              label: '${courseData?.durationMinutes ?? 0} min',
                              color: colorScheme.primary,
                            ),
                            SizedBox(width: 12.w),
                            _buildStatChip(
                              icon: Icons.play_circle_outline,
                              label: '${courseData?.videoCount ?? 0} videos',
                              color: colorScheme.secondary,
                            ),
                            SizedBox(width: 12.w),
                            _buildStatChip(
                              icon: Icons.language,
                              label:
                                  courseData?.language?.toString() ?? 'English',
                              color: AppColors.sucessPrimary,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Price Section
                        if (courseData?.mrp != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.sucessPrimary.withOpacity(0.1),
                                  AppColors.sucessPrimary.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColors.sucessPrimary.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.local_offer,
                                  color: AppColors.sucessPrimary,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  '₹${courseData!.mrp!.toStringAsFixed(0)}',
                                  style: AppTextStyles.headlineMedium()
                                      .copyWith(
                                        color: AppColors.sucessPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.sp,
                                      ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Videos Section - Horizontal Scroll
                  _buildSection(
                    context,
                    title: 'Course Videos',
                    content: SizedBox(
                      height: 200.h,
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (controller.videoModel.value?.data?.isEmpty ??
                            true) {
                          return Center(
                            child: Text(
                              'No videos available',
                              style: AppTextStyles.body().copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount:
                              controller.videoModel.value?.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final video =
                                controller.videoModel.value?.data?[index];

                            return _buildVideoCard(context, video!, index);
                          },
                        );
                      }),
                    ),
                  ),

                  // Description Section
                  _buildSection(
                    context,
                    title: 'About This Course',
                    content: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: HtmlWidgetUI(
                        htmlContent: courseData?.description ?? "",
                      ),
                    ),
                  ),

                  // Course Content Section
                  _buildSection(
                    context,
                    title: 'Course Content',
                    content: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          _buildContentItem(
                            context,
                            title: 'Introduction',
                            duration: '5:30',
                            isLocked: false,
                          ),
                          _buildContentItem(
                            context,
                            title: 'Getting Started',
                            duration: '12:45',
                            isLocked: false,
                          ),
                          _buildContentItem(
                            context,
                            title: 'Advanced Concepts',
                            duration: '18:20',
                            isLocked: true,
                          ),
                          _buildContentItem(
                            context,
                            title: 'Practical Examples',
                            duration: '25:15',
                            isLocked: true,
                          ),
                          _buildContentItem(
                            context,
                            title: 'Final Assessment',
                            duration: '8:10',
                            isLocked: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Instructor Section
                  _buildSection(
                    context,
                    title: 'Instructor',
                    content: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30.r,
                            backgroundColor: colorScheme.primary,
                            child: Icon(
                              Icons.person,
                              size: 30.sp,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expert Instructor',
                                  style: AppTextStyles.headlineMedium()
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Professional educator with 10+ years experience',
                                  style: AppTextStyles.body().copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 100.h), // Space for floating button
                ],
              ),
            ),
          ),
        ],
      ),

      // Enroll Button
      floatingActionButton: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        child: FloatingActionButton.extended(
          onPressed: () {
            _showEnrollmentDialog(context);
          },
          backgroundColor: colorScheme.primary,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          label: Text(
            'Enroll Now',
            style: AppTextStyles.headlineMedium().copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: Icon(Icons.play_arrow, color: AppColors.white, size: 24.sp),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildVideoCard(BuildContext context, CourseVideo video, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLocked = index > -1; // First 2 videos unlocked
    final youtubeId = extractVideoId(video.videoUrl ?? "");
    final thumbnailUrl = "https://img.youtube.com/vi/$youtubeId/hqdefault.jpg";
    return Container(
      width: 220.w,
      clipBehavior: Clip.none,
      margin: EdgeInsets.only(right: 16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Thumbnail
          Container(
            height: 120.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.8),
                  colorScheme.secondary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(thumbnailUrl),
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isLocked ? Icons.lock : Icons.play_arrow,
                      size: 24.sp,
                      color: colorScheme.primary,
                      // color: isLocked ? Colors.grey : colorScheme.primary,
                    ),
                  ),
                ),
                // Duration Badge
                Positioned(
                  bottom: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${video.durationMinutes ?? 0}:00',
                      style: AppTextStyles.caption().copyWith(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ),
                // Sequence Order Badge
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${video.sequenceOrder ?? index + 1}',
                        style: AppTextStyles.caption().copyWith(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Video Info
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title ?? '',
                    style: AppTextStyles.body().copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color:
                          isLocked
                              ? colorScheme.onSurface.withOpacity(0.5)
                              : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12.sp,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${video.durationMinutes ?? 0} min',
                        style: AppTextStyles.caption().copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 11.sp,
                        ),
                      ),
                      Spacer(),
                      if (isLocked)
                        Icon(
                          Icons.lock,
                          size: 12.sp,
                          color: colorScheme.primary.withOpacity(0.4),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderThumbnail(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.8),
            colorScheme.secondary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.play_circle_outline,
          size: 80.sp,
          color: AppColors.white.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTextStyles.caption().copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget content,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: AppTextStyles.headlineMedium().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ),
        content,
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildContentItem(
    BuildContext context, {
    required String title,
    required String duration,
    required bool isLocked,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color:
                isLocked
                    ? colorScheme.onSurface.withOpacity(0.1)
                    : colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            isLocked ? Icons.lock : Icons.play_arrow,
            color:
                isLocked
                    ? colorScheme.onSurface.withOpacity(0.5)
                    : colorScheme.primary,
            size: 20.sp,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.body().copyWith(
            fontWeight: FontWeight.w600,
            color: isLocked ? colorScheme.onSurface.withOpacity(0.5) : null,
          ),
        ),
        trailing: Text(
          duration,
          style: AppTextStyles.caption().copyWith(
            color:
                isLocked
                    ? colorScheme.onSurface.withOpacity(0.5)
                    : colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        onTap: isLocked ? null : () {},
      ),
    );
  }

  void _showVideoPlayer(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Video Player'),
            content: Text('YouTube video player will be implemented here'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showEnrollmentDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Row(
              children: [
                Icon(Icons.school, color: colorScheme.primary),
                SizedBox(width: 12.w),
                Text('Enroll in Course'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Are you ready to start learning?'),
                SizedBox(height: 16.h),
                if (courseData?.mrp != null)
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.sucessPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_offer, color: AppColors.sucessPrimary),
                        SizedBox(width: 8.w),
                        Text(
                          'Course Fee: ₹${courseData!.mrp!.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: AppColors.sucessPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  controller.orderPlace(
                    courseID: courseData?.courseId,
                    courseData: courseData,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Enroll Now',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ],
          ),
    );
  }
}
