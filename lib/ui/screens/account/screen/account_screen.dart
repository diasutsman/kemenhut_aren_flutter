// lib/ui/screens/account/screen/account_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/ui/screens/account/controller/account_controller.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(
      init: AccountController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFB7997A),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: Get.back,
            ),
          ),
          body: Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  _AccountMenuItem(
                    iconPath: 'assets/drawable/icon_account.png',
                    label: 'My Profile',
                    onTap: controller.gotoProfile,
                  ),
                  _AccountMenuItem(
                    iconPath: 'assets/drawable/icon_changepass.png',
                    label: 'Change Password',
                    onTap: controller.gotoChangePassword,
                  ),
                  _AccountMenuItem(
                    iconPath: 'assets/drawable/icon_logout.png',
                    label: 'Sign Out',
                    onTap: controller.logout,
                  ),
                ],
              ),
              Obx(
                () => Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Visibility(
                    visible: controller.isOffline.value,
                    child: const _NoConnectivityBanner(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AccountMenuItem extends StatelessWidget {
  const _AccountMenuItem({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
          ),
          child: Row(
            children: [
              Image.asset(
                iconPath,
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoConnectivityBanner extends StatelessWidget {
  const _NoConnectivityBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      color: const Color(0xFFD62E49),
      child: const Text(
        'No Internet Connection',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
