// lib/ui/screens/product/screen/product_screen.dart
//
// Flutter representation of fragment_product.xml. Displays the product list,
// add button, empty state, and headers, all wired to ProductController.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/product_controller.dart';
import '../controller/product_form_data.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      init: Get.isRegistered<ProductController>()
          ? Get.find<ProductController>()
          : ProductController(),
      autoRemove: false,
      builder: (controller) {
        return Container(
          color: const Color(0xFFF5ECE4),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _frame(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Produk apa yang laku di tempat Anda dan harga berapa?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 160,
                          child: ElevatedButton.icon(
                            onPressed: controller.addProduct,
                            icon: const Icon(Icons.add),
                            label: const Text('Tambah'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _listHeader(),
                const SizedBox(height: 8),
                Obx(
                  () {
                    final items = controller.entries;
                    if (items.isEmpty) {
                      return _emptyState();
                    }
                    return Column(
                      children: items
                          .asMap()
                          .entries
                          .map(
                            (entry) => _productRow(
                              entry.value,
                              onEdit: () => controller.editProduct(entry.key),
                              onRemove: () =>
                                  controller.removeProduct(entry.key),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _listHeader() {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFE0E0E0),
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Row(
      children: const [
        _HeaderCell('Product Name'),
        _HeaderCell('Price'),
        _HeaderCell('Satuan'),
        SizedBox(width: 32),
      ],
    ),
  );
}

Widget _productRow(
  ProductEntry entry, {
  required VoidCallback onEdit,
  required VoidCallback onRemove,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFFDEDEDE)),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            _EntryCell(entry.productName),
            _EntryCell(_formatPrice(entry.price)),
            _EntryCell(entry.satuan, align: TextAlign.center),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    ),
  );
}

String _formatPrice(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(2);
}

Widget _emptyState() {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFFDEDEDE)),
      color: Colors.white,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.inbox, color: Colors.grey),
        SizedBox(width: 8),
        Text('Tidak ada data', style: TextStyle(color: Colors.black54)),
      ],
    ),
  );
}

Widget _frame(Widget child) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFFDEDEDE)),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFFEF6C00),
        ),
      ),
    );
  }
}

class _EntryCell extends StatelessWidget {
  const _EntryCell(this.value, {this.align = TextAlign.left});
  final String value;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        value.isEmpty ? '-' : value,
        textAlign: align,
      ),
    );
  }
}
