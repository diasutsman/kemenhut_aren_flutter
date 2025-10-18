import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';
import 'package:kemenhut_aren_flutter/ui/screens/account/model/user_profile.dart';
import 'package:url_launcher/url_launcher.dart';

class UserController extends GetxController {
  UserController({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  final isLoading = false.obs;
  final isOffline = false.obs;
  final profile = Rxn<UserProfile>();
  final targetUserId = ''.obs;
  StreamSubscription<InternetStatus>? _connectionSub;

  bool get canEdit =>
      targetUserId.value.isEmpty || targetUserId.value == AppSettings.userID;

  @override
  void onInit() {
    super.onInit();
    _initConnectivityWatcher();
    final args = Get.arguments;
    if (args is Map && args['id'] != null) {
      targetUserId.value = args['id'].toString();
    } else if (Get.parameters['id'] != null) {
      targetUserId.value = Get.parameters['id']!;
    } else {
      targetUserId.value = AppSettings.userID;
    }
    loadUserData();
  }

  @override
  void onClose() {
    _connectionSub?.cancel();
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

  Future<void> loadUserData() async {
    final id =
        targetUserId.value.isEmpty ? AppSettings.userID : targetUserId.value;
    if (id.isEmpty) {
      Get.snackbar('Error', 'User tidak ditemukan.');
      return;
    }

    isLoading.value = true;
    update();

    try {
      final response = await _dio.post(
        AppSettings.URL_VIEW_PROFILE,
        data: FormData.fromMap({'userID': id}),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      Map<String, dynamic>? jsonMap;
      final raw = response.data;
      if (raw is Map<String, dynamic>) {
        jsonMap = raw;
      } else if (raw is String) {
        try {
          jsonMap = jsonDecode(raw) as Map<String, dynamic>;
        } catch (_) {
          jsonMap = null;
        }
      }

      if (jsonMap == null) {
        Get.snackbar('Error', 'Respon tidak valid dari server');
        return;
      }

      final result = UserProfileResponse.fromJson(jsonMap);
      if (result.errorCode == AppSettings.SUCCESS_CODE && result.user != null) {
        profile.value = result.user;
        update();
        if (canEdit) {
          AppSettings.createSession(
            result.user!.userId,
            result.user!.userId,
            result.user!.roleName,
            result.user!.position,
            '',
            '',
            '',
            result.user!.userName,
            result.user!.fullName,
            result.user!.photo,
            result.user!.email,
            '',
            '',
            '',
            AppSettings.adminID,
          );
        }
      } else {
        final msg =
            result.errorMessage.isEmpty
                ? 'Gagal memuat data pengguna.'
                : result.errorMessage;
        Get.snackbar('Info', msg);
      }
    } catch (e) {
      Get.snackbar('Error', 'Tidak dapat memuat data pengguna: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> refreshData() async {
    await loadUserData();
  }

  void onShowPhoto() {
    final photoUrl = profile.value?.photo;
    if (photoUrl == null || photoUrl.isEmpty) return;

    Get.dialog(
      Dialog(
        child: InteractiveViewer(
          child: Image.network(photoUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }

  void onChangePhoto() {
    if (!canEdit) return;
    Get.snackbar('Info', 'Fitur unggah foto belum tersedia di Flutter.');
  }

  Future<void> onCall() async {
    final phone = profile.value?.phone ?? '';
    if (phone.isEmpty) {
      Get.snackbar('Info', 'Nomor telepon belum tersedia.');
      return;
    }
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Tidak dapat membuka aplikasi telepon.');
    }
  }

  Future<void> onMessage() async {
    final phone = profile.value?.phone ?? '';
    if (phone.isEmpty) {
      Get.snackbar('Info', 'Nomor telepon belum tersedia.');
      return;
    }
    final uri = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Tidak dapat membuka aplikasi pesan.');
    }
  }

  void onEditField(String field) {
    if (!canEdit) return;
    if (profile.value == null) {
      Get.snackbar('Info', 'Data pengguna belum siap.');
      return;
    }
    Get.toNamed(
      AppRoutes.editUser,
      arguments: {'field': field, 'profile': profile.value},
    )?.then((_) => loadUserData());
  }
}
