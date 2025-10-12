// lib/screen/forgot_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';
import 'package:kemenhut_aren_flutter/ui/screens/_index.dart';

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const greenColor = Color(0xFF79C3A0);
    const grayText = Color(0xFF616161);
    const redColor = Color(0xFFD32F2F);
    const greenBadge = Color(0xFF388E3C);

    return GetBuilder(
      init: ForgotController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Forgot Password"),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.defaultDialog(
                  title: "Cancel",
                  middleText: "Do you want to cancel this forgot password?",
                  textConfirm: "Yes",
                  textCancel: "No",
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    controller.hasAccount.value = false;
                    controller.accountCtrl.clear();
                    Get.offAndToNamed(AppRoutes.login);
                  },
                );
              },
            ),
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // pnlForgot
                      if (!controller.hasAccount.value)
                        Column(
                          children: [
                            const SizedBox(height: 24),
                            const Text(
                              "Forgot Your Password?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Please enter your registered username or email below.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: grayText, fontSize: 15),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: controller.accountCtrl,
                              decoration: InputDecoration(
                                hintText: "Your Email / Username..",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: controller.checkAccount,
                                icon: const Icon(Icons.search),
                                label: const Text(
                                  "Look for your account",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: greenColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                      // pnlAccount
                      if (controller.hasAccount.value)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.grey.shade300,
                                    backgroundImage:
                                        controller.userPhoto.value
                                                    .toLowerCase()
                                                    .endsWith(".jpg") ||
                                                controller.userPhoto.value
                                                    .toLowerCase()
                                                    .endsWith(".png")
                                            ? NetworkImage(
                                              controller.userPhoto.value,
                                            )
                                            : const AssetImage(
                                                  'assets/drawable/default_user_icon.png',
                                                )
                                                as ImageProvider,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              controller.userName.value,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    controller
                                                                .userActive
                                                                .value ==
                                                            AppSettings
                                                                .STS_ACTIVE_S
                                                        ? greenBadge
                                                        : redColor,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                controller.userActive.value ==
                                                        AppSettings.STS_ACTIVE_S
                                                    ? AppSettings
                                                        .STS_ACTIVE_TEXT
                                                    : AppSettings
                                                        .STS_NON_ACTIVE_TEXT,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          controller.userEmail.value,
                                          style: const TextStyle(
                                            color: grayText,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Checkbox(
                                  value: true,
                                  onChanged: null,
                                  activeColor: greenColor,
                                ),
                                const Expanded(
                                  child: Text(
                                    "Kirimkan kata sandi baru ke email anda",
                                    style: TextStyle(color: grayText),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: controller.sendForgot,
                                icon: const Icon(Icons.check_circle_outline),
                                label: const Text(
                                  "Lanjutkan kirim",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: greenColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                }),
              ),

              // ======= Loading overlay =======
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
        );
      },
    );
  }
}
