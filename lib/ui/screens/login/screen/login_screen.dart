import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/ui/screens/login/controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const Color _buttonGreen = Color(0xFF79C3A0);
  static const Color _dividerColor = Color(0xFFBDBDBD);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            top: false,
            child: Stack(
              children: [
                Column(
                  children: [
                    const _LoginHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 32),
                            _InputWithLeftIcon(
                              controller: controller.usernameCtrl,
                              hintText: 'Username / Email..',
                              assetIcon: 'assets/drawable/email_icon.png',
                            ),
                            const SizedBox(height: 16),
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                _InputWithLeftIcon(
                                  controller: controller.passwordCtrl,
                                  hintText: 'Password..',
                                  assetIcon: 'assets/drawable/lock_icon.png',
                                  obscure: true,
                                  contentPaddingRight: 90,
                                ),
                                TextButton(
                                  onPressed: controller.gotoForgot,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    'Forgot ?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4EAA84),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: controller.login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _buttonGreen,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: const Text('Sign In'),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: _dividerColor,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'Account is given by Administrator',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: _dividerColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 120 + bottomPadding),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: bottomPadding + 24,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Don't have account ?",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Contact Admin',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF4EAA84),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => controller.isLoading.value
                      ? Container(
                          color: Colors.black.withOpacity(0.25),
                          child: const Center(
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: CircularProgressIndicator(strokeWidth: 4),
                            ),
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

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/drawable/bg_packaging.png',
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Image.asset(
                'assets/drawable/logo.png',
                width: 200,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputWithLeftIcon extends StatelessWidget {
  const _InputWithLeftIcon({
    required this.controller,
    required this.hintText,
    required this.assetIcon,
    this.obscure = false,
    this.contentPaddingRight = 16,
  });

  final TextEditingController controller;
  final String hintText;
  final String assetIcon;
  final bool obscure;
  final double contentPaddingRight;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(start: 12, end: 10),
          child: Image.asset(
            assetIcon,
            width: 22,
            height: 22,
            fit: BoxFit.contain,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        contentPadding: EdgeInsets.fromLTRB(16, 14, contentPaddingRight, 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF8BC34A)),
        ),
      ),
    );
  }
}
