import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';
import 'package:kemenhut_aren_flutter/ui/screens/account/model/user_profile.dart';

class EditUserController extends GetxController {
  EditUserController({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  final isLoading = false.obs;
  final isOffline = false.obs;
  final selectedGenderIndex = 0.obs;
  final field = ''.obs;

  final nameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final idCardCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  StreamSubscription<InternetStatus>? _connectionSub;
  List<String> get genderOptions => const ['Pria', 'Wanita'];

  bool get showName => field.value == AppSettings.FIELD_NAME;
  bool get showUsername => field.value == AppSettings.FIELD_USERNAME;
  bool get showIdCard => field.value == AppSettings.FIELD_IDCARD;
  bool get showAddress => field.value == AppSettings.FIELD_ADDRESS;
  bool get showEmail => field.value == AppSettings.FIELD_EMAIL;
  bool get showGender => field.value == AppSettings.FIELD_GENDER;
  bool get showPhone => field.value == AppSettings.FIELD_PHONE;

  @override
  void onInit() {
    super.onInit();
    _initConnectivityWatcher();
    final args = Get.arguments;
    if (args is Map && args['field'] != null) {
      field.value = args['field'].toString();
    }
    if (args is Map && args['profile'] is UserProfile) {
      _bindData(args['profile'] as UserProfile);
    } else {
      loadUserData();
    }
  }

  @override
  void onClose() {
    _connectionSub?.cancel();
    nameCtrl.dispose();
    usernameCtrl.dispose();
    idCardCtrl.dispose();
    addressCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
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
    isLoading.value = true;
    update();
    try {
      final response = await _dio.post(
        AppSettings.URL_VIEW_PROFILE,
        data: FormData.fromMap({'userID': AppSettings.userID}),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      Map<String, dynamic>? jsonMap;
      final raw = response.data;
      if (raw is Map<String, dynamic>) {
        jsonMap = raw;
      } else if (raw is String) {
        jsonMap = jsonDecode(raw) as Map<String, dynamic>?;
      }
      if (jsonMap == null) {
        Get.snackbar('Error', 'Respon tidak valid dari server');
        return;
      }
      final result = UserProfileResponse.fromJson(jsonMap);
      if (result.errorCode == AppSettings.SUCCESS_CODE && result.user != null) {
        _bindData(result.user!);
      } else {
        final msg =
            result.errorMessage.isEmpty
                ? 'Gagal memuat data pengguna.'
                : result.errorMessage;
        Get.snackbar('Info', msg);
      }
    } catch (e) {
      Get.snackbar('Error', 'Tidak dapat memuat data: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void _bindData(UserProfile profile) {
    nameCtrl.text = profile.fullName;
    usernameCtrl.text = profile.userName;
    idCardCtrl.text = profile.idCard;
    addressCtrl.text = profile.address;
    emailCtrl.text = profile.email;
    phoneCtrl.text = profile.phone;
    selectedGenderIndex.value =
        profile.gender.toLowerCase().contains('wanita') ? 1 : 0;
    update();
  }

  Future<void> submit() async {
    if (!_validate()) return;

    final gender = selectedGenderIndex.value == 0 ? 'L' : 'P';

    try {
      isLoading.value = true;
      update();

      final formData = FormData.fromMap({
        'userID': AppSettings.userID,
        'username': usernameCtrl.text.trim(),
        'nama': nameCtrl.text.trim(),
        'nohp': phoneCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'gender': gender,
        'address': addressCtrl.text.trim(),
        'idcard': idCardCtrl.text.trim(),
      });

      final response = await _dio.post(
        AppSettings.URL_EDIT_PROFILE,
        data: formData,
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
        Get.back(result: true);
        Get.snackbar(
          'Sukses',
          errMsg.isEmpty ? 'Data berhasil diperbarui.' : errMsg,
        );
      } else {
        Get.snackbar(
          'Gagal',
          errMsg.isEmpty ? 'Tidak dapat memperbarui data.' : errMsg,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Tidak dapat menyimpan data: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  bool _validate() {
    if (showName && nameCtrl.text.trim().isEmpty) {
      Get.snackbar('Info', 'Harap mengisi nama terlebih dahulu.');
      return false;
    }
    if (showEmail) {
      final email = emailCtrl.text.trim();
      if (email.isEmpty) {
        Get.snackbar('Info', 'Harap mengisi email terlebih dahulu.');
        return false;
      }
      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!emailRegex.hasMatch(email)) {
        Get.snackbar('Info', 'Format email tidak benar.');
        return false;
      }
    }
    if (showPhone) {
      final phone = phoneCtrl.text.trim();
      if (phone.length < 10) {
        Get.snackbar('Info', 'Nomor telepon minimal 10 karakter.');
        return false;
      }
    }
    if (showUsername) {
      final username = usernameCtrl.text.trim();
      if (username.isEmpty) {
        Get.snackbar('Info', 'Harap mengisi username terlebih dahulu.');
        return false;
      }
      if (username.length < 3) {
        Get.snackbar('Info', 'Username minimal 3 karakter.');
        return false;
      }
    }
    return true;
  }
}
