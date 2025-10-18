// lib/ui/screens/lingkungan/controller/lingkungan_controller.dart
//
// Flutter translation of the legacy LingkunganFragment. Handles text fields,
// checkbox states, and image attachment logic so behaviour matches the Android
// implementation.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import 'lingkungan_form_data.dart';

class LingkunganController extends GetxController {
  LingkunganController({this.initialData});

  final LingkunganFormData? initialData;

  final TextEditingController penilaianCtrl = TextEditingController();
  final TextEditingController avgMayangCtrl = TextEditingController();
  final TextEditingController mampuSadapGulaCtrl = TextEditingController();
  final TextEditingController mampuSadapHariCtrl = TextEditingController();
  final TextEditingController sadapTanpaNiraCtrl = TextEditingController();
  final TextEditingController jumlahTahunCtrl = TextEditingController();
  final TextEditingController tandaProduksiCtrl = TextEditingController();
  final TextEditingController ambilIjukCtrl = TextEditingController();
  final TextEditingController jenisTanamanCtrl = TextEditingController();
  final TextEditingController jenisHamaCtrl = TextEditingController();
  final TextEditingController kolangKalingCtrl = TextEditingController();
  final TextEditingController musimMayangCtrl = TextEditingController();
  final TextEditingController bulanProduksiCtrl = TextEditingController();
  final TextEditingController bulanManisCtrl = TextEditingController();
  final TextEditingController kejadianLainCtrl = TextEditingController();
  final TextEditingController binatangCtrl = TextEditingController();
  final TextEditingController cuacaCtrl = TextEditingController();
  final TextEditingController resikoCtrl = TextEditingController();
  final TextEditingController belajarDariCtrl = TextEditingController();

  final RxMap<String, bool> flags = <String, bool>{}.obs;

  final Rxn<XFile> pickedImage = Rxn<XFile>();
  final RxnString remoteImageUrl = RxnString();
  final RxString attachmentName = ''.obs;

  static const List<String> _flagKeys = [
    'pucukTerlibat',
    'buahJatuh',
    'daunMelebar',
    'daunTerlipat',
  ];

  @override
  void onInit() {
    super.onInit();
    _initFlags();
    _populateForm();
  }

  @override
  void onClose() {
    penilaianCtrl.dispose();
    avgMayangCtrl.dispose();
    mampuSadapGulaCtrl.dispose();
    mampuSadapHariCtrl.dispose();
    sadapTanpaNiraCtrl.dispose();
    jumlahTahunCtrl.dispose();
    tandaProduksiCtrl.dispose();
    ambilIjukCtrl.dispose();
    jenisTanamanCtrl.dispose();
    jenisHamaCtrl.dispose();
    kolangKalingCtrl.dispose();
    musimMayangCtrl.dispose();
    bulanProduksiCtrl.dispose();
    bulanManisCtrl.dispose();
    kejadianLainCtrl.dispose();
    binatangCtrl.dispose();
    cuacaCtrl.dispose();
    resikoCtrl.dispose();
    belajarDariCtrl.dispose();
    super.onClose();
  }

  void _initFlags() {
    for (final key in _flagKeys) {
      flags[key] = false;
    }
  }

  void _populateForm() {
    final data = initialData;
    if (data == null) return;
    applyServerData(data);
  }

