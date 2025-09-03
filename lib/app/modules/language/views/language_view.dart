// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/core/contants/constant.dart';
import 'package:uttham_gyaan/app/routes/app_pages.dart' show Routes;

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageView> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _floatingController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatingAnimation;

  String? selectedLanguage;

  final List<LanguageOption> languages = [
    LanguageOption(
      titleKey: 'language_english_title',
      subtitleKey: 'language_english_subtitle',
      languageCode: 'en',
      countryCode: 'US',
      flag: '🇺🇸',
      gradient: [const Color(0xFF667eea), const Color(0xFF764ba2)],
    ),
    LanguageOption(
      titleKey: 'language_hindi_title',
      subtitleKey: 'language_hindi_subtitle',
      languageCode: 'hi',
      countryCode: 'IN',
      flag: '🇮🇳',
      gradient: [const Color(0xFFf093fb), const Color(0xFFf5576c)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
    selectedLanguage = Get.locale?.languageCode;
  }

  void _initAnimations() {
    _fadeController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _slideController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _scaleController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _floatingController = AnimationController(duration: const Duration(milliseconds: 3000), vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));
    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _slideController.forward();
    _scaleController.forward();
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _selectLanguage(LanguageOption language) {
    setState(() {
      selectedLanguage = language.languageCode;
      changeLanguage(Locale(language.languageCode, language.countryCode));
    });
    _scaleController.reverse().then((_) {
      _scaleController.forward();
    });
  }

  void _continueWithLanguage() {
    if (selectedLanguage != null) {
      final language = languages.firstWhere((lang) => lang.languageCode == selectedLanguage);
      Get.updateLocale(Locale(language.languageCode, language.countryCode));

      // final languageTitle = language.titleKey.tr;
      // final snackbarMessage = 'snackbar_message_template'.trParams({'lang': languageTitle});

      Get.offAllNamed(Routes.LOGIN);
      // Get.snackbar(
      //   'snackbar_title_language_selected'.tr,
      //   snackbarMessage,
      //   backgroundColor: AppColors.headerGradientColors.first,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.secondary.withOpacity(0.05),
              colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 60.h),
                _buildHeader(context),
                SizedBox(height: 60.h),
                Expanded(child: _buildLanguageOptions(context)),
                SizedBox(height: 40.h),
                _buildContinueButton(context),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _floatingAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -10 * _floatingAnimation.value),
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.3),
                          blurRadius: 30.r,
                          offset: Offset(0, 15.h),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(Icons.language_rounded, size: 60.sp, color: Colors.white),
                  ),
                );
              },
            ),
            SizedBox(height: 32.h),
            Text(
              'title_choose_language'.tr,
              style: AppTextStyles.headlineLarge().copyWith(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'subtitle_select_to_continue'.tr,
              style: AppTextStyles.body().copyWith(fontSize: 16.sp, color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOptions(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ListView.builder(
        itemCount: languages.length,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        itemBuilder: (context, index) {
          final language = languages[index];
          final isSelected = selectedLanguage == language.languageCode;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(bottom: 20.h),
            child: _buildLanguageCard(context, language, isSelected),
          );
        },
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, LanguageOption language, bool isSelected) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient:
            isSelected
                ? LinearGradient(colors: language.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight)
                : null,
        color: isSelected ? null : colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isSelected ? Colors.transparent : colorScheme.outline.withOpacity(0.2), width: 2.w),
        boxShadow: [
          BoxShadow(
            color: isSelected ? language.gradient.first.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: isSelected ? 20.r : 10.r,
            offset: Offset(0, isSelected ? 8.h : 4.h),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectLanguage(language),
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withOpacity(0.2) : colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(child: Text(language.flag, style: TextStyle(fontSize: 30.sp))),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.titleKey.tr,
                        style: AppTextStyles.headlineMedium().copyWith(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        language.subtitleKey.tr,
                        style: AppTextStyles.body().copyWith(
                          fontSize: 14.sp,
                          color: isSelected ? Colors.white.withOpacity(0.8) : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.white : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? Colors.white : colorScheme.outline.withOpacity(0.3),
                      width: 2.w,
                    ),
                  ),
                  child: isSelected ? Icon(Icons.check, size: 16.sp, color: language.gradient.first) : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient:
            selectedLanguage != null
                ? LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : null,
        color: selectedLanguage != null ? null : colorScheme.outline.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow:
            selectedLanguage != null
                ? [BoxShadow(color: colorScheme.primary.withOpacity(0.3), blurRadius: 20.r, offset: Offset(0, 8.h))]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: selectedLanguage != null ? _continueWithLanguage : null,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'button_continue'.tr,
                  style: AppTextStyles.body().copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: selectedLanguage != null ? Colors.white : colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(width: 12.w),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: selectedLanguage != null ? 0 : -0.25,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: selectedLanguage != null ? Colors.white : colorScheme.onSurfaceVariant,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LanguageOption {
  final String titleKey;
  final String subtitleKey;
  final String languageCode;
  final String countryCode;
  final String flag;
  final List<Color> gradient;

  const LanguageOption({
    required this.titleKey,
    required this.subtitleKey,
    required this.languageCode,
    required this.countryCode,
    required this.flag,
    required this.gradient,
  });
}
