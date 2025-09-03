// splash_view.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/modules/splash/controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Initialize screen util if not already done
    if (!ScreenUtil().screenWidth.isFinite) {
      ScreenUtil.init(context);
    }

    return Scaffold(
      body: AnimatedBuilder(
        animation: controller.backgroundAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.8 + 0.2 * controller.backgroundAnimation.value),
                  colorScheme.secondary.withOpacity(0.6 + 0.4 * controller.backgroundAnimation.value),
                  colorScheme.tertiary.withOpacity(0.4 + 0.6 * controller.backgroundAnimation.value),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [_buildAnimatedParticles(), _buildMainContent(context), _buildLoadingIndicator(context)],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedParticles() {
    return AnimatedBuilder(
      animation: controller.particleAnimation,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return Stack(
          children: List.generate(15, (index) {
            final progress = (controller.particleAnimation.value + index * 0.1) % 1.0;
            final size = 4.0 + (index % 3) * 2.0;
            final opacity = (1.0 - progress) * 0.6;

            // Ensure particles stay within screen bounds
            final leftPosition = (50.0 + (index * 30.0)) % (screenWidth - 100.0);
            final topPosition = screenHeight * progress;

            return Positioned(
              left: leftPosition,
              top: topPosition,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(opacity)),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            _buildAnimatedLogo(context),
            SizedBox(height: 40.h),
            _buildAnimatedText(context),
            SizedBox(height: 20.h),
            _buildAnimatedTagline(context),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.logoAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: controller.logoScaleAnimation.value,
          child: Opacity(
            opacity: controller.logoOpacityAnimation.value,
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30.r,
                    offset: Offset(0, 15.h),
                    spreadRadius: 5.r,
                  ),
                ],
              ),
              child: Container(
                margin: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors:
                        AppColors.headerGradientColors.isNotEmpty
                            ? AppColors.headerGradientColors
                            : [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(Icons.school_rounded, size: 50.sp, color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedText(BuildContext context) {
    return SlideTransition(
      position: controller.textSlideAnimation,
      child: FadeTransition(
        opacity: controller.textOpacityAnimation,
        child: Column(
          children: [
            ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
              child: Text(
                'utthamgyaan'.tr,
                style:
                    AppTextStyles.headlineLarge.call().copyWith(
                      fontSize: 42.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2.w,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: 80.w,
              height: 4.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.white.withOpacity(0.8), Colors.white.withOpacity(0.3)]),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTagline(BuildContext context) {
    return SlideTransition(
      position: controller.textSlideAnimation,
      child: FadeTransition(
        opacity: controller.textOpacityAnimation,
        child: Text(
          'excellence_in_education'.tr,
          style:
              AppTextStyles.body.call().copyWith(
                fontSize: 16.sp,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
                letterSpacing: 1.w,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Positioned(
      bottom: 80.h,
      left: 0,
      right: 0,
      child: Obx(
        () =>
            controller.isLoading.value
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 30.w,
                      height: 30.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      controller.loadingText.value,
                      style:
                          AppTextStyles.body.call().copyWith(fontSize: 14.sp, color: Colors.white.withOpacity(0.8)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
                : const SizedBox.shrink(),
      ),
    );
  }
}
