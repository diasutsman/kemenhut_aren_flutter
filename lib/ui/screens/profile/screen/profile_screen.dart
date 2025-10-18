// lib/ui/screens/profile/screen/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (ctl) {
        return Container(
          color: const Color(0xFFF5ECE4), // beige background
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(ctl),
                _buildMenuSection(ctl),
                const SizedBox(height: 12),
                _buildInfoCard(
                  image: 'assets/drawable/logo_pnp.png',
                  title: 'SIKAP-AREN v0.8.1',
                  subtitle: 'Openly customized just for your needs',
                  onTap: ctl.gotoTerms,
                ),
                _buildInfoCard(
                  image: 'assets/drawable/rounded_logo.png',
                  title: 'About Kementerian Kehutanan RI',
                  subtitle: 'Get information about Kementerian Kehutanan RI',
                  onTap: ctl.gotoAbout,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ProfileController ctl) {
    return Stack(
      children: [
        Image.asset(
          'assets/drawable/profilebg.jpg',
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                ClipOval(
                  child: Obx(
                    () =>
                        ctl.userPhoto.value.isNotEmpty
                            ? Image.network(
                                ctl.userPhoto.value,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/drawable/default_user_icon.png',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                'assets/drawable/default_user_icon.png',
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ctl.userName.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ctl.userRole.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(ProfileController ctl) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _MenuButton(
            title: 'My Report',
            icon: 'assets/drawable/icon_pick_hist.png',
            onTap: ctl.gotoInvHist,
          ),
          _MenuButton(
            title: 'Account',
            icon: 'assets/drawable/account_icon.png',
            onTap: ctl.gotoAccount,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String image,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Image.asset(image, width: 40, height: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const _MenuButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(icon, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
