// lib/ui/screens/profile/screen/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/ui/screens/_index.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (ctl) {
        return Container(
          color: const Color(0xFFF5ECE4),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ======= Header =======
                Stack(
                  children: [
                    Image.asset(
                      'assets/drawable/profilebg.jpg',
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: ctl.showProfileImage,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child:
                                    ctl.userPhoto.value.isNotEmpty
                                        ? Image.network(
                                          ctl.userPhoto.value,
                                          width: 72,
                                          height: 72,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (ctx, err, _) => Image.asset(
                                                'assets/drawable/default_user_icon.png',
                                                width: 72,
                                                height: 72,
                                              ),
                                        )
                                        : Image.asset(
                                          'assets/drawable/default_user_icon.png',
                                          width: 72,
                                          height: 72,
                                        ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ctl.userName.value.isNotEmpty
                                        ? ctl.userName.value
                                        : "Guest",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    ctl.userRole.value.isNotEmpty
                                        ? ctl.userRole.value
                                        : "Visitor",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (ctl.showLogin.value)
                              GestureDetector(
                                onTap: ctl.gotoLogin,
                                child: Container(
                                  width: 90,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE27D2B),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom stats
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: const Text(
                                "Finished",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 20,
                            color: Colors.white.withOpacity(0.95),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: const Text(
                                "On Progress",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ======= Account Section =======
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      _ProfileMenuItem(
                        iconPath: 'assets/drawable/icon_pick_hist.png',
                        title: 'My Report',
                        onTap: ctl.gotoInvHist,
                      ),
                      Container(width: 1, height: 70, color: Colors.black12),
                      _ProfileMenuItem(
                        iconPath: 'assets/drawable/account_icon.png',
                        title: 'Account',
                        onTap: ctl.gotoAccount,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ======= Info List =======
                _InfoRow(
                  leading: 'assets/drawable/logo.png',
                  title: 'SIKAP-AREN v0.8.1',
                  subtitle: 'Openly customized just for your needs',
                  onTap: ctl.gotoTerms,
                ),
                _InfoRow(
                  leading: 'assets/drawable/rounded_logo.png',
                  title: 'About Kementerian Kehutanan RI',
                  subtitle:
                      'Get information about Kementerian Kehutanan Republik Indonesia',
                  onTap: ctl.gotoAbout,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(iconPath, width: 40, height: 40),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String leading;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.leading,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Image.asset(leading, width: 40, height: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.3,
                    ),
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
