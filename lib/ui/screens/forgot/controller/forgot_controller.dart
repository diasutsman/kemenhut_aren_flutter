import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';

class ForgotController extends GetxController {
  final accountCtrl = TextEditingController();

  final isLoading = false.obs;
  final hasAccount = false.obs;

  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhoto = ''.obs;
  final userActive = ''.obs;
  final userId = ''.obs;

  late Dio _dio;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = false;
    hasAccount.value = false;
    _dio = Dio(
      BaseOptions(
        baseUrl: AppSettings.URL_BASE,
        headers: {'Content-Type': Headers.formUrlEncodedContentType},
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  Future<void> checkAccount() async {
    final account = accountCtrl.text.trim();
    if (account.isEmpty) {
      Get.snackbar(
        'Info',
        'Please fill your user account first.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    hasAccount.value = false;

    try {
      final response = await _dio.post(
        'login/forgot',
        data: {'account': account},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      // response.data might be already a Map or a JSON string
      final dynamic resData = response.data;
      Map<String, dynamic> json;
      if (resData is String) {
        json = jsonDecode(resData);
      } else if (resData is Map<String, dynamic>) {
        json = resData;
      } else {
        json = {};
      }

      // Check for both key naming conventions
      final errCode =
          json['err_code'] ?? json['errCode'] ?? response.statusCode ?? 0;

      if (errCode == AppSettings.SUCCESS_CODE) {
        final u = json['user'] as Map<String, dynamic>? ?? {};

        // Use uppercase or lowercase keys, whichever is present
        userId.value =
            (u['USERID'] ?? u['userid'] ?? u['userId'] ?? '').toString();
        userName.value = (u['NAMA'] ?? u['nama'] ?? u['name'] ?? '').toString();
        userEmail.value = (u['EMAIL'] ?? u['email'] ?? '').toString();
        userPhoto.value = (u['PHOTO'] ?? u['photo'] ?? '').toString();
        userActive.value = (u['ACTIVE'] ?? u['active'] ?? '').toString();

        hasAccount.value = true;
      } else {
        Get.snackbar(
          'Not Found',
          'Account not found!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (dioError) {
      String msg = 'Failed to connect to server';
      if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.receiveTimeout ||
          dioError.type == DioExceptionType.sendTimeout) {
        msg = 'Connection timed out';
      } else if (dioError.response != null) {
        msg = 'Server error: ${dioError.response?.statusCode}';
      }
      Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unexpected error: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendForgot() async {
    if (userId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'No user found to send password reset.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _dio.post(
        'login/confirm_forgot',
        data: {'userID': userId.value},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final dynamic resData = response.data;
      Map<String, dynamic> json;
      if (resData is String) {
        json = jsonDecode(resData);
      } else if (resData is Map<String, dynamic>) {
        json = resData;
      } else {
        json = {};
      }

      final errCode =
          json['err_code'] ?? json['errCode'] ?? response.statusCode ?? 0;

      if (errCode == AppSettings.SUCCESS_CODE) {
        Get.snackbar(
          'Success',
          'New password has been sent, please check your email.',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          'Error when sending new password!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (dioError) {
      String msg = 'Failed to send request';
      if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.receiveTimeout ||
          dioError.type == DioExceptionType.sendTimeout) {
        msg = 'Connection timed out';
      } else if (dioError.response != null) {
        msg = 'Server error: ${dioError.response?.statusCode}';
      }
      Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unexpected error: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    accountCtrl.dispose();
    super.onClose();
  }
}
