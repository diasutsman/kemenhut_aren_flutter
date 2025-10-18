import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/constants/app_routes.dart';
import 'package:kemenhut_aren_flutter/ui/screens/_index.dart';
import 'package:kemenhut_aren_flutter/ui/screens/about/screen/about_screen.dart';

List<GetPage> pageRoutes = [
  GetPage(
    name: AppRoutes.root,
    page: () => const SplashScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.login,
    page: () => const LoginScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.home,
    page: () => const HomeScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.main,
    page: () => const MainScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.forgot,
    page: () => const ForgotScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.account,
    page: () => const AccountScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.about,
    page: () => const AboutScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.inventaris,
    page: () => const InventarisScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.serviceCenter,
    page: () => const ServiceCenterScreen(),
    transition: Transition.fadeIn,
  ),
];
