// lib/ui/screens/profile/controller/profile_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';

class ProfileController extends GetxController {
  // User info
  final userName = ''.obs;
  final userRole = ''.obs;
  final userPhoto = ''.obs;
  final showLogin = false.obs;
  final hasSession = false.obs;

  final dio = Dio(BaseOptions(connectTimeout: Duration(seconds: 15)));

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  /// Initialize user data (check session & load)
  Future<void> initialize() async {
    final valid = await AppSettings.checkValidSession();
    hasSession.value = valid;
    if (valid) {
      final acc = await AppSettings.getSession();
      userName.value = acc.firstName.isNotEmpty ? acc.firstName : acc.username;
      userRole.value = acc.partnerLevel;
      userPhoto.value = acc.photo;
      showLogin.value = false;
    } else {
      userName.value = '';
      userRole.value = '';
      userPhoto.value = '';
      showLogin.value = true;
    }
  }

  /// Simulate navigation (replace with Get.toNamed if using routing)
  void gotoAccount() => Get.toNamed(AppRoutes.account);

  void gotoInvHist() => Get.snackbar('Navigate', 'Opening My Report Page...');
  void gotoPerformance() =>
      Get.snackbar('Navigate', 'Opening Performance Page...');
  void gotoAbout() =>
      Get.snackbar('Navigate', 'Opening About Kementerian Kehutanan...');
  void gotoTerms() => Get.snackbar('Navigate', 'Opening Terms...');
  void gotoLogin() => Get.offAllNamed('/login');

  void showProfileImage() {
    if (hasSession.value && userPhoto.value.isNotEmpty) {
      Get.defaultDialog(
        title: "My Image",
        content: Image.network(
          userPhoto.value,
          errorBuilder:
              (ctx, err, _) => Image.asset(
                'assets/drawable/default_user_icon.png',
                width: 100,
                height: 100,
              ),
        ),
      );
    }
  }
}
