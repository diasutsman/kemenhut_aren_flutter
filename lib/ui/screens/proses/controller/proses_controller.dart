// lib/ui/screens/proses/controller/proses_controller.dart
//
// GetX controller that mirrors the legacy ProsesFragment behaviour: manages the
// list of tapping process records, validates dialog input, and builds API payloads.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'proses_form_data.dart';

class ProsesController extends GetxController {
  ProsesController({this.initialData});

  final ProsesFormData? initialData;

  final RxList<ProsesEntry> entries = <ProsesEntry>[].obs;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void onInit() {
    super.onInit();
    if (initialData != null) {
      applyServerData(initialData!);
    }
  }

  void applyServerData(ProsesFormData data) {
    entries.assignAll(data.entries);
  }

  Future<void> addProses() async {
    await _openProsesDialog();
  }

  Future<void> editProses(int index) async {
    if (index < 0 || index >= entries.length) return;
    await _openProsesDialog(entry: entries[index], index: index);
  }

  void removeProses(int index) {
    if (index < 0 || index >= entries.length) return;
    entries.removeAt(index);
  }

  Future<void> _openProsesDialog({ProsesEntry? entry, int? index}) async {
    final startCtrl = TextEditingController(text: entry?.tglMulai ?? '');
    final endCtrl = TextEditingController(text: entry?.tglAkhir ?? '');
    final panjangCtrl =
        TextEditingController(text: entry != null ? '${entry.panjangCm}' : '');
    final diameterCtrl =
        TextEditingController(text: entry != null ? '${entry.diameterCm}' : '');
    final lamaCtrl = TextEditingController(text: entry?.lamaNetes ?? '');
    final niraPagiCtrl = TextEditingController(text: entry?.niraPagi ?? '');
    final niraSoreCtrl = TextEditingController(text: entry?.niraSore ?? '');
    final brixPagiCtrl = TextEditingController(text: entry?.brixPagi ?? '');
    final brixSoreCtrl = TextEditingController(text: entry?.brixSore ?? '');

    DateTime? _parseDate(String value) {
      if (value.trim().isEmpty) return null;
      try {
        return _dateFormat.parse(value);
      } catch (_) {
        return null;
      }
    }

    DateTime? startDate = _parseDate(startCtrl.text);
    DateTime? endDate = _parseDate(endCtrl.text);

    Future<void> pickDate(
      BuildContext context,
      TextEditingController controller,
      DateTime? currentValue,
      ValueChanged<DateTime?> sink,
    ) async {
      final picked = await showDatePicker(
        context: context,
        initialDate: currentValue ?? DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        controller.text = _dateFormat.format(picked);
        sink(picked);
      }
    }

    final result = await Get.dialog<ProsesEntry>(
      Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: StatefulBuilder(
          builder: (context, setState) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Proses Penyadapan Mayang',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _dialogDateField(
                      label: 'Tanggal Mulai',
                      controller: startCtrl,
                      onPick: () async {
                        await pickDate(
                          context,
                          startCtrl,
                          startDate,
                          (value) => setState(() => startDate = value),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _dialogDateField(
                      label: 'Tanggal Akhir',
                      controller: endCtrl,
                      onPick: () async {
                        await pickDate(
                          context,
                          endCtrl,
                          endDate,
                          (value) => setState(() => endDate = value),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _dialogField(
                      label: 'Panjang (cm)',
                      controller: panjangCtrl,
                      inputType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    _dialogField(
                      label: 'Diameter (cm)',
                      controller: diameterCtrl,
                      inputType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    _dialogField(
                      label: 'Lama Penyadapan',
                      controller: lamaCtrl,
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _dialogField(
                            label: 'Produksi Nira Pagi',
                            controller: niraPagiCtrl,
                            inputType: TextInputType.text,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _dialogField(
                            label: 'Produksi Nira Sore',
                            controller: niraSoreCtrl,
                            inputType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _dialogField(
                            label: 'Brix Nira Pagi',
                            controller: brixPagiCtrl,
                            inputType: TextInputType.text,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _dialogField(
                            label: 'Brix Nira Sore',
                            controller: brixSoreCtrl,
                            inputType: TextInputType.text,
                          ),
                        ),
                      ],
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
                            final validation = _validate(
                              startCtrl.text,
                              endCtrl.text,
                              panjangCtrl.text,
                              diameterCtrl.text,
                              lamaCtrl.text,
                              niraPagiCtrl.text,
                              niraSoreCtrl.text,
                              brixPagiCtrl.text,
                              brixSoreCtrl.text,
                            );
                            if (validation != null) {
                              _showWarning(validation);
                              return;
                            }

                            final panjangVal =
                                double.tryParse(panjangCtrl.text.trim()) ?? 0;
                            final diameterVal =
                                double.tryParse(diameterCtrl.text.trim()) ?? 0;

                            final newEntry = ProsesEntry(
                              tglMulai: startCtrl.text.trim(),
                              tglAkhir: endCtrl.text.trim(),
                              panjangCm: panjangVal,
                              diameterCm: diameterVal,
                              lamaNetes: lamaCtrl.text.trim(),
                              niraPagi: niraPagiCtrl.text.trim(),
                              niraSore: niraSoreCtrl.text.trim(),
                              brixPagi: brixPagiCtrl.text.trim(),
                              brixSore: brixSoreCtrl.text.trim(),
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
      startCtrl.dispose();
      endCtrl.dispose();
      panjangCtrl.dispose();
      diameterCtrl.dispose();
      lamaCtrl.dispose();
      niraPagiCtrl.dispose();
      niraSoreCtrl.dispose();
      brixPagiCtrl.dispose();
      brixSoreCtrl.dispose();
    });

    if (result == null) return;

    if (index == null) {
      entries.add(result);
    } else {
      entries[index] = result;
      entries.refresh();
    }
  }

  String? _validate(
    String tglMulai,
    String tglAkhir,
    String panjang,
    String diameter,
    String lama,
    String niraPagi,
    String niraSore,
    String brixPagi,
    String brixSore,
  ) {
    if (tglMulai.trim().isEmpty) {
      return 'Harap mengisi tanggal mulai terlebih dahulu!';
    }
    if (tglAkhir.trim().isEmpty) {
      return 'Harap mengisi tanggal akhir terlebih dahulu!';
    }
    if (panjang.trim().isEmpty) {
      return 'Harap mengisi panjang terlebih dahulu!';
    }
    if (double.tryParse(panjang.trim()) == null) {
      return 'Panjang harus berupa angka valid!';
    }
    if (diameter.trim().isEmpty) {
      return 'Harap mengisi diameter terlebih dahulu!';
    }
    if (double.tryParse(diameter.trim()) == null) {
      return 'Diameter harus berupa angka valid!';
    }
    if (lama.trim().isEmpty) {
      return 'Harap mengisi lama penyadapan terlebih dahulu!';
    }
    if (niraPagi.trim().isEmpty) {
      return 'Harap mengisi produksi nira pagi terlebih dahulu!';
    }
    if (niraSore.trim().isEmpty) {
      return 'Harap mengisi produksi nira sore terlebih dahulu!';
    }
    if (brixPagi.trim().isEmpty) {
      return 'Harap mengisi produksi brix nira pagi terlebih dahulu!';
    }
    if (brixSore.trim().isEmpty) {
      return 'Harap mengisi produksi brix nira sore terlebih dahulu!';
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

  List<Map<String, dynamic>> buildRequestBody() {
    return entries.map((e) => e.toJson()).toList();
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
            width: 40,
            height: 40,
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

Widget _dialogField({
  required String label,
  required TextEditingController controller,
  required TextInputType inputType,
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
        keyboardType: inputType,
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
