// lib/ui/screens/profile/controller/profile_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';

class ProfileController extends GetxController {
  final userName = ''.obs;
  final userRole = ''.obs;
  final userPhoto = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    // Mocked from Settings.account (replace with real session if needed)
    AppSettings.getSession().then((account) {
      userName.value = account.username;
      userRole.value = account.partnerLevel;
      userPhoto.value = account.photo;
    });
  }

  void gotoInvHist() {
    Get.snackbar('Navigate', 'Opening My Report page...');
  }

  void gotoAccount() {
    Get.toNamed(AppRoutes.account);
  }

  void gotoPerformance() {
    // intentionally left empty
  }

  void gotoAbout() {
    Get.toNamed(AppRoutes.about);
  }

  void gotoTerms() {
    Get.snackbar('Navigate', 'Opening Terms & Conditions...');
  }

  void gotoLogin() {
    Get.snackbar('Navigate', 'Opening Login Page...');
  }
}
