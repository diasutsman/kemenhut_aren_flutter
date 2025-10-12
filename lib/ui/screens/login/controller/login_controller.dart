// lib/controllers/login_controller.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kemenhut_aren_flutter/constants/_index.dart';

class LoginController extends GetxController {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _autoLoginIfAny();
  }

  Future<void> _autoLoginIfAny() async {
    final hasSession = await AppSettings.checkValidSession();
    if (hasSession) {
      await AppSettings.getSession();
      _gotoHome();
    }
  }

  String _encodeBase64(String v) {
    final bytes = utf8.encode(v);
    return base64Encode(bytes);
  }

  Future<void> login() async {
    final username = usernameCtrl.text.trim();
    final password = passwordCtrl.text;

    if (username.isEmpty) {
      Get.snackbar(
        'Info',
        'Harap mengisi username terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (password.isEmpty) {
      Get.snackbar(
        'Info',
        'Harap mengisi password terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final base64Username = _encodeBase64(username);
    final base64Pass = _encodeBase64(password);

    try {
      isLoading.value = true;

      final uri = Uri.parse(AppSettings.URL_LOGIN);
      final resp = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: {'username': base64Username, 'password': base64Pass},
          )
          .timeout(Duration(seconds: AppSettings.MAX_TIME_OUT));

      final body = resp.body;
      Map<String, dynamic> json;
      try {
        json = jsonDecode(body) as Map<String, dynamic>;
      } catch (_) {
        json = {};
      }

      print('login json: $json');

      final errCode = json['errCode'] ?? json['err_code'] ?? resp.statusCode;
      final errMsg = json['errMsg'] ?? json['err_msg'] ?? 'Login gagal';

      print('login errCode: $errCode');
      print('login errMsg: $errMsg');

      if (errCode == AppSettings.SUCCESS_CODE) {
        final Map<String, dynamic> u =
            (json['user'] ?? {}) as Map<String, dynamic>;

        // The Java code stored these fields; we mirror them (use empty defaults if missing)
        final userID =
            (u['userid'] ?? u['userID'] ?? u['USERID'] ?? '').toString();
        final roleNm =
            (u['ROLENM'] ?? u['rolenm'] ?? u['roleNm'] ?? '').toString();
        final position = (u['POSITION'] ?? u['position'] ?? '').toString();
        final usernamePlain = (u['username'] ?? u['USERNAME'] ?? '').toString();
        final nama =
            (u['NAMA'] ?? u['nama'] ?? u['first_name'] ?? '').toString();
        final photo = (u['photo'] ?? u['PHOTO'] ?? '').toString();
        final email = (u['email'] ?? u['EMAIL'] ?? '').toString();
        final adminID =
            (u['adminid'] ?? u['adminID'] ?? u['ADMINID'] ?? '').toString();

        // Partner fields were empty strings in your Java example
        const code = '';
        const partnerID = '';
        const partnerName = '';

        print(
          "userID: $userID\n"
          "roleNm: $roleNm\n"
          "position: $position\n"
          "usernamePlain: $usernamePlain\n"
          "nama: $nama\n"
          "photo: $photo\n"
          "email: $email\n"
          "adminID: $adminID\n"
          "code: $code\n"
          "partnerID: $partnerID\n"
          "partnerName: $partnerName",
        );

        await AppSettings.createSession(
          userID,
          userID, // empID mirrored as userID like original
          roleNm,
          position,
          partnerID,
          code,
          partnerName,
          usernamePlain,
          nama,
          photo,
          email,
          "",
          "",
          "",
          adminID,
        );

        isLoading.value = false;
        _gotoHome();
      } else {
        isLoading.value = false;
        Get.snackbar('Error', errMsg, snackPosition: SnackPosition.BOTTOM);
      }
    } on TimeoutException {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error, Periksa Koneksi Jaringan Internet Anda',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on http.ClientException catch (_) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error, Tidak dapat terhubung ke Server',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, st) {
      isLoading.value = false;
      print('login error: $e, $st');
      Get.snackbar('Error', 'Error: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void gotoForgot() {
    // Get.to(() => const ForgotScreen());
    Get.offAndToNamed(AppRoutes.forgot);
  }

  void _gotoHome() {
    Get.offAndToNamed(AppRoutes.main);
  }

  @override
  void onClose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
