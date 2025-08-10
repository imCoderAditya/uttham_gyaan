// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/core/contants/constant.dart';
import 'package:uttham_gyaan/app/data/model/video/course_video_model.dart';
import 'package:uttham_gyaan/app/modules/mycourse/controllers/mycourse_controller.dart';
import 'package:uttham_gyaan/app/modules/video/controllers/video_controller.dart';
import 'package:uttham_gyaan/app/routes/app_pages.dart';

class MyVideoView extends StatelessWidget {
  const MyVideoView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<MycourseController>(
      init: MycourseController(),
      builder: (controller) {
        return Obx(() {
          final videoList = controller.videoModel.value?.data ?? [];

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: _buildAppBar(context, controller),
            body:
                controller.isLoading.value
                    ? _buildLoadingState(context)
                    : videoList.isEmpty
                    ? _buildEmptyState(context)
                    : _buildVideoList(context, videoList, controller),
          );
        });
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, MycourseController controller) {
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
      title: Text('course_videos'.tr, style: AppTextStyles.headlineMedium().copyWith(color: AppColors.white)),
      actions: [
        // Container(
        //   margin: EdgeInsets.only(right: 16.w, bottom: 5.h),
        //   decoration: BoxDecoration(color: AppColors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12.r)),
        //   child: IconButton(
        //     icon: Icon(Icons.sort_rounded, color: AppColors.white, size: 24.sp),
        //     onPressed: () => _showSortOptions(context, controller),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildVideoList(BuildContext context, List<CourseVideo> videos, MycourseController controller) {
    return CustomScrollView(
      slivers: [
        // Stats Header
        SliverToBoxAdapter(child: _buildStatsHeader(context, videos)),

        // Video List
        SliverPadding(
          padding: EdgeInsets.all(16.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final video = videos[index];

              return _buildVideoCard(context, video, index, controller);
            }, childCount: videos.length),
          ),
        ),

        // Bottom Spacing
        SliverToBoxAdapter(child: SizedBox(height: 80.h)),
      ],
    );
  }

  Widget _buildStatsHeader(BuildContext context, List<CourseVideo> videos) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalDuration = videos.fold<int>(0, (sum, video) => sum + (video.durationMinutes ?? 0));

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary.withOpacity(0.1), colorScheme.secondary.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colorScheme.primary.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(context, Icons.play_circle_outline_rounded, '${videos.length}', 'total_videos'.tr),
          ),
          Container(width: 1.w, height: 40.h, color: theme.dividerColor),
          Expanded(child: _buildStatItem(context, Icons.access_time_rounded, '${totalDuration}m', 'total_duration'.tr)),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Icon(icon, size: 32.sp, color: colorScheme.primary),
        SizedBox(height: 8.h),
        Text(
          value,
          style: AppTextStyles.headlineLarge().copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(label, style: AppTextStyles.caption().copyWith(fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildVideoCard(BuildContext context, CourseVideo video, int index, MycourseController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final youtubeId = extractVideoId(video.videoUrl ?? "");
    final thumbnailUrl = "https://img.youtube.com/vi/$youtubeId/hqdefault.jpg";
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _playVideo(context, video, controller),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // Video Thumbnail/Play Button
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(thumbnailUrl)),
                      gradient: LinearGradient(
                        colors: [colorScheme.primary.withOpacity(0.8), colorScheme.secondary.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),

                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Stack(
                      children: [
                        Center(child: Icon(Icons.play_arrow_rounded, size: 40.sp, color: AppColors.white)),
                        Positioned(
                          top: 6.h,
                          right: 6.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              '${video.sequenceOrder ?? index + 1}',
                              style: AppTextStyles.caption().copyWith(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 16.w),

                  // Video Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title ?? 'untitled_video'.tr,
                          style: AppTextStyles.body().copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),

                        // Duration and Course Info
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 16.sp, color: AppTextStyles.small().color),
                            SizedBox(width: 4.w),
                            Text(
                              '${video.durationMinutes ?? 0} min',
                              style: AppTextStyles.small().copyWith(fontSize: 12.sp),
                            ),
                            SizedBox(width: 16.w),
                            Icon(Icons.video_library_rounded, size: 16.sp, color: AppTextStyles.small().color),
                            SizedBox(width: 4.w),
                            Text(
                              "${'course_id'.tr} ${video.courseId}",
                              style: AppTextStyles.small().copyWith(fontSize: 12.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),

                        // Action Buttons
                        Row(
                          children: [
                            _buildActionButton(
                              context,
                              Icons.play_circle_filled_rounded,
                              'play'.tr,
                              colorScheme.primary,
                              () => _playVideo(context, video, controller),
                            ),
                            SizedBox(width: 12.w),
                            // _buildActionButton(
                            //   context,
                            //   Icons.download_rounded,
                            //   'download'.tr,
                            //   AppTextStyles.small().color!,
                            //   () => _downloadVideo(context, video, controller),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // More Options
                  // IconButton(
                  //   onPressed: () => _showVideoOptions(context, video, controller),
                  //   icon: Icon(Icons.more_vert_rounded, color: AppTextStyles.small().color, size: 20.sp),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.sp, color: color),
            SizedBox(width: 4.w),
            Text(
              label,
              style: AppTextStyles.caption().copyWith(fontSize: 11.sp, fontWeight: FontWeight.w600, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary), strokeWidth: 3.w),
          SizedBox(height: 16.h),
          Text('loading_videos'.tr, style: AppTextStyles.body().copyWith(color: AppTextStyles.caption().color)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(32.w),
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.video_library_outlined, size: 80.sp, color: AppTextStyles.caption().color),
          SizedBox(height: 16.h),
          Text('no_videos_available'.tr, style: AppTextStyles.headlineMedium()),
          SizedBox(height: 8.h),
          Text(
            'videos_will_appear_here_when_available'.tr,
            style: AppTextStyles.caption(),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_rounded, size: 20.sp),
            label: Text('go_back'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
          ),
        ],
      ),
    );
  }

  void _playVideo(BuildContext context, CourseVideo video, MycourseController controller) {
    final videoController = Get.put(VideoController());
    // Implement video player navigation
    // Get.to(VideoPlayerView(video: video));
    videoController.fetchVideo(video.videoId);
    Get.toNamed(Routes.VIDEO, arguments: {"videoId": video.videoId, "courseId": video.courseId});
  }

  // void _downloadVideo(BuildContext context, CourseVideo video, MycourseController controller) {
  //   // Implement video download functionality
  //   Get.snackbar(
  //     'download_video'.tr,
  //     'download_started'.trParams({'title': video.title ?? 'Unknown'}),
  //     snackPosition: SnackPosition.BOTTOM,
  //     // backgroundColor: AppColors.infoPrimary.withOpacity(0.9),
  //     colorText: AppColors.white,
  //   );
  // }

  // void _showVideoOptions(BuildContext context, CourseVideo video, MycourseController controller) {
  //   final theme = Theme.of(context);
  //   final colorScheme = theme.colorScheme;

  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder:
  //         (context) => Container(
  //           padding: EdgeInsets.all(20.w),
  //           decoration: BoxDecoration(
  //             color: colorScheme.surface,
  //             borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 width: 40.w,
  //                 height: 4.h,
  //                 decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(2.r)),
  //               ),
  //               SizedBox(height: 20.h),
  //               Text(
  //                 video.title ?? 'video_options'.tr,
  //                 style: AppTextStyles.headlineMedium().copyWith(fontSize: 18.sp),
  //                 maxLines: 2,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //               SizedBox(height: 24.h),
  //               _buildBottomSheetOption(context, Icons.play_circle_filled_rounded, 'play_video'.tr, () {
  //                 Get.back();
  //                 _playVideo(context, video, controller);
  //               }),
  //               _buildBottomSheetOption(context, Icons.download_rounded, 'download_video'.tr, () {
  //                 Get.back();
  //                 _downloadVideo(context, video, controller);
  //               }),
  //               _buildBottomSheetOption(context, Icons.share_rounded, 'share_video'.tr, () {
  //                 Get.back();
  //                 // Implement share functionality
  //               }),
  //               SizedBox(height: 20.h),
  //             ],
  //           ),
  //         ),
  //   );
  // }

  // Widget _buildBottomSheetOption(BuildContext context, IconData icon, String title, VoidCallback onTap) {
  //   final theme = Theme.of(context);

  //   return ListTile(
  //     leading: Icon(icon, color: theme.colorScheme.primary),
  //     title: Text(title, style: AppTextStyles.body()),
  //     onTap: onTap,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
  //   );
  // }

  // void _showSortOptions(BuildContext context, MycourseController controller) {
  //   final theme = Theme.of(context);
  //   final colorScheme = theme.colorScheme;

  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder:
  //         (context) => Container(
  //           padding: EdgeInsets.all(20.w),
  //           decoration: BoxDecoration(
  //             color: colorScheme.surface,
  //             borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 width: 40.w,
  //                 height: 4.h,
  //                 decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(2.r)),
  //               ),
  //               SizedBox(height: 20.h),
  //               Text('sort_videos'.tr, style: AppTextStyles.headlineMedium().copyWith(fontSize: 18.sp)),
  //               SizedBox(height: 24.h),
  //               // _buildBottomSheetOption(context, Icons.sort_by_alpha_rounded, 'sort_by_sequence'.tr, () {
  //               //   Get.back();
  //               //   controller.sortVideosBySequence();
  //               // }),
  //               // _buildBottomSheetOption(context, Icons.access_time_rounded, 'sort_by_duration'.tr, () {
  //               //   Get.back();
  //               //   controller.sortVideosByDuration();
  //               // }),
  //               // _buildBottomSheetOption(context, Icons.title_rounded, 'sort_by_title'.tr, () {
  //               //   Get.back();
  //               //   controller.sortVideosByTitle();
  //               // }),
  //               // SizedBox(height: 20.h),
  //             ],
  //           ),
  //         ),
  //   );
  // }
}
