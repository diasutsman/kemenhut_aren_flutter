// lib/ui/screens/produksi/screen/produksi_screen.dart
//
// Flutter UI for the legacy `fragment_produksi` screen. Mirrors the original
// layout, including the attachment controls and the table of perangsangan
// entries with add/edit/remove capabilities.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/produksi_controller.dart';
import '../controller/produksi_form_data.dart';

class ProduksiScreen extends StatelessWidget {
  const ProduksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProduksiController>(
      init: Get.isRegistered<ProduksiController>()
          ? Get.find<ProduksiController>()
          : ProduksiController(),
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
                        'Cara perangsangan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.caraPerangsanganCtrl,
                        minLines: 3,
                        maxLines: null,
                        decoration: _inputDecoration('Masukkan Catatan..'),
                      ),
                    ],
                  ),
                ),
                _frame(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pengawet Nira',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.pengawetNiraCtrl,
                        decoration: _inputDecoration('Bahan Pengawet..'),
                      ),
                    ],
                  ),
                ),
                _attachmentSection(controller),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 180,
                    child: ElevatedButton.icon(
                      onPressed: controller.addEntry,
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                            (entry) => _entryRow(
                              entry.value,
                              onEdit: () => controller.editEntry(entry.key),
                              onRemove: () => controller.removeEntry(entry.key),
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

Widget _attachmentSection(ProduksiController controller) {
  return _frame(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lampiran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () {
            if (controller.remoteImageUrl.value != null &&
                controller.remoteImageUrl.value!.isNotEmpty &&
                controller.pickedImage.value == null) {
              return _attachmentButton(
                icon: Icons.image_search,
                label: 'View Uploaded Image',
                accentColor: const Color(0xFF4D918E),
                onTap: controller.viewAttachment,
              );
            }
            return const SizedBox.shrink();
          },
        ),
        _attachmentButton(
          icon: Icons.attachment,
          label: 'Tambah Lampiran',
          onTap: controller.chooseImage,
        ),
        const SizedBox(height: 8),
        Obx(
          () {
            final file = controller.pickedImage.value;
            if (file == null) return const SizedBox.shrink();
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFDEDEDE)),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(file.path),
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      controller.attachmentName.value,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.removeAttachment,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  IconButton(
                    onPressed: controller.viewAttachment,
                    icon: const Icon(Icons.visibility),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

Widget _attachmentButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  Color accentColor = const Color(0xFF4D918E),
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDEDEDE)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: accentColor),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _listHeader() {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFE0E0E0),
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Row(
      children: const [
        _HeaderCell('Tanggal'),
        _HeaderCell('Diiris (mm)'),
        _HeaderCell('Lama Penetesan'),
        _HeaderCell('Sagu Keras'),
        _HeaderCell('Sagu Busa Cair'),
        _HeaderCell('Bergabus'),
        SizedBox(width: 32),
      ],
    ),
  );
}

Widget _entryRow(
  PerangsanganEntry entry, {
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            _EntryCell(entry.tanggal, align: TextAlign.center),
            _EntryCell(entry.irisan),
            _EntryCell(entry.lamaNira, align: TextAlign.center),
            _EntryCell(entry.tainaKete, align: TextAlign.center),
            _EntryCell(entry.tainaRara, align: TextAlign.center),
            _EntryCell(entry.simewu, align: TextAlign.center),
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

Widget _emptyState() {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFFDEDEDE)),
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
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
