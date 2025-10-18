import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/ui/screens/account/controller/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordController>(
      init: ChangePasswordController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Change Password',
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
                padding: const EdgeInsets.all(16),
                children: [
                  _Section(
                    title: 'Kata Sandi Lama',
                    child: _PasswordField(
                      controller: controller.oldPasswordCtrl,
                      hint: 'Kata Kunci Lama..',
                    ),
                  ),
                  _Section(
                    title: 'Kata Sandi Baru',
                    subtitle:
                        'Password baru harus minimal 6 karakter dan mengandung huruf serta angka.',
                    child: _PasswordField(
                      controller: controller.newPasswordCtrl,
                      hint: 'Kata Kunci Baru..',
                    ),
                  ),
                  _Section(
                    title: 'Konfirmasi',
                    child: _PasswordField(
                      controller: controller.confirmPasswordCtrl,
                      hint: 'Konfirmasi..',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: controller.isLoading.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.lock_outline),
                        label: const Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4D918E),
                        ),
                        onPressed:
                            controller.isLoading.value ? null : controller.submit,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
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
              Obx(
                () => controller.isLoading.value
                    ? const _LoadingOverlay()
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    this.subtitle,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.hint,
  });

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
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

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.05),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB7997A)),
        ),
      ),
    );
  }
}
