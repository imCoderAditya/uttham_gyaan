// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/data/model/course/my_course_model.dart';
import 'package:uttham_gyaan/app/modules/mycourse/views/my_video_view.dart';
import 'package:uttham_gyaan/components/app_drawer.dart';
import '../controllers/mycourse_controller.dart';

class MycourseView extends GetView<MycourseController> {
  final bool? isMenuDisable;
  const MycourseView({super.key, this.isMenuDisable = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Get.put(MycourseController(), permanent: true);
    return GetBuilder<MycourseController>(
      init: MycourseController(),
      builder: (controller) {
        return Obx(() {
          final courses = controller.myCourseModel.value?.myCourseData ?? [];
          return Scaffold(
            drawer: isMenuDisable == true ? null : AppDrawer(),
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: _buildAppBar(context, controller),
            body: Column(
              children: [
                _buildSearchBar(context, controller),
                _buildSectionHeader(
                  context,
                  'my_courses'.tr,
                  controller.myCourseModel.value?.total ?? 0,
                ),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value && courses.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    } else if (!controller.isLoading.value && courses.isEmpty) {
                      return _buildEmptyState(
                        context,
                        controller.searchController.text.isNotEmpty,
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: GridView.builder(
                          padding: EdgeInsets.only(bottom: 100.h),
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: courses.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                              ),
                          itemBuilder:
                              (context, index) => GestureDetector(
                                onTap: () {
                                  controller.fetchAllCourseVideo(
                                    courses[index].courseId,
                                  );
                                  Get.to(
                                    MyVideoView(
                                      courseId:
                                          courses[index].courseId.toString(),
                                    ),
                                  );
                                },
                                child: _buildCourseCard(
                                  context,
                                  courses[index],
                                ),
                              ),
                        ),
                      );
                    }
                  }),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    MycourseController controller,
  ) {
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
      title: Text(
        'my_courses'.tr,
        style: AppTextStyles.headlineMedium().copyWith(color: AppColors.white),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, MycourseController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color:
                theme.brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.08),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: (value) {
          controller.fetchStudentCourse(query: value);
        },
        decoration: InputDecoration(
          hintText: 'search_courses'.tr,
          hintStyle: AppTextStyles.body().copyWith(
            color: AppTextStyles.caption().color,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colorScheme.primary,
            size: 24.sp,
          ),
          suffixIcon: Obx(() {
            controller.isLoading.value;
            return controller.searchController.text.isNotEmpty
                ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: AppTextStyles.caption().color,
                    size: 20.sp,
                  ),
                  onPressed: controller.clearSearch,
                )
                : const SizedBox.shrink();
          }),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: AppTextStyles.headlineLarge().copyWith(fontSize: 22.sp),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              count.toString(),
              style: AppTextStyles.caption().copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, MyCourseData course) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.08),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withOpacity(0.8),
                    colorScheme.secondary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  course.thumbnailUrl != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                        child: Image.network(
                          course.thumbnailUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  _buildPlaceholderImage(context),
                        ),
                      )
                      : _buildPlaceholderImage(context),

                  // Published Status
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            (course.isPublished == true)
                                ? AppColors.sucessPrimary
                                : AppColors.red,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        (course.isPublished == true)
                            ? 'published'.tr
                            : 'draft'.tr,
                        style: AppTextStyles.caption().copyWith(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Container(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  course.title ?? 'untitled_course'.tr,
                  style: AppTextStyles.body().copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),

                // Language
                if (course.language != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      course.language!.toUpperCase(),
                      style: AppTextStyles.caption().copyWith(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),

                SizedBox(height: 6.h),

                // Duration and Videos
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 11.sp,
                      color: AppTextStyles.small().color,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      '${course.durationMinutes ?? 0}m',
                      style: AppTextStyles.small().copyWith(fontSize: 9.sp),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.play_circle_outline,
                      size: 11.sp,
                      color: AppTextStyles.small().color,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      '${course.videoCount ?? 0}',
                      style: AppTextStyles.small().copyWith(fontSize: 9.sp),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),

                // Price
                if (course.mrp != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sucessPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      '₹${course.mrp!.toStringAsFixed(0)}',
                      style: AppTextStyles.caption().copyWith(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.sucessPrimary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.3),
            colorScheme.secondary.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Center(
        child: Icon(
          Icons.play_circle_outline,
          size: 40.sp,
          color: AppColors.white.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isSearching) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,

      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off_rounded : Icons.school_outlined,
            size: 80.sp,
            color: AppTextStyles.caption().color,
          ),
          SizedBox(height: 16.h),
          Text(
            isSearching ? 'no_search_results'.tr : 'no_courses_enrolled'.tr,
            style: AppTextStyles.headlineMedium(),
          ),
          SizedBox(height: 8.h),
          Text(
            isSearching
                ? 'try_different_keywords'.tr
                : 'enroll_in_courses_to_see_them_here'.tr,
            style: AppTextStyles.caption(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
