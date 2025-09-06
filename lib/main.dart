import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_theme.dart';
import 'package:uttham_gyaan/app/core/config/theme/theme_controller.dart';
import 'package:uttham_gyaan/app/core/contants/constant.dart';
import 'package:uttham_gyaan/app/locales/locales.dart';
import 'package:uttham_gyaan/app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await AppTranslations.init();
  Get.put(ThemeController()); // Initialize controller

  final savedLocale = getSavedLocale();
  runApp(MyApp(savedLocale: savedLocale));
}

class MyApp extends StatelessWidget {
  final Locale? savedLocale;
  const MyApp({super.key, this.savedLocale});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (_, child) {
        return Obx(() {
          final isDark = themeController.isDarkMode.value;
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value:
                isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Mega One Patient",
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              translations: AppTranslations(),
              locale: savedLocale ?? _getDeviceOrFallbackLocale(),
              fallbackLocale: const Locale('en', 'US'),
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(0.8)),
                  child: child ?? const SizedBox.shrink(),
                );
              },
            ),
          );
        });
      },
      child: const Placeholder(),
    );
  }

  Locale _getDeviceOrFallbackLocale() {
    final deviceLocale = Get.deviceLocale;
    const supportedLocales = ['en_US', 'hi_IN'];
    final current =
        '${deviceLocale?.languageCode}_${deviceLocale?.countryCode}';
    if (deviceLocale != null && supportedLocales.contains(current)) {
      return deviceLocale;
    }
    return const Locale('en', 'US');
  }
}
