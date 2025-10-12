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
      builder: (ctl) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'My Account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFB7997A), // brown tone
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: Get.back,
            ),
          ),
          body: Column(
            children: [
              _AccountItem(
                icon: 'assets/drawable/icon_account.png',
                label: 'My Profile',
                onTap: ctl.gotoProfile,
              ),
              _AccountItem(
                icon: 'assets/drawable/icon_changepass.png',
                label: 'Change Password',
                onTap: ctl.gotoChangePassword,
              ),
              _AccountItem(
                icon: 'assets/drawable/icon_logout.png',
                label: 'Sign Out',
                onTap: ctl.logout,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AccountItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _AccountItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black12, width: 1),
          ),
        ),
        child: Row(
          children: [
            Image.asset(icon, width: 30, height: 30),
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
    );
  }
}
