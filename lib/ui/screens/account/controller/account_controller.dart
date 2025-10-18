// lib/ui/screens/account/controller/account_controller.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';

class AccountController extends GetxController {
  final isOffline = false.obs;
  StreamSubscription<InternetStatus>? _connectionSub;

  @override
  void onInit() {
    super.onInit();
    _initConnectivityWatcher();
  }

  @override
  void onClose() {
    _connectionSub?.cancel();
    super.onClose();
  }

  Future<void> _initConnectivityWatcher() async {
    final checker = InternetConnection();
    final hasConnection = await checker.hasInternetAccess;
    isOffline.value = !hasConnection;
    update();
    _connectionSub = checker.onStatusChange.listen((status) {
      isOffline.value = status == InternetStatus.disconnected;
      update();
    });
  }

  void gotoProfile() {
    Get.toNamed(AppRoutes.userDetail);
  }

  void gotoChangePassword() {
    Get.toNamed(AppRoutes.changePassword);
  }

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        content: const Text('Are you sure want to logout ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('NO', style: TextStyle(color: Color(0xFF2E7D32))),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'YES',
              style: TextStyle(color: Color(0xFF2E7D32)),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (confirmed == true) {
      await AppSettings.destroySession();
      await AppSettings.destroyFcmToken();
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
