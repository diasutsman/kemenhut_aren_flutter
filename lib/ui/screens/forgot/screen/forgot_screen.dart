// lib/screen/forgot_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';
import 'package:kemenhut_aren_flutter/ui/screens/forgot/controller/forgot_controller.dart';

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({super.key});

  static const Color _buttonGreen = Color(0xFF79C3A0);
  static const Color _textGray = Color(0xFF616161);
  static const Color _badgeGreen = Color(0xFF4CAF50);
  static const Color _badgeRed = Color(0xFFD32F2F);
  static const Color _borderColor = Color(0xFFCCCCCC);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return GetBuilder<ForgotController>(
      init: ForgotController(),
      builder: (controller) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Obx(
              () => AppBar(
                title: Text(
                  controller.hasAccount.value
                      ? 'Account Confirmation'
                      : 'Forgot Password',
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            top: false,
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              constraints.maxHeight -
                              bottomPadding -
                              56, // space for footer
                        ),
                        child: Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 32),
                              const Text(
                                'What is your username or email ?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Please tell us your username or email help us to identify your account.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _textGray,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextField(
                                controller: controller.accountCtrl,
                                decoration: InputDecoration(
                                  hintText: 'Your Email / Username..',
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: _borderColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: _borderColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: _buttonGreen,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                height: 54,
                                child: ElevatedButton.icon(
                                  onPressed: controller.checkAccount,
                                  icon: const Icon(Icons.search, size: 20),
                                  label: const Text(
                                    'Look for your account',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _buttonGreen,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              if (controller.hasAccount.value)
                                _AccountPanel(controller: controller),
                              SizedBox(height: 120 + bottomPadding),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: bottomPadding + 24,
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          "Don't have account ?",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Contact Admin',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: _buttonGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () =>
                      controller.isLoading.value
                          ? Container(
                            color: Colors.black.withOpacity(0.25),
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AccountPanel extends StatelessWidget {
  const _AccountPanel({required this.controller});

  final ForgotController controller;

  static const Color _panelBorder = Color(0xFFBDBDBD);
  static const Color _badgeGreen = Color(0xFF4CAF50);
  static const Color _badgeRed = Color(0xFFD32F2F);
  static const Color _textGray = Color(0xFF616161);
  static const Color _buttonGreen = Color(0xFF79C3A0);

  @override
  Widget build(BuildContext context) {
    final isActive = controller.userActive.value == AppSettings.STS_ACTIVE_S;
    final statusText =
        isActive
            ? AppSettings.STS_ACTIVE_TEXT
            : AppSettings.STS_NON_ACTIVE_TEXT;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _panelBorder),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  border: Border(
                    bottom: BorderSide(color: _panelBorder.withOpacity(0.6)),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 72,
                        height: 72,
                        child:
                            controller.userPhoto.value.isNotEmpty
                                ? Image.network(
                                  controller.userPhoto.value,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => Image.asset(
                                        'assets/drawable/default_user_icon.png',
                                        fit: BoxFit.cover,
                                      ),
                                )
                                : Image.asset(
                                  'assets/drawable/default_user_icon.png',
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  controller.userName.value,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive ? _badgeGreen : _badgeRed,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  statusText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            controller.userEmail.value,
                            style: const TextStyle(
                              color: _textGray,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: _panelBorder.withOpacity(0.6)),
                  ),
                ),
                child: Row(
                  children: const [
                    Checkbox(
                      value: true,
                      onChanged: null,
                      activeColor: _buttonGreen,
                    ),
                    Expanded(
                      child: Text(
                        'Kirimkan kata sandi baru ke email anda',
                        style: TextStyle(color: _textGray),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.sendForgot,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text(
                      'Lanjutkan kirim',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _buttonGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
