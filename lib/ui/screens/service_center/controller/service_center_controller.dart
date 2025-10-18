import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';

/// Mirrors `ServiceCenterActivity` from the legacy Android app.
class ServiceCenterController extends GetxController {
  ServiceCenterController({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  final searchCtrl = TextEditingController();
  final List<ServiceCenterItem> items = <ServiceCenterItem>[];

  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final isSearchActive = false.obs;

  String _keyword = '';
  bool _isFetching = false;

  @override
  void onInit() {
    super.onInit();
    fetchServiceCenters();
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }

  Future<void> fetchServiceCenters({bool showLoader = true}) async {
    if (_isFetching) return;
    _isFetching = true;

    if (showLoader && !isRefreshing.value) {
      isLoading.value = true;
    }
    update();

    try {
      final response = await _dio.get(
        AppSettings.URL_SERVICE_CENTER,
        queryParameters: {
          // Legacy Android increments `index` for endless scroll. Flutter migration
          // currently mirrors the first page only; extend when backend pagination is confirmed.
          'index': 0,
          'keyword': _keyword,
        },
      );

      final data = response.data;

      Iterable<dynamic> rawItems = const [];
      if (data is Map<String, dynamic>) {
        // Legacy Android relies on err_code to guard success.
        final errCode = data['err_code'] ?? data['errCode'] ?? response.statusCode;
        if (errCode == AppSettings.SUCCESS_CODE) {
          rawItems = (data['data'] as Iterable?) ?? const [];
        } else {
          final errMsg = data['err_msg'] ?? data['errMsg'] ?? 'Data tidak tersedia';
          items.clear();
          Get.snackbar(
            'Info',
            errMsg.toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
          update();
          return;
        }
      } else if (data is Iterable) {
        rawItems = data;
      } else {
        rawItems = const [];
      }

      items
        ..clear()
        ..addAll(
          rawItems
              .map<ServiceCenterItem?>((dynamic e) {
                if (e is ServiceCenterItem) return e;
                if (e is Map<String, dynamic>) {
                  return ServiceCenterItem.fromJson(e);
                }
                if (e is Map) {
                  return ServiceCenterItem.fromJson(Map<String, dynamic>.from(e));
                }
                return null;
              })
              .whereType<ServiceCenterItem>(),
        );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat memuat data service center: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
      _isFetching = false;
      update();
    }
  }

  Future<void> refreshItems() async {
    if (_isFetching) return;
    isRefreshing.value = true;
    update();
    await fetchServiceCenters(showLoader: false);
  }

  void startSearch() {
    isSearchActive.value = true;
    update();
  }

  void stopSearch() {
    isSearchActive.value = false;
    searchCtrl.clear();
    onSearchChanged('');
  }

  void onSearchChanged(String value) {
    _keyword = value.trim();
    fetchServiceCenters();
  }

  Future<void> removeItem(
    BuildContext context,
    ServiceCenterItem item,
    int index,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final removedIndex = index.clamp(0, items.length);
    final removedItem = item;

    if (removedIndex >= items.length) return;

    items.removeAt(removedIndex);
    update();

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.black87,
        content: Text(
          '${removedItem.supplierName} removed from list!',
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFFD62E49),
          onPressed: () {
            restoreItem(context, removedItem, removedIndex, showSnackBar: false);
          },
        ),
      ),
    );

    try {
      await _dio.post(
        AppSettings.URL_AREN_REMOVE,
        data: {'id': removedItem.idSupplier},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
    } catch (e) {
      items.insert(removedIndex, removedItem);
      update();
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.black87,
          content: Text('Gagal menghapus data: $e'),
        ),
      );
    }
  }

  Future<void> restoreItem(
    BuildContext context,
    ServiceCenterItem item,
    int index, {
    bool showSnackBar = true,
  }) async {
    final messenger = ScaffoldMessenger.of(context);

    final insertIndex = index.clamp(0, items.length);
    items.insert(insertIndex, item);
    update();

    if (showSnackBar) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.black87,
          content: Text(
            '${item.supplierName} dikembalikan.',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    try {
      await _dio.post(
        AppSettings.URL_AREN_RESTORE,
        data: {'id': item.idSupplier},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat mengembalikan data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void gotoDetail(ServiceCenterItem item) {
    if (item.idSupplier.isEmpty) {
      Get.snackbar(
        'Info',
        'ID inventaris tidak ditemukan.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.toNamed(
      AppRoutes.inventaris,
      arguments: {'id': item.idSupplier},
    );
  }

  int get itemCount => items.length;

  bool get showEmpty => !isLoading.value && items.isEmpty;
}

class ServiceCenterItem {
  const ServiceCenterItem({
    required this.idSupplier,
    required this.supplierName,
    this.supplierCode,
    this.type,
    this.info,
    this.address,
    this.city,
    this.phone,
    this.cpName,
    this.cpEmail,
    this.progressNm,
    this.isBlacklist,
    this.active,
    this.lastUpdate,
  });

  factory ServiceCenterItem.fromJson(Map<String, dynamic> json) {
    // Legacy Android mapping uses upper snake case keys.
    return ServiceCenterItem(
      idSupplier: _string(json['ID_SUPPLIER']) ?? '',
      supplierName: _string(json['SUPPLIER_NAME']) ?? '-',
      supplierCode: _string(json['SUPPLIER_CODE']),
      type: _string(json['TYPE']),
      info: _string(json['INFO']),
      address: _string(json['ADDRESS']),
      city: _string(json['CITY']),
      phone: _string(json['PHONE']),
      cpName: _string(json['CP_NAME']),
      cpEmail: _string(json['CP_EMAIL']),
      progressNm: _string(json['PROGRESSNM']),
      isBlacklist: _string(json['ISBLACKLIST']),
      active: _string(json['ACTIVE']),
      lastUpdate: _string(json['LAST_UPDATE']),
    );
  }

  final String idSupplier;
  final String supplierName;
  final String? supplierCode;
  final String? type;
  final String? info;
  final String? address;
  final String? city;
  final String? phone;
  final String? cpName;
  final String? cpEmail;
  final String? progressNm;
  final String? isBlacklist;
  final String? active;
  final String? lastUpdate;

  String get plainAddress => _stripHtml(address);
  String get plainCity => _stripHtml(city);

  static String? _string(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  // Legacy Java version relied on Html.fromHtml; here we remove the tags and decode
  // the small set of entities used by the backend to avoid a heavier dependency.
  static String _stripHtml(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final withoutTags = raw.replaceAll(RegExp(r'<[^>]*>'), '');
    return withoutTags
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .trim();
  }
}
