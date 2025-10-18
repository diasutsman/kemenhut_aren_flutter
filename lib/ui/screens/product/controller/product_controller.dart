// lib/ui/screens/product/controller/product_controller.dart
//
// GetX controller for the Produk tab. Manages the product list, dialog
// interactions, and serialises payloads compatible with the Android baseline.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'product_form_data.dart';

class ProductController extends GetxController {
  ProductController({this.initialData});

  final ProductFormData? initialData;

  final RxList<ProductEntry> entries = <ProductEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    _populate();
  }

  void _populate() {
    final data = initialData;
    if (data != null) {
      applyServerData(data);
    }
  }

  void applyServerData(ProductFormData data) {
    entries.assignAll(data.entries);
  }

  Future<void> addProduct() async {
    await _openProductDialog();
  }

  Future<void> editProduct(int index) async {
    if (index < 0 || index >= entries.length) return;
    await _openProductDialog(entry: entries[index], index: index);
  }

  void removeProduct(int index) {
    if (index < 0 || index >= entries.length) return;
    entries.removeAt(index);
  }

  Future<void> _openProductDialog({ProductEntry? entry, int? index}) async {
    final nameCtrl = TextEditingController(text: entry?.productName ?? '');
    final priceCtrl = TextEditingController(
      text: entry != null ? '${entry.price}' : '',
    );
    final unitCtrl = TextEditingController(text: entry?.satuan ?? '');

    final result = await Get.dialog<ProductEntry>(
      Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: StatefulBuilder(
          builder: (context, setState) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Produk Aren',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _dialogField(
                      label: 'Product Name',
                      controller: nameCtrl,
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(height: 12),
                    _dialogField(
                      label: 'Price',
                      controller: priceCtrl,
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    _dialogField(
                      label: 'Satuan',
                      controller: unitCtrl,
                      inputType: TextInputType.text,
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
                              nameCtrl.text,
                              priceCtrl.text,
                              unitCtrl.text,
                            );
                            if (validation != null) {
                              _showWarning(validation);
                              return;
                            }
                            final parsedPrice =
                                double.tryParse(priceCtrl.text.trim()) ?? 0;
                            final newEntry = ProductEntry(
                              productName: nameCtrl.text.trim(),
                              price: parsedPrice,
                              satuan: unitCtrl.text.trim(),
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
      nameCtrl.dispose();
      priceCtrl.dispose();
      unitCtrl.dispose();
    });

    if (result == null) return;

    if (index == null) {
      entries.add(result);
    } else {
      entries[index] = result;
      entries.refresh();
    }
  }

  String? _validate(String name, String price, String unit) {
    if (name.trim().isEmpty) {
      return 'Harap mengisi product name terlebih dahulu!';
    }
    if (price.trim().isEmpty) {
      return 'Harap mengisi price terlebih dahulu!';
    }
    if (unit.trim().isEmpty) {
      return 'Harap mengisi satuan terlebih dahulu!';
    }
    if (double.tryParse(price.trim()) == null) {
      return 'Harga harus berupa angka valid!';
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

Widget _dialogField({
  required String label,
  required TextEditingController controller,
  required TextInputType inputType,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ],
  );
}
