// splash_controller.dart
// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/modules/language/views/language_view.dart';
import 'package:uttham_gyaan/app/modules/login/views/login_view.dart';
import 'package:uttham_gyaan/app/routes/app_pages.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  // Background animation
  late AnimationController backgroundAnimationController;
  late Animation<double> backgroundAnimation;

  // Logo animations
  late AnimationController logoAnimationController;
  late Animation<double> logoScaleAnimation;
  late Animation<double> logoOpacityAnimation;

  // Text animations
  late AnimationController textAnimationController;
  late Animation<Offset> textSlideAnimation;
  late Animation<double> textOpacityAnimation;

  // Particle animation
  late AnimationController particleAnimationController;
  late Animation<double> particleAnimation;

  // Loading state
  final isLoading = true.obs;
  final loadingText = 'Loading...'.obs;

  @override
  void onInit() {
    super.onInit();
    _initAnimations();
    _startSplashSequence();
  }

  void _initAnimations() {
    // Background animation
    backgroundAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: backgroundAnimationController, curve: Curves.easeInOut));

    // Logo animations
    logoAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    logoScaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: logoAnimationController, curve: Curves.elasticOut));
    logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: logoAnimationController, curve: Curves.easeIn));

    // Text animations
    textAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: textAnimationController, curve: Curves.easeOut));
    textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: textAnimationController, curve: Curves.easeIn));

    // Particle animation
    particleAnimationController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(particleAnimationController);
  }

  Future<void> _startSplashSequence() async {
    try {
      // Start background animation
      backgroundAnimationController.forward();

      // Small delay then start logo animation
      await Future.delayed(const Duration(milliseconds: 300));
      logoAnimationController.forward();

      // Small delay then start text animation
      await Future.delayed(const Duration(milliseconds: 500));
      textAnimationController.forward();

      // Update loading text periodically
      _updateLoadingText();

      // Wait for animations to complete and simulate initialization
      await Future.delayed(const Duration(seconds: 3));

      // Navigate to next screen
      _navigateToNext();
    } catch (e) {
      debugPrint('Error in splash sequence: $e');
      _navigateToNext(); // Navigate anyway to prevent hanging
    }
  }

  void _updateLoadingText() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (isLoading.value) {
        loadingText.value = 'Initializing...';
      }
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (isLoading.value) {
        loadingText.value = 'Almost ready...';
      }
    });
  }

  void _navigateToNext() async {
    isLoading.value = false;

    // Safe check for authentication before deciding navigation route
    final isAuthenticated = await BaseClient.isAuthenticated();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<SplashController>()) {
        try {
          if (isAuthenticated == true) {
            // Navigate to dashboard or home if authenticated
            Get.offAllNamed(Routes.NAV);
          } else {
            // Navigate to language selection or onboarding
            Get.offAllNamed(Routes.LANGUAGE);
          }
        } catch (e) {
          debugPrint('Navigation error: $e');

          // Fallback view in case of route error
          Get.offAll(
            () =>
                isAuthenticated == true
                    ? LoginView() // Replace with your real dashboard view
                    : const LanguageView(),
          ); // Replace with your real language view
        }
      }
    });
  }

  @override
  void onClose() {
    // Dispose all animation controllers
    backgroundAnimationController.dispose();
    logoAnimationController.dispose();
    textAnimationController.dispose();
    particleAnimationController.dispose();
    super.onClose();
  }
}
