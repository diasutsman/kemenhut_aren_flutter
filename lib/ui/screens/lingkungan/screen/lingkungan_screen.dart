// lib/ui/screens/lingkungan/screen/lingkungan_screen.dart
//
// Flutter UI for the Lingkungan tab. Mirrors `fragment_lingkungan.xml`
// structure, binding every field to LingkunganController.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/lingkungan_controller.dart';

class LingkunganScreen extends StatelessWidget {
  const LingkunganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LingkunganController>(
      init: Get.isRegistered<LingkunganController>()
          ? Get.find<LingkunganController>()
          : LingkunganController(),
      autoRemove: false,
      builder: (controller) {
        return Container(
          color: const Color(0xFFF5ECE4),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _multiLineField(
                  label:
                      'Penilaian kelas kemahiran pemilik pohon (calon bibit unggul)',
                  controller: controller.penilaianCtrl,
                  hint: 'Masukkan Catatan..',
                ),
                _singleLineField(
                  label:
                      'Jumlah rata-rata mayang yang berhasil keluar nira dari 10 yang dicoba',
                  controller: controller.avgMayangCtrl,
                  hint: 'Rata-rata mayang.',
                ),
                _singleLineField(
                  label:
                      'Mampu menyadap berapa pohon dalam 1 hari apabila diproses sampai menjadi gula ?',
                  controller: controller.mampuSadapGulaCtrl,
                  hint: 'Jumlah pohon..',
                ),
                _singleLineField(
                  label:
                      'Mampu menyadap berapa pohon dalam 1 hari jika hanya diambil nira saja ?',
                  controller: controller.mampuSadapHariCtrl,
                  hint: 'Jumlah pohon..',
                ),
                _singleLineField(
                  label:
                      'Andaikata tidak perlu masak niranya dan tidak perlu transpor nira ke kampung, diperkirakan mampu menyadap berapa pohon ?',
                  controller: controller.sadapTanpaNiraCtrl,
                  hint: 'Jumlah Pohon..',
                ),
                _singleLineField(
                  label: 'Sudah berapa tahun menyadap?',
                  controller: controller.jumlahTahunCtrl,
                  hint: 'Jumlah Tahun..',
                  keyboardType: TextInputType.number,
                ),
                _multiLineField(
                  label:
                      'Apa menurut Anda menjadi tanda pohon bakal akan berproduksi banyak?',
                  controller: controller.tandaProduksiCtrl,
                  hint: 'Tanda pohon..',
                ),
                _multiLineField(
                  label:
                      'Apakah menurut Anda pengambilan ijuk berpengaruh terhadap produksi pohon?',
                  controller: controller.ambilIjukCtrl,
                  hint: 'Pendapat anda..',
                ),
                _multiLineField(
                  label:
                      'Apa jenis tanaman menurut Anda yang cocok dalam kombinasi tanaman aren?',
                  controller: controller.jenisTanamanCtrl,
                  hint: 'Jenis Tanaman..',
                ),
                _multiLineField(
                  label:
                      'Apa pernah ada hama atau penyakit pada pohon aren Anda?',
                  controller: controller.jenisHamaCtrl,
                  hint: 'Jenis Hama atau Penyakit..',
                ),
                _multiLineField(
                  label:
                      'Apa pernah muncul kolang kaling di bawah mayang yang di sadap?',
                  controller: controller.kolangKalingCtrl,
                  hint: 'Jawaban anda..',
                ),
                _checkboxGroup(
                  controller: controller,
                  label: 'Bagaimana tanda penyadapan nira berlebihan?',
                  items: const [
                    _CheckboxItem('pucukTerlibat', 'Pucuk Terlibat'),
                    _CheckboxItem('buahJatuh', 'Buah berjatuhan'),
                    _CheckboxItem('daunMelebar', 'Daun melebar'),
                    _CheckboxItem('daunTerlipat', 'Daun terlipat ke bawah'),
                  ],
                ),
                _multiLineField(
                  label:
                      'Apakah ada hubungan antara cuaca / musim dengan munculnya mayang?',
                  controller: controller.musimMayangCtrl,
                  hint: 'Pendapat anda...',
                ),
                _singleLineField(
                  label: 'Pada bulan apa produksi nira tertinggi?',
                  controller: controller.bulanProduksiCtrl,
                  hint: 'Nama Bulan..',
                ),
                _singleLineField(
                  label: 'Pada bulan apa nira paling manis?',
                  controller: controller.bulanManisCtrl,
                  hint: 'Nama Bulan..',
                ),
                _multiLineField(
                  label:
                      'Apa terjadi jika semua kolang kaling? dipotong (apabila ada pengalaman)',
                  controller: controller.kejadianLainCtrl,
                  hint: 'Jelaskan yang terjadi..',
                ),
                _multiLineField(
                  label: 'Apa ada binatang yang mengganggu penyadapan?',
                  controller: controller.binatangCtrl,
                  hint: 'Binatang yang mengganggu..',
                ),
                _multiLineField(
                  label:
                      'Apa cuaca menentukan perlakuan apa yang bisa dilakukan, misalnya pengetukkan?',
                  controller: controller.cuacaCtrl,
                  hint: 'Pendapat anda...',
                ),
                _multiLineField(
                  label: 'Apa resiko keamanan yang dihadapi penyadap?',
                  controller: controller.resikoCtrl,
                  hint: 'Resiko yang dihadapi..',
                ),
                _multiLineField(
                  label: 'Anda belajar penyadapan dari siapa?',
                  controller: controller.belajarDariCtrl,
                  hint: 'Belajar dari siapa..',
                ),
                _attachmentSection(controller),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _singleLineField({
  required String label,
  required TextEditingController controller,
  String? hint,
  TextInputType? keyboardType,
}) {
  return _frame(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _multiLineField({
  required String label,
  required TextEditingController controller,
  String? hint,
}) {
  return _frame(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          minLines: 3,
          maxLines: null,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _checkboxGroup({
  required LingkunganController controller,
  required String label,
  required List<_CheckboxItem> items,
}) {
  return _frame(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Obx(
            () => CheckboxListTile(
              value: controller.flag(item.flagKey),
              onChanged: (value) => controller.setFlag(item.flagKey, value),
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(item.label),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _attachmentSection(LingkunganController controller) {
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

class _CheckboxItem {
  final String flagKey;
  final String label;
  const _CheckboxItem(this.flagKey, this.label);
}
