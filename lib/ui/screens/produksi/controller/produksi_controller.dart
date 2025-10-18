// lib/ui/screens/produksi/controller/produksi_controller.dart
//
// Flutter port of the legacy `ProduksiFragment`. Manages form state, the list
// of perangsangan entries, image attachment handling, and exposes request
// payload builders that stay compatible with the Android implementation.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import 'produksi_form_data.dart';

class ProduksiController extends GetxController {
  ProduksiController({this.initialData});

  final ProduksiFormData? initialData;

  final TextEditingController caraPerangsanganCtrl = TextEditingController();
  final TextEditingController pengawetNiraCtrl = TextEditingController();

  final RxList<PerangsanganEntry> entries = <PerangsanganEntry>[].obs;

  final Rxn<XFile> pickedImage = Rxn<XFile>();
  final RxnString remoteImageUrl = RxnString();
  final RxString attachmentName = ''.obs;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void onInit() {
    super.onInit();
    _populateForm();
  }

  @override
  void onClose() {
    caraPerangsanganCtrl.dispose();
    pengawetNiraCtrl.dispose();
    super.onClose();
  }

  void _populateForm() {
    final data = initialData;
    if (data == null) return;
    applyServerData(data);
  }

  void applyServerData(ProduksiFormData data) {
    caraPerangsanganCtrl.text = data.caraPerangsangan ?? '';
    pengawetNiraCtrl.text = data.pengawetNira ?? '';
    entries.assignAll(data.entries);

    if (data.filePhoto2 != null && data.filePhoto2!.isNotEmpty) {
      remoteImageUrl.value = data.filePhoto2;
    } else {
      remoteImageUrl.value = null;
    }

    pickedImage.value = null;
    attachmentName.value = '';
  }

  Future<void> addEntry() async {
    await _openEntryDialog();
  }

  Future<void> editEntry(int index) async {
    if (index < 0 || index >= entries.length) return;
    await _openEntryDialog(entry: entries[index], index: index);
  }

  Future<void> _openEntryDialog({PerangsanganEntry? entry, int? index}) async {
    final tanggalCtrl = TextEditingController(text: entry?.tanggal ?? '');
    final irisanCtrl = TextEditingController(text: entry?.irisan ?? '');
    final lamaCtrl = TextEditingController(text: entry?.lamaNira ?? '');
    final tainaKeteCtrl = TextEditingController(text: entry?.tainaKete ?? '');
    final tainaRaraCtrl = TextEditingController(text: entry?.tainaRara ?? '');
    final simewuCtrl = TextEditingController(text: entry?.simewu ?? '');

    DateTime? selectedDate = _parseDate(tanggalCtrl.text);

    final result = await Get.dialog<PerangsanganEntry>(
      Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: StatefulBuilder(
          builder: (context, setState) {
            Future<void> pickDate() async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(1990),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                selectedDate = picked;
                tanggalCtrl.text = _dateFormat.format(picked);
                setState(() {});
              }
            }

            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progress Penyayatan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _dialogDateField(
                      label: 'Tanggal',
                      controller: tanggalCtrl,
                      onPick: pickDate,
                    ),
                    const SizedBox(height: 12),
                    _dialogTextField(
                      label: 'Diiris (mm)',
                      controller: irisanCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    _dialogTextField(
                      label: 'Lama Penetesan',
                      controller: lamaCtrl,
                    ),
                    const SizedBox(height: 12),
                    _dialogTextField(
                      label: 'Sagu Keras',
                      controller: tainaKeteCtrl,
                    ),
                    const SizedBox(height: 12),
                    _dialogTextField(
                      label: 'Sagu Busa Cair',
                      controller: tainaRaraCtrl,
                    ),
                    const SizedBox(height: 12),
                    _dialogTextField(
                      label: 'Bergabus',
                      controller: simewuCtrl,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Batal'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            final validation = _validateEntry(
                              tanggalCtrl.text,
                              irisanCtrl.text,
                              lamaCtrl.text,
                              tainaKeteCtrl.text,
                              tainaRaraCtrl.text,
                              simewuCtrl.text,
                            );
                            if (validation != null) {
                              _showWarning(validation);
                              return;
                            }

                            final newEntry = PerangsanganEntry(
                              id: entry?.id,
                              tanggal: tanggalCtrl.text.trim(),
                              irisan: irisanCtrl.text.trim(),
                              lamaNira: lamaCtrl.text.trim(),
                              tainaKete: tainaKeteCtrl.text.trim(),
                              tainaRara: tainaRaraCtrl.text.trim(),
                              simewu: simewuCtrl.text.trim(),
                            );
                            Get.back(result: newEntry);
                          },
                          child: const Text('Simpan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      tanggalCtrl.dispose();
      irisanCtrl.dispose();
      lamaCtrl.dispose();
      tainaKeteCtrl.dispose();
      tainaRaraCtrl.dispose();
      simewuCtrl.dispose();
    });

    if (result == null) return;

    if (index == null) {
      entries.add(result);
    } else {
      entries[index] = result;
      entries.refresh();
    }
  }

  void removeEntry(int index) {
    if (index < 0 || index >= entries.length) return;
    entries.removeAt(index);
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
      debugPrint('ProduksiController: failed to pick image => $e');
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
    return {
      'cara_perangsangan': caraPerangsanganCtrl.text.trim(),
      'pengawet_nira': pengawetNiraCtrl.text.trim(),
      'file_photo2': remoteImageUrl.value,
      'attachment_name': attachmentName.value,
      'rangsang': entries.map((e) => e.toJson()).toList(),
    };
  }

  XFile? get attachment => pickedImage.value;

  // Helpers -----------------------------------------------------------

  DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    try {
      return _dateFormat.parse(value.trim());
    } catch (_) {
      return null;
    }
  }

  String? _validateEntry(
    String tanggal,
    String irisan,
    String lama,
    String tainaKete,
    String tainaRara,
    String simewu,
  ) {
    if (tanggal.trim().isEmpty) {
      return 'Harap mengisi tanggal terlebih dahulu!';
    }
    if (irisan.trim().isEmpty) {
      return 'Harap mengisi irisan terlebih dahulu!';
    }
    if (lama.trim().isEmpty) {
      return 'Harap mengisi lama nira terlebih dahulu!';
    }
    if (tainaKete.trim().isEmpty) {
      return 'Harap mengisi taina kete terlebih dahulu!';
    }
    if (tainaRara.trim().isEmpty) {
      return 'Harap mengisi taina rara terlebih dahulu!';
    }
    if (simewu.trim().isEmpty) {
      return 'Harap mengisi simewu / ginerez terlebih dahulu!';
    }
    return null;
  }

  void _showWarning(String message) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        snackStyle: SnackStyle.FLOATING,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

Widget _dialogDateField({
  required String label,
  required TextEditingController controller,
  required Future<void> Function() onPick,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Pilih tanggal..',
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 40,
            width: 40,
            child: ElevatedButton(
              onPressed: onPick,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Icon(Icons.calendar_month, size: 18),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _dialogTextField({
  required String label,
  required TextEditingController controller,
  TextInputType? keyboardType,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ],
  );
}
