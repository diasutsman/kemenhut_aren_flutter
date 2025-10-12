import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/constants/app_routes.dart';
import 'package:kemenhut_aren_flutter/ui/screens/_index.dart';

List<GetPage> pageRoutes = [
  //
  // general
  //
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
];
