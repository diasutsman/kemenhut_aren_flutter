import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';
// import 'package:kemenhut_aren_flutter/modules/_index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final BuildContext context;
  SplashController(this.context);

  RxBool isFirstOpen = RxBool(true);
  // final _authController = Get.find<AuthenticationController>();

  @override
  void onInit() {
    checkFirstOpen();
    super.onInit();
  }

  Future<void> checkFirstOpen() async {
    final prefs = await SharedPreferences.getInstance();
    isFirstOpen.value = prefs.getBool(PrefsKey.firstOpen) ?? true;

    // await _authController.checkCurrentUser();
    await Future.delayed(const Duration(seconds: 2));

    // if (_authController.currentUser.value != null) {
    //   Get.offAndToNamed(AppRoutes.home);
    // } else {
    Get.offAndToNamed(AppRoutes.login);
    // }
  }
}