  void applyServerData(LingkunganFormData data) {
    penilaianCtrl.text = data.penilaian ?? '';
    avgMayangCtrl.text = data.avgMayang ?? '';
    mampuSadapGulaCtrl.text = data.mampuSadapGula ?? '';
    mampuSadapHariCtrl.text = data.mampuSadapHari ?? '';
    sadapTanpaNiraCtrl.text = data.sadapTanpaNira ?? '';
    jumlahTahunCtrl.text = data.jumlahTahun ?? '';
    tandaProduksiCtrl.text = data.tandaProduksi ?? '';
    ambilIjukCtrl.text = data.ambilIjuk ?? '';
    jenisTanamanCtrl.text = data.jenisTanaman ?? '';
    jenisHamaCtrl.text = data.jenisHama ?? '';
    kolangKalingCtrl.text = data.kolangKaling ?? '';
    musimMayangCtrl.text = data.musimMayang ?? '';
    bulanProduksiCtrl.text = data.bulanProduksi ?? '';
    bulanManisCtrl.text = data.bulanManis ?? '';
    kejadianLainCtrl.text = data.kejadianLain ?? '';
    binatangCtrl.text = data.binatangPengganggu ?? '';
    cuacaCtrl.text = data.cuaca ?? '';
    resikoCtrl.text = data.resikoPenyadap ?? '';
    belajarDariCtrl.text = data.belajarDari ?? '';

    for (final key in _flagKeys) {
      flags[key] = data.flags[key] == '1';
    }
    flags.refresh();

    pickedImage.value = null;
    attachmentName.value = '';
    remoteImageUrl.value =
        (data.filePhoto3 != null && data.filePhoto3!.isNotEmpty)
            ? data.filePhoto3
            : null;
  }

  bool flag(String key) => flags[key] ?? false;

  void setFlag(String key, bool? value) {
    flags[key] = value ?? false;
    flags.refresh();
  }

  Future<void> chooseImage() async {
    final picker = ImagePicker();
    final source = await _pickImageSource();
    if (source == null) return;

    try {
      final image = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (image == null) return;

      pickedImage.value = image;
      attachmentName.value = p.basename(image.path);
      remoteImageUrl.value = null;
    } catch (e) {
      debugPrint('LingkunganController: failed to pick image => $e');
    }
  }

  Future<ImageSource?> _pickImageSource() async {
    return await Get.bottomSheet<ImageSource>(
      SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Gunakan Kamera'),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Batal'),
              onTap: Get.back,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void removeAttachment() {
    pickedImage.value = null;
    attachmentName.value = '';
  }

  void viewAttachment() {
    final file = pickedImage.value;
    final url = remoteImageUrl.value;

    if (file == null && (url == null || url.isEmpty)) return;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  child: file != null
                      ? Image.file(File(file.path), fit: BoxFit.contain)
                      : Image.network(
                          url!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text(
                              'Gagal memuat gambar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: Get.back,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black54,
    );
  }

  Map<String, dynamic> buildRequestBody() {
    String boolToFlag(String key) => flag(key) ? '1' : '0';

    return {
      'penilaian': penilaianCtrl.text.trim(),
      'avg_mayang': avgMayangCtrl.text.trim(),
      'mampu_sadap_gula': mampuSadapGulaCtrl.text.trim(),
      'mampu_sadap_hari': mampuSadapHariCtrl.text.trim(),
      'sadap_tanpa_nira': sadapTanpaNiraCtrl.text.trim(),
      'jumlah_tahun': jumlahTahunCtrl.text.trim(),
      'tanda_produksi': tandaProduksiCtrl.text.trim(),
      'ambil_ijuk': ambilIjukCtrl.text.trim(),
      'jenis_tanaman': jenisTanamanCtrl.text.trim(),
      'jenis_hama': jenisHamaCtrl.text.trim(),
      'kolang_kaling': kolangKalingCtrl.text.trim(),
      'musim_mayang': musimMayangCtrl.text.trim(),
      'bulan_produksi': bulanProduksiCtrl.text.trim(),
      'bulan_manis': bulanManisCtrl.text.trim(),
      'kejadian_lain': kejadianLainCtrl.text.trim(),
      'binatang_pengganggu': binatangCtrl.text.trim(),
      'cuaca': cuacaCtrl.text.trim(),
      'resiko_penyadap': resikoCtrl.text.trim(),
      'belajar_dari': belajarDariCtrl.text.trim(),
      'file_photo3': remoteImageUrl.value,
      'attachment_name': attachmentName.value,
      'pucuk_terlibat': boolToFlag('pucukTerlibat'),
      'buah_jatuh': boolToFlag('buahJatuh'),
      'daun_melebar': boolToFlag('daunMelebar'),
      'daun_terlipat': boolToFlag('daunTerlipat'),
    };
  }

  XFile? get attachment => pickedImage.value;
}
