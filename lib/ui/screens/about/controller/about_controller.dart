// lib/ui/screens/account/controller/account_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';

class AboutController extends GetxController {
  /// Navigate to My Profile screen
  void gotoProfile() {
    Get.snackbar('Navigate', 'Opening My Profile...');
    // Get.toNamed(AppRoutes.profileDetail);
  }

  /// Navigate to Change Password screen
  void gotoChangePassword() {
    Get.snackbar('Navigate', 'Opening Change Password...');
    // Get.toNamed(AppRoutes.changePassword);
  }

  /// Log out with confirmation dialog
  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content:
            const Text('Are you sure you want to sign out from this account?'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await AppSettings.destroySession();
              Get.offAllNamed(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE27D2B),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
