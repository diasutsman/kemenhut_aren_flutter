// lib/ui/screens/proses/screen/proses_screen.dart
//
// Flutter UI for the legacy Proses fragment. Lists tapping process records with
// headers, empty state, and edit/remove actions through ProsesController.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/proses_controller.dart';
import '../controller/proses_form_data.dart';

class ProsesScreen extends StatelessWidget {
  const ProsesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProsesController>(
      init: Get.isRegistered<ProsesController>()
          ? Get.find<ProsesController>()
          : ProsesController(),
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
                        'Proses Penyadapan Mayang',
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
                            onPressed: controller.addProses,
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
                            (entry) => _prosesRow(
                              entry.value,
                              onEdit: () => controller.editProses(entry.key),
                              onRemove: () => controller.removeProses(entry.key),
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
        _HeaderCell('Tgl Mulai'),
        _HeaderCell('Tgl Akhir'),
        _HeaderCell('Panjang'),
        _HeaderCell('Diameter'),
        _HeaderCell('Lama'),
        _HeaderCell('Nira Pagi'),
        _HeaderCell('Nira Sore'),
        _HeaderCell('Brix Pagi'),
        _HeaderCell('Brix Sore'),
        SizedBox(width: 32),
      ],
    ),
  );
}

Widget _prosesRow(
  ProsesEntry entry, {
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
            _EntryCell(entry.tglMulai),
            _EntryCell(entry.tglAkhir),
            _EntryCell(_formatDouble(entry.panjangCm)),
            _EntryCell(_formatDouble(entry.diameterCm)),
            _EntryCell(entry.lamaNetes),
            _EntryCell(entry.niraPagi),
            _EntryCell(entry.niraSore),
            _EntryCell(entry.brixPagi),
            _EntryCell(entry.brixSore),
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

String _formatDouble(double value) {
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
  const _EntryCell(this.value, {this.align = TextAlign.center});
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
