// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/data/model/course/course_model.dart';
import 'package:uttham_gyaan/app/modules/courseDetails/views/course_details_view.dart';
import 'package:uttham_gyaan/app/modules/home/components/shimmer_effect_view.dart';
import 'package:uttham_gyaan/app/modules/home/controllers/home_controller.dart';
import 'package:uttham_gyaan/app/modules/home/views/search_view.dart';
import 'package:uttham_gyaan/components/app_drawer.dart';
import 'package:uttham_gyaan/components/image_slider_ui.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    Get.put(HomeController(), permanent: true);
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Obx(() {
          final courses = controller.courseModel.value?.courseData ?? [];
          return courses.isEmpty
              ? ShimmerHomeView()
              : Scaffold(
                backgroundColor: theme.scaffoldBackgroundColor,
                appBar: _buildAppBar(context, controller),
                drawer: AppDrawer(),
                body: RefreshIndicator(
                  onRefresh: () => controller.fetchAllCourse(),
                  color: colorScheme.primary,
                  backgroundColor: colorScheme.surface,
                  child: CustomScrollView(
                    slivers: [
                      // Language Toggle Section
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 16.h),
                          child: ImageCarouselSlider(
                            imageUrls: controller.sliderImage,
                            height: 210,
                            onChange: (value) {
                              debugPrint("Response : ${value.id}");
                              // Get.to(CourseDetailsView(courseData:value));
                            },
                            autoPlay: true,
                            indicatorStyle: IndicatorStyle.line,
                          ),
                        ),
                      ),

                      // Courses Section
                      if (courses.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: _buildSectionHeader(context, 'courses'.tr),
                        ),

                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 12.w,
                                  mainAxisSpacing: 12.h,
                                ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => GestureDetector(
                                onTap: () {
                                  Get.to(
                                    CourseDetailsView(
                                      courseData: courses[index],
                                    ),
                                  );
                                },
                                child: _buildCourseCard(
                                  context,
                                  courses[index],
                                ),
                              ),
                              childCount: courses.length,
                            ),
                          ),
                        ),
                      ] else
                        SliverToBoxAdapter(child: _buildEmptyState(context)),

                      // Bottom Spacing
                      SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                    ],
                  ),
                ),
              );
        });
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    HomeController controller,
  ) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
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
        'uttham_gyan'.tr,
        style: AppTextStyles.headlineMedium().copyWith(color: AppColors.white),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16.w, bottom: 5.h),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: AppColors.white,
              size: 24.sp,
            ),
            onPressed:
                () => Get.to(SearchView(isDisableBackButton: true))?.then((
                  value,
                ) {
                  controller.fetchAllCourse();
                }),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
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
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, CourseData course) {
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
              child:
                  course.thumbnailUrl != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                        child: Image.network(
                          course.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  _buildPlaceholderImage(context),
                        ),
                      )
                      : _buildPlaceholderImage(context),
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

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.all(32.w),
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        children: [
          Icon(
            Icons.school_outlined,
            size: 80.sp,
            color: AppTextStyles.caption().color,
          ),
          SizedBox(height: 16.h),
          Text(
            'no_courses_available'.tr,
            style: AppTextStyles.headlineMedium(),
          ),
          SizedBox(height: 8.h),
          Text(
            'check_back_later'.tr,
            style: AppTextStyles.caption(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
