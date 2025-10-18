import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:logger/logger.dart';

import 'package:path/path.dart' as p;

import 'package:kemenhut_aren_flutter/constants/_index.dart';
import 'package:kemenhut_aren_flutter/ui/screens/identitas/controller/identitas_controller.dart';
import 'package:kemenhut_aren_flutter/ui/screens/identitas/controller/identitas_form_data.dart';
import 'package:kemenhut_aren_flutter/ui/screens/lingkungan/controller/lingkungan_controller.dart';
import 'package:kemenhut_aren_flutter/ui/screens/lingkungan/controller/lingkungan_form_data.dart';
import 'package:kemenhut_aren_flutter/ui/screens/product/controller/product_controller.dart';
import 'package:kemenhut_aren_flutter/ui/screens/product/controller/product_form_data.dart';
import 'package:kemenhut_aren_flutter/ui/screens/produksi/controller/produksi_controller.dart';
import 'package:kemenhut_aren_flutter/ui/screens/produksi/controller/produksi_form_data.dart';
import 'package:kemenhut_aren_flutter/ui/screens/proses/controller/proses_controller.dart';
import 'package:kemenhut_aren_flutter/ui/screens/proses/controller/proses_form_data.dart';

class InventarisController extends GetxController {
  final selectedTab = 0.obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final Dio _dio = Dio();
  late final IdentitasController identitasController;
  late final ProduksiController produksiController;
  late final LingkunganController lingkunganController;
  late final ProductController productController;
  late final ProsesController prosesController;
  String? currentInventarisId;

