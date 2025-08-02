// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';


import 'package:uttham_gyaan/components/app_drawer.dart';

class ShimmerHomeView extends StatelessWidget {
  const ShimmerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Shimmer.fromColors(
          baseColor: theme.brightness == Brightness.dark ? Colors.white12 : Colors.grey[300]!,
          highlightColor: theme.brightness == Brightness.dark ? Colors.white30 : Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmer Image Slider
              _buildShimmerSlider(context),
              SizedBox(height: 16.h),

              // Shimmer Section Header
              _buildShimmerSectionHeader(context),
              SizedBox(height: 16.h),

              // Shimmer Course Grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6, // Show a fixed number of shimmer items
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                  ),
                  itemBuilder: (context, index) => _buildShimmerCourseCard(context),
                ),
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
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
      title: Container(width: 120.w, height: 24.h, color: Colors.white),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16.w, bottom: 5.h),
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
        ),
      ],
    );
  }

  Widget _buildShimmerSlider(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      height: 210.h,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
    );
  }

  Widget _buildShimmerSectionHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(width: 4.w, height: 24.h, color: Colors.white),
          SizedBox(width: 12.w),
          Container(width: 120.w, height: 24.h, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildShimmerCourseCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
          // Thumbnail Placeholder
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
            ),
          ),
          // Content Placeholder
          Container(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 18.h,
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 6.h),
                ),
                Container(width: 80.w, height: 18.h, color: Colors.white),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Container(width: 40.w, height: 12.h, color: Colors.white),
                    const Spacer(),
                    Container(width: 40.w, height: 12.h, color: Colors.white),
                  ],
                ),
                SizedBox(height: 10.h),
                Container(width: 60.w, height: 18.h, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
