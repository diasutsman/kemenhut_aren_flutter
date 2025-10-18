import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';

class ChangePasswordController extends GetxController {
  ChangePasswordController({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  final oldPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final isLoading = false.obs;
  final isOffline = false.obs;
  StreamSubscription<InternetStatus>? _connectionSub;

  @override
  void onInit() {
    super.onInit();
    _initConnectivityWatcher();
  }

  @override
  void onClose() {
    _connectionSub?.cancel();
    oldPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }

  Future<void> _initConnectivityWatcher() async {
    final checker = InternetConnection();
    final hasConnection = await checker.hasInternetAccess;
    isOffline.value = !hasConnection;
    update();
    _connectionSub = checker.onStatusChange.listen((status) {
      isOffline.value = status == InternetStatus.disconnected;
      update();
    });
  }

  Future<void> submit() async {
    if (isOffline.value) {
      Get.snackbar('Info', 'Tidak ada koneksi internet.');
      return;
    }

    final oldPwd = oldPasswordCtrl.text.trim();
    final newPwd = newPasswordCtrl.text.trim();
    final confirmPwd = confirmPasswordCtrl.text.trim();

    if (oldPwd.isEmpty) {
      Get.snackbar('Info', 'Harap mengisi password lama terlebih dahulu.');
      return;
    }
    if (newPwd.isEmpty) {
      Get.snackbar('Info', 'Harap mengisi password baru terlebih dahulu.');
      return;
    }
    if (newPwd.length < 6) {
      Get.snackbar(
        'Info',
        'Password baru harus mengandung minimal 6 karakter.',
      );
      return;
    }
    if (!_isAlphaNum(newPwd)) {
      Get.snackbar('Info', 'Password baru harus mengandung huruf dan angka.');
      return;
    }
    if (confirmPwd != newPwd) {
      Get.snackbar(
        'Info',
        'Konfirmasi password harus sama dengan password baru.',
      );
      return;
    }

    await _changePassword(oldPwd, newPwd, confirmPwd);
  }

  bool _isAlphaNum(String value) {
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasDigit = RegExp(r'[0-9]').hasMatch(value);
    return hasLetter && hasDigit;
  }

  Future<void> _changePassword(
    String oldPwd,
    String newPwd,
    String confirmPwd,
  ) async {
    if (AppSettings.userID.isEmpty) {
      Get.snackbar('Error', 'Session tidak valid.');
      return;
    }

    try {
      isLoading.value = true;
      update();

      final response = await _dio.post(
        AppSettings.URL_CHANGE_PASSWORD,
        data: FormData.fromMap({
          'userID': AppSettings.userID,
          'oldpwd': oldPwd,
          'newpwd': newPwd,
          'confirm': confirmPwd,
        }),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      Map<String, dynamic>? jsonMap;
      final raw = response.data;
      if (raw is Map<String, dynamic>) {
        jsonMap = raw;
      } else if (raw is String) {
        jsonMap = jsonDecode(raw) as Map<String, dynamic>?;
      }

      int? errCode;
      String errMsg = '';
      if (jsonMap != null) {
        final code = jsonMap['err_code'] ?? jsonMap['errCode'];
        if (code is int) {
          errCode = code;
        } else if (code is String) {
          errCode = int.tryParse(code);
        }
        errMsg = (jsonMap['err_msg'] ?? jsonMap['errMsg'])?.toString() ?? '';
      }

      if (errCode == AppSettings.SUCCESS_CODE) {
        Get.snackbar('Sukses', 'Kata kunci berhasil diganti.');
        Get.back();
      } else {
        final message = errMsg.isEmpty ? 'Gagal mengganti kata kunci.' : errMsg;
        Get.snackbar('Gagal', message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Tidak dapat mengganti kata kunci: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
