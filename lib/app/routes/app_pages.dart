import 'package:get/get.dart';

import '../modules/courseDetails/bindings/course_details_binding.dart';
import '../modules/courseDetails/views/course_details_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/language/bindings/language_binding.dart';
import '../modules/language/views/language_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/mycourse/bindings/mycourse_binding.dart';
import '../modules/mycourse/views/mycourse_view.dart';
import '../modules/nav/bindings/nav_binding.dart';
import '../modules/nav/views/nav_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/video/bindings/video_binding.dart';
import '../modules/video/views/video_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => const HomeView(), binding: HomeBinding()),
    GetPage(name: _Paths.NAV, page: () => const NavView(), binding: NavBinding()),
    GetPage(name: _Paths.COURSE_DETAILS, page: () => const CourseDetailsView(), binding: CourseDetailsBinding()),
    GetPage(name: _Paths.VIDEO, page: () => const VideoView(), binding: VideoBinding()),
    GetPage(name: _Paths.MYCOURSE, page: () => const MycourseView(), binding: MycourseBinding()),
    GetPage(name: _Paths.REGISTER, page: () => const RegisterView(), binding: RegisterBinding()),
    GetPage(name: _Paths.LOGIN, page: () => const LoginView(), binding: LoginBinding()),
    GetPage(name: _Paths.PROFILE, page: () => const ProfileView(), binding: ProfileBinding()),
    GetPage(name: _Paths.WALLET, page: () => const WalletView(), binding: WalletBinding()),
    GetPage(name: _Paths.LANGUAGE, page: () => const LanguageView(), binding: LanguageBinding()),
    GetPage(name: _Paths.SPLASH, page: () => const SplashView(), binding: SplashBinding()),
  ];
}
