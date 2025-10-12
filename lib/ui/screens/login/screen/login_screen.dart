// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/ui/screens/_index.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors and sizes chosen to match the XML & screenshot
    final theme = Theme.of(context);
    const greenButton = Color(0xFF79C3A0); // soft green per screenshot
    const darkGray = Color(0xFF9E9E9E);

    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // ======= Header (FrameLayout with background & logo) =======
              SizedBox(
                width: double.infinity,
                height: 320,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image that resembles "bg_packaging" (sand + palms)
                    Image.asset(
                      'assets/drawable/bg_packaging.png', // provide your own image
                      fit: BoxFit.cover,
                    ),
                    // Logo centered at top
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 72),
                        child: Image.asset(
                          'assets/drawable/logo_pnp.png', // provide your logo
                          width: 160,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ======= Form Panel =======
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 350),
                    // pnlLogin
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Username
                          _InputWithLeftIcon(
                            controller: controller.usernameCtrl,
                            hintText: 'Username / Email..',
                            assetIcon: 'assets/drawable/email_icon.png',
                          ),
                          const SizedBox(height: 12),
                          // Password + "Forgot ?"
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              _InputWithLeftIcon(
                                controller: controller.passwordCtrl,
                                hintText: 'Password..',
                                assetIcon: 'assets/drawable/lock_icon.png',
                                obscure: true,
                                contentPaddingRight: 84,
                              ),
                              TextButton(
                                onPressed: controller.gotoForgot,
                                child: const Text(
                                  'Forgot ?',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Sign In Button
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: controller.login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: greenButton,
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

                          const SizedBox(height: 16),

                          // Divider + "Sign in with" (matches XML; buttons not included)
                          Row(
                            children: [
                              Expanded(
                                child: Container(height: 1, color: darkGray),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'Account is given by Administrator',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Expanded(
                                child: Container(height: 1, color: darkGray),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),

              // ======= Footer: "Don't have account ?  Contact Admin" =======
              Positioned(
                bottom: 32,
                left: 20,
                right: 20,
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
                        child: Text(
                          'Contact Admin',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ======= Loading overlay (include/progress) =======
              Obx(
                () =>
                    controller.isLoading.value
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
        );
      },
    );
  }
}

// Matches the XML EditText + drawableLeft + rounded border
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
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