  @override
  void onInit() {
    identitasController =
        Get.isRegistered<IdentitasController>()
            ? Get.find<IdentitasController>()
            : Get.put(IdentitasController(), permanent: true);
    produksiController =
        Get.isRegistered<ProduksiController>()
            ? Get.find<ProduksiController>()
            : Get.put(ProduksiController(), permanent: true);
    lingkunganController =
        Get.isRegistered<LingkunganController>()
            ? Get.find<LingkunganController>()
            : Get.put(LingkunganController(), permanent: true);
    productController =
        Get.isRegistered<ProductController>()
            ? Get.find<ProductController>()
            : Get.put(ProductController(), permanent: true);
    prosesController =
        Get.isRegistered<ProsesController>()
            ? Get.find<ProsesController>()
            : Get.put(ProsesController(), permanent: true);
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['id'] != null) {
      final idArg = args['id']?.toString();
      if (idArg != null && idArg.isNotEmpty) {
        currentInventarisId = idArg;
        loadInventaris(idArg);
      }
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  Future<void> confirmSave() async {
    if (isSaving.value) return;
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        content: const Text('Apa anda yakin ingin simpan ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('YES'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    Get.find<Logger>().i('confirmed: $confirmed');

    if (confirmed == true) {
      final saved = await saveData();
      Get.find<Logger>().i('saved: $saved');
      if (saved) {
        Navigator.pop(Get.context!, {
          'reload': true,
          'id': currentInventarisId,
        });
      }
    }
  }

  Future<void> loadInventaris(String id) async {
    if (id.isEmpty) return;
    isLoading.value = true;
    currentInventarisId = id;
    update();
    try {
      final resp = await _dio.get('${AppSettings.URL_VIEW_AREN}?id=$id');
      print('Response: ${resp.data}');
      if (resp.data is Map<String, dynamic>) {
        final data = resp.data as Map<String, dynamic>;
        final payload = _resolveIdentitasPayload(data);
        if (payload != null) {
          currentInventarisId =
              payload['id']?.toString() ?? currentInventarisId;
          identitasController.applyServerData(
            IdentitasFormData.fromJson(payload),
          );
          produksiController.applyServerData(
            ProduksiFormData.fromJson(payload),
          );
          lingkunganController.applyServerData(
            LingkunganFormData.fromJson(payload),
          );
          productController.applyServerData(ProductFormData.fromJson(payload));
          prosesController.applyServerData(ProsesFormData.fromJson(payload));
        }
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Gagal', 'Tidak dapat memuat data inventaris: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<bool> saveData() async {
    final logger = Get.find<Logger>();
    logger.d('saveData start isSaving.value: ${isSaving.value}');
    if (isSaving.value) {
      logger.w(
        'saveData aborted because a save operation is already in progress',
      );
      return false;
    }
    final identitasRaw = identitasController.buildRequestBody();
    final produksiRaw = produksiController.buildRequestBody();
    final lingkunganRaw = lingkunganController.buildRequestBody();
    final productPayload = productController.buildRequestBody();
    final prosesPayload = prosesController.buildRequestBody();

    logger.d(
      'saveData payloads prepared '
      'identitasKeys=${identitasRaw.keys} '
      'produksiKeys=${produksiRaw.keys} '
      'lingkunganKeys=${lingkunganRaw.keys} '
      'productEntries=${productPayload.length} '
      'prosesEntries=${prosesPayload.length}',
    );

    final formData = FormData();

    void addField(String key, dynamic value) {
      final stringValue = _stringify(value);
      formData.fields.add(MapEntry(key, stringValue));
      logger.v('saveData addField key=$key value=$stringValue');
    }

    final identitasMapping = <String, String>{
      'nomor_pengehet': 'nomorPengehet',
      'nama_pengehet': 'namaPengehet',
      'lokasi_tempat': 'lokasiTempat',
      'desa': 'desa',
      'tinggi_pohon': 'tinggiPohon',
      'diameter_pohon': 'diameterPohon',
      'jumlah_daun': 'jumlahDaun',
      'taliwatu': 'taliwatu',
      'mayang_ke': 'mayang',
      'panjang_mayang': 'panjangMayang',
      'ada_pestisida': 'adaPestisida',
      'lama_ketuk': 'lamaKetuk',
      'ketuk_minggu': 'ketukMinggu',
      'jumlah_pengetukkan': 'jmlPengetukkan',
      'faktor_teknis': 'faktor',
      'pelepah': 'pelepah',
      'akar_diatas_tanah': 'akar',
      'lat': 'lat',
      'lang': 'lon',
      'daun_hijau_tebal': 'hijauTebal',
      'daun_hijau_tipis': 'hijauTipis',
      'daun_merunduk': 'merunduk',
      'daun_tegak': 'tegak',
      'tanah_liat': 'tanahLiat',
      'tanah_hitam': 'tanahHitam',
      'tanah_coklat': 'tanahCoklat',
      'tanah_pasir': 'tanahPasir',
      'tanah_domato': 'tanahDomato',
      'tanah_kurus': 'tanahKurus',
      'tanah_sumber_lain': 'sumberLain',
      'lingkungan_terbuka': 'tempatTerbuka',
      'lingkungan_semak': 'semakBelukar',
      'lingkungan_hutan_sedikit': 'hutanSedikit',
      'lingkungan_hutan_lebat': 'hutanLebat',
      'lingkungan_padat': 'padat',
      'lingkungan_sedang': 'sedang',
      'lingkungan_hutan_aren': 'hutanAren',
      'kemiringan_curam_sekali': 'curamSekali',
      'kemiringan_curam': 'curam',
      'kemiringan_agak_curam': 'agakCuram',
      'kemiringan_datar': 'datar',
      'posisi_kanan': 'kanan',
      'posisi_kiri': 'kiri',
      'posisi_tengah': 'tengah',
      'posisi_keluar': 'keluar',
      'bunga_merah': 'bungaMerah',
      'bunga_merah_kuning': 'bungaMerahKuning',
      'bunga_kuning': 'bungaKuning',
      'bunga_berlemak': 'bungaBerlemak',
      'bunga_berharum': 'bungaBerharum',
      'perlakuan_sinombor': 'sinombor',
      'perlakuan_pinakakiit': 'pinakakiit',
      'perlakuan_diayun': 'diayun',
      'perlakuan_lain': 'perlakuanLain',
      'limahlihlih_2': 'limahlihlih2',
      'rimeka_2': 'rimeka2',
      'mahresik_2': 'mahresik2',
      'sari_bunga_2': 'sariBunga2',
      'kinagogoan_2': 'kinagogoan2',
      'keliling_mayang_2': 'kelilingMayang2',
    };

    final lingkunganMapping = <String, String>{
      'penilaian': 'penilaian',
      'avg_mayang': 'avgMayang',
      'mampu_sadap_gula': 'mampuSadapGula',
      'mampu_sadap_hari': 'mampuSadapHari',
      'sadap_tanpa_nira': 'sadapTanpaNira',
      'jumlah_tahun': 'jmlThn',
      'tanda_produksi': 'tandaProduksi',
      'ambil_ijuk': 'ambilIjuk',
      'jenis_tanaman': 'jenisTanaman',
      'jenis_hama': 'jenisHama',
      'kolang_kaling': 'kolangKaling',
      'musim_mayang': 'musimMayang',
      'bulan_produksi': 'bulanProduksi',
      'bulan_manis': 'bulanManis',
      'kejadian_lain': 'happens',
      'binatang_pengganggu': 'binatang',
      'cuaca': 'cuaca',
      'resiko_penyadap': 'resikoPenyadap',
      'belajar_dari': 'belajarDari',
      'pucuk_terlibat': 'pucukTerlibat',
      'buah_jatuh': 'buahJatuh',
      'daun_melebar': 'daunMelebar',
      'daun_terlipat': 'daunTerlipat',
    };

    final produksiMapping = <String, String>{
      'cara_perangsangan': 'caraPerangsangan',
      'pengawet_nira': 'pengawetNira',
    };

    // Base fields
    addField('id', currentInventarisId ?? '');
    identitasMapping.forEach((sourceKey, targetKey) {
      addField(targetKey, identitasRaw[sourceKey]);
    });
    logger.d(
      'saveData identitas fields added: count=${identitasMapping.length}',
    );
    lingkunganMapping.forEach((sourceKey, targetKey) {
      addField(targetKey, lingkunganRaw[sourceKey]);
    });
    logger.d(
      'saveData lingkungan fields added: count=${lingkunganMapping.length}',
    );
    produksiMapping.forEach((sourceKey, targetKey) {
      addField(targetKey, produksiRaw[sourceKey]);
    });
    logger.d('saveData produksi fields added: count=${produksiMapping.length}');

    final rangsangJson = jsonEncode(produksiRaw['rangsang'] ?? []);
    final produkJson = jsonEncode(productPayload);
    final prosesJson = jsonEncode(prosesPayload);

    addField('rangsang', rangsangJson);
    addField('produk', produkJson);
    addField('proses', prosesJson);
    logger.d(
      'saveData complex payloads encoded rangsangLength=${(produksiRaw['rangsang'] as List?)?.length ?? 0} '
      'produkLength=${productPayload.length} prosesLength=${prosesPayload.length}',
    );

    // Optional attachments
    final identitasFile = identitasController.attachment;
    final produksiFile = produksiController.attachment;
    final lingkunganFile = lingkunganController.attachment;

    if (identitasFile != null) {
      logger.i('saveData attaching identitas file: ${identitasFile.path}');
      formData.files.add(
        MapEntry(
          'photo',
          await MultipartFile.fromFile(
            identitasFile.path,
            filename: p.basename(identitasFile.path),
          ),
        ),
      );
    }
    if (produksiFile != null) {
      logger.i('saveData attaching produksi file: ${produksiFile.path}');
      formData.files.add(
        MapEntry(
          'photo2',
          await MultipartFile.fromFile(
            produksiFile.path,
            filename: p.basename(produksiFile.path),
          ),
        ),
      );
    }
    if (lingkunganFile != null) {
      logger.i('saveData attaching lingkungan file: ${lingkunganFile.path}');
      formData.files.add(
        MapEntry(
          'photo3',
          await MultipartFile.fromFile(
            lingkunganFile.path,
            filename: p.basename(lingkunganFile.path),
          ),
        ),
      );
    }

    isSaving.value = true;
    update();
    logger.d(
      'saveData formData prepared fields=${formData.fields.length} files=${formData.files.length}',
    );
    var success = false;
    try {
      logger.i('saveData sending POST to ${AppSettings.URL_SAVE_AREN}');
      final response = await _dio.post(
        AppSettings.URL_SAVE_AREN,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final raw = response.data;
      Map<String, dynamic>? data;
      if (raw is String) {
        try {
          data = jsonDecode(raw) as Map<String, dynamic>;
        } catch (err, st) {
          logger.e(
            'saveData failed to decode string response',
            error: err,
            stackTrace: st,
          );
        }
      } else if (raw is Map<String, dynamic>) {
        data = raw;
      }
      logger.d('saveData raw response: $raw (${raw.runtimeType})');
      logger.d('saveData parsed response: $data');
      int? errCode;
      String? errMsg;
      if (data != null) {
        final codeSource = data['err_code'] ?? data['errCode'];
        if (codeSource is int) {
          errCode = codeSource;
        } else if (codeSource is String) {
          errCode = int.tryParse(codeSource);
        }
        final msgSource = data['err_msg'] ?? data['errMsg'];
        errMsg = msgSource?.toString();
      }
      logger.d('saveData response parsed errCode=$errCode errMsg=$errMsg');
      if (errCode == AppSettings.SUCCESS_CODE || errCode == 200) {
        logger.i('saveData success with errCode=$errCode');
        Get.snackbar('Sukses', errMsg ?? 'Data berhasil disimpan');
        success = true;
      } else {
        logger.w('saveData failed with errCode=$errCode message=$errMsg');
        Get.snackbar('Gagal', errMsg ?? 'Gagal menyimpan data');
      }
    } catch (e) {
      logger.e('saveData encountered an exception', error: e);
      Get.snackbar('Error', 'Tidak dapat menyimpan data: $e');
    } finally {
      isSaving.value = false;
      update();
      logger.d(
        'saveData completed success=$success isSaving reset=${isSaving.value}',
      );
    }
    return success;
  }

  Map<String, dynamic>? _resolveIdentitasPayload(Map<String, dynamic> source) {
    final candidate = source['identitas'];
    if (candidate is Map<String, dynamic>) {
      return candidate;
    }
    final arenNode = source['aren'];
    if (arenNode is Map<String, dynamic>) {
      return arenNode;
    }
    final dataNode = source['data'];
    if (dataNode is Map<String, dynamic>) {
      return dataNode;
    }
    return source.isEmpty ? null : source;
  }

  String _stringify(dynamic value) {
    if (value == null) return '';
    if (value is double) {
      if (value == value.roundToDouble()) {
        return value.toStringAsFixed(0);
      }
    }
    return value.toString();
  }
}
