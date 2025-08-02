// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/core/config/theme/theme_controller.dart';
import 'package:uttham_gyaan/app/data/model/course/course_model.dart';
import 'package:uttham_gyaan/app/modules/home/controllers/home_controller.dart';
import 'package:uttham_gyaan/components/app_drawer.dart';

class SearchView extends StatelessWidget {
  final bool isDisableBackButton;
  const SearchView({super.key, this.isDisableBackButton = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.find<ThemeController>();

    return GetBuilder<HomeController>(
      builder: (controller) {
        return Obx(() {
          controller.isLoading.value;
          return Scaffold(
            drawer: isDisableBackButton == true ? null : AppDrawer(),
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: _buildAppBar(context, themeController),
            body: Column(
              children: [
                _buildSearchBar(context, controller),
                Obx(() {
                  final courses = controller.searchCourseModel.value?.courseData ?? [];

                  if (controller.isLoading.value) {
                    return Expanded(child: Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)));
                  }

                  if (!controller.isLoading.value && courses.isEmpty) {
                    return Expanded(child: _buildEmptyState(context));
                  }

                  return Expanded(child: _buildSearchResults(context, courses));
                }),
              ],
            ),
          );
        });
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeController themeController) {
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
        'search_courses'.tr,
        style: AppTextStyles.headlineMedium().copyWith(color: AppColors.white, fontSize: 22.sp),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16.w),
          decoration: BoxDecoration(color: AppColors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12.r)),
          child: Obx(
            () => IconButton(
              icon: Icon(
                themeController.isDarkMode.value ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: AppColors.white,
                size: 24.sp,
              ),
              onPressed: () => themeController.toggleTheme(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, HomeController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.dividerColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: TextField(
        style: AppTextStyles.body(),
        onChanged: (value) {
          controller.fetchAllCourse(query: value, isSearch: true);
        },
        decoration: InputDecoration(
          hintText: 'search_for_courses'.tr,
          hintStyle: AppTextStyles.body().copyWith(color: AppTextStyles.caption().color),
          prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary, size: 24.sp),
          suffixIcon: IconButton(
            icon: Icon(Icons.tune_rounded, color: AppTextStyles.caption().color, size: 20.sp),
            onPressed: () {
              // Add filter functionality
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, List<CourseData> courses) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results header
          Row(
            children: [
              Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 12.w),
              Text('all_courses'.tr, style: AppTextStyles.headlineMedium().copyWith(fontSize: 18.sp)),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${courses.length} ${'courses_found'.tr}',
                  style: AppTextStyles.caption().copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Grid Results
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.only(bottom: 100.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return _buildCourseCard(context, courses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, CourseData course) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        // Handle course tap
        Get.snackbar(
          'course_selected'.tr,
          course.title ?? 'unknown_course'.tr,
          backgroundColor: colorScheme.primary,
          colorText: AppColors.white,
          borderRadius: 12.r,
          margin: EdgeInsets.all(16.w),
        );
      },
      child: Container(
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
                    colors: [colorScheme.primary.withOpacity(0.8), colorScheme.secondary.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child:
                    course.thumbnailUrl != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                          child: Image.network(
                            course.thumbnailUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(context),
                          ),
                        )
                        : _buildPlaceholderImage(context),
              ),
            ),

            // Content
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      course.title ?? 'untitled_course'.tr,
                      style: AppTextStyles.body().copyWith(fontSize: 13.sp, fontWeight: FontWeight.bold, height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),

                    // Duration and Videos
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 11.sp, color: AppTextStyles.small().color),
                        SizedBox(width: 3.w),
                        Text('${course.durationMinutes ?? 0}m', style: AppTextStyles.small().copyWith(fontSize: 9.sp)),
                        const Spacer(),
                        Icon(Icons.play_circle_outline_rounded, size: 11.sp, color: AppTextStyles.small().color),
                        SizedBox(width: 3.w),
                        Text('${course.videoCount ?? 0}', style: AppTextStyles.small().copyWith(fontSize: 9.sp)),
                      ],
                    ),
                    SizedBox(height: 6.h),

                    // Price and Language
                    Row(
                      children: [
                        if (course.mrp != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.sucessPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              '₹${course.mrp!.toStringAsFixed(0)}',
                              style: AppTextStyles.small().copyWith(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.sucessPrimary,
                              ),
                            ),
                          ),
                        const Spacer(),
                        if (course.language != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              course.language.toString(),
                              style: AppTextStyles.small().copyWith(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary.withOpacity(0.3), colorScheme.secondary.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Center(
        child: Icon(Icons.play_circle_outline_rounded, size: 40.sp, color: AppColors.white.withOpacity(0.8)),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Container(
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
            Icon(Icons.search_off_rounded, size: 80.sp, color: AppTextStyles.caption().color),
            SizedBox(height: 16.h),
            Text('no_results_found'.tr, style: AppTextStyles.headlineMedium().copyWith(fontSize: 18.sp)),
            SizedBox(height: 8.h),
            Text(
              'try_different_search'.tr,
              style: AppTextStyles.caption().copyWith(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back_rounded, size: 20.sp),
              label: Text('back_to_home'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
