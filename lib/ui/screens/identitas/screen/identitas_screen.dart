// lib/ui/screens/identitas/screen/identitas_screen.dart
//
// Flutter screen for the Identitas tab. This is the UI counterpart of the
// legacy `fragment_identitas.xml`, rebuilt with Flutter widgets while keeping
// the structure, labels, and control hierarchy aligned with the Android app.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/identitas_controller.dart';

class IdentitasScreen extends StatelessWidget {
  const IdentitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IdentitasController>(
      init: Get.isRegistered<IdentitasController>()
          ? Get.find<IdentitasController>()
          : IdentitasController(),
      autoRemove: false,
      builder: (controller) {
        return Container(
          color: const Color(0xFFF5ECE4),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMapSection(controller),
                const SizedBox(height: 12),
                _buildTextRow(
                  label: 'No. Penyadap',
                  child: _textField(
                    controller: controller.nomorPengehetCtrl,
                    hintText: 'Nomor Penyadap..',
                    keyboardType: TextInputType.number,
                  ),
                ),
                _buildTextRow(
                  label: 'Nama Penyadap',
                  child: _textField(
                    controller: controller.namaPengehetCtrl,
                    hintText: 'Nama Penyadap..',
                  ),
                ),
                _buildTextRow(
                  label: 'Lokasi/Tempat',
                  child: _textField(
                    controller: controller.lokasiTempatCtrl,
                    hintText: 'Lokasi/Tempat..',
                  ),
                ),
                _buildTextRow(
                  label: 'Altitude (m)',
                  child: Obx(
                    () => Text(
                      controller.altitudeLabel.value,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                _buildTextRow(
                  label: 'Desa',
                  child: _textField(
                    controller: controller.desaCtrl,
                    hintText: 'Desa..',
                  ),
                ),
                _buildDateRow(context, controller),
                _buildSectionLabel('Latar Belakang Pohon'),
                _buildTextRow(
                  label: 'Tinggi Pohon',
                  child: _textField(
                    controller: controller.tinggiPohonCtrl,
                    hintText: 'Tinggi Pohon..',
                    keyboardType: TextInputType.number,
                  ),
                ),
                _buildTextRow(
                  label: 'Diameter Pohon',
                  child: _textField(
                    controller: controller.diameterPohonCtrl,
                    hintText: 'Diameter Pohon..',
                    keyboardType: TextInputType.number,
                  ),
                ),
                _buildCheckboxColumn(
                  controller: controller,
                  heading: 'Daun',
                  items: const [
                    _CheckboxItem('daunHijauTebal', 'Hijau Tebal'),
                    _CheckboxItem('daunHijauTipis', 'Hijau Tipis'),
                    _CheckboxItem('daunMerunduk', 'Melebar'),
                    _CheckboxItem('daunTegak', 'Tegak'),
                  ],
                ),
                _buildTextRow(
                  label: 'Jumlah Daun',
                  child: _textField(
                    controller: controller.jumlahDaunCtrl,
                    hintText: 'Jumlah Daun..',
                    keyboardType: TextInputType.number,
                  ),
                ),
                _buildTextRow(
                  label: 'Tangkai Kolang Kaling',
                  child: _textField(
                    controller: controller.taliwatuCtrl,
                    hintText: 'Tangkai Kolang Kaling..',
                  ),
                ),
                _buildTextRow(
                  label: 'Mayang ke-',
                  child: _textField(
                    controller: controller.mayangCtrl,
                    hintText: 'Mayang ke..',
                    keyboardType: TextInputType.number,
                  ),
                ),
                _buildTextRow(
                  label: 'Panjang Mayang',
                  child: _textField(
                    controller: controller.panjangMayangCtrl,
                    hintText: 'Panjang Mayang',
                    keyboardType: TextInputType.number,
                  ),
                ),
                _buildDropdownRow(
                  label: 'Putaran Pelepah',
                  items: controller.pelepahOptions,
                  value: controller.selectedPelepah,
                ),
                _buildDropdownRow(
                  label: 'Akar diatas tanah',
                  items: controller.yesNoOptions,
                  value: controller.selectedAkar,
                ),
                _buildCheckboxColumn(
                  controller: controller,
                  heading: 'Faktor tanah',
                  items: const [
                    _CheckboxItem('tanahLiat', 'Tumbuh di lembah'),
                    _CheckboxItem('tanahHitam', 'Tumbuh di punggung'),
                    _CheckboxItem('tanahCoklat', 'Tumbuh di lereng'),
                    _CheckboxItem('tanahPasir', 'Tanah Subur'),
                    _CheckboxItem('tanahDomato', 'Tanah Biasa'),
                    _CheckboxItem('tanahKurus', 'Tanah Kurus'),
                    _CheckboxItem('tanahSumberLain', 'Sumber makanan lain'),
                  ],
                ),
                _buildMultilineRow(
                  label:
                      'Apakah ada penggunaan pupuk buatan dan/atau pestisida di sekitar.',
                  controller: controller.adaPestisidaCtrl,
                  hint: 'Masukkan Catatan..',
                ),
                _buildSectionLabel('Faktor lingkungan'),
                _buildCheckboxColumn(
                  controller: controller,
                  heading: 'Kompetisi',
                  items: const [
                    _CheckboxItem('lingkunganTerbuka', 'Tempat Terbuka'),
                    _CheckboxItem('lingkunganSemak', 'Semak Belukar'),
                    _CheckboxItem('lingkunganHutanSedikit', 'Hutan Muda'),
                    _CheckboxItem('lingkunganHutanLebat', 'Hutan Lebat'),
                    _CheckboxItem('lingkunganPadat', 'Padat'),
                    _CheckboxItem('lingkunganSedang', 'Sedang'),
                    _CheckboxItem('lingkunganHutanAren', 'Hutan Aren'),
                  ],
                ),
                _buildCheckboxColumn(
                  controller: controller,
                  heading: 'Topografi',
                  items: const [
                    _CheckboxItem('kemiringanCuramSekali', 'Curam Sekali (> 40°)'),
                    _CheckboxItem('kemiringanCuram', 'Curam (30° - 40°)'),
                    _CheckboxItem('kemiringanAgakCuram', 'Agak Curam (15° - 30°)'),
                    _CheckboxItem('kemiringanDatar', 'Datar (< 15°)'),
                  ],
                ),
                _buildCheckboxColumn(
                  controller: controller,
                  heading: 'Posisi mayang keluar pelepah',
                  items: const [
                    _CheckboxItem('posisiKanan', 'Kanan'),
                    _CheckboxItem('posisiKiri', 'Kiri'),
                    _CheckboxItem('posisiTengah', 'Tengah'),
                    _CheckboxItem(
                        'posisiKeluar', 'Keluar terbelah di tengah'),
                  ],
                ),
                _buildCheckboxColumn(
                  controller: controller,
                  heading: 'Kondisi bunga mayang saat dijatuhkan',
                  items: const [
                    _CheckboxItem('bungaMerah', 'Bunga merah'),
                    _CheckboxItem('bungaMerahKuning', 'Bunga merah campur kuning'),
                    _CheckboxItem('bungaKuning', 'Bunga Kuning'),
                    _CheckboxItem('bungaBerlemak', 'Bunga berlemak'),
                    _CheckboxItem('bungaBerharum', 'Bunga Berharum'),
                  ],
                ),
                _buildCheckboxColumn(
                  controller: controller,
                  heading: 'Perlakuan Pada Mayang',
                  items: const [
                    _CheckboxItem('perlakuanSinombor', 'Olah mudah (sinombor)'),
                    _CheckboxItem(
                        'perlakuanPinakakiit', 'Sesuai prosedur (pinakakiit)'),
                    _CheckboxItem(
                        'perlakuanDiayun', 'Diayun kekiri / kekanan'),
                    _CheckboxItem('perlakuanLain', 'Perlakukan lain'),
                  ],
                ),
                _buildTextRow(
                  label: 'Lamanya dalam 1x ketuk',
                  child: _textField(
                    controller: controller.lamaKetukCtrl,
                    hintText: 'lama pengetukkan (menit)..',
                    keyboardType: TextInputType.number,
                  ),
                ),
                _buildTextRow(
                  label: 'Berapa kali ketuk 1 minggu',
                  child: _textField(
                    controller: controller.ketukMingguCtrl,
                    hintText: 'Jumlah ketuk dlm 1 minggu..',
                    keyboardType: TextInputType.number,
                  ),
                ),
                _buildTextRow(
                  label: 'Berapa total pengetukan?',
                  child: _textField(
                    controller: controller.jumlahPengetukkanCtrl,
                    hintText:
                        'Jumlah pengetukkan sampai mayang dipotong..',
                    keyboardType: TextInputType.number,
                  ),
                ),
                _buildMultilineRow(
                  label: 'Faktor khusus yang diperhatikan',
                  controller: controller.faktorCtrl,
                  hint: 'Masukkan Catatan (optional)...',
                ),
                _buildCheckboxColumn(
                  controller: controller,
                  heading: 'Posisi mayang (dipotong)',
                  items: const [
                    _CheckboxItem('limahlihlih2', 'Bunga berlemak'),
                    _CheckboxItem('rimeka2', 'Bunga memecah'),
                    _CheckboxItem('mahresik2', 'Bunga gugur'),
                    _CheckboxItem('sariBunga2', 'Sari bunga sudah kering'),
                    _CheckboxItem('kinagogoan2', 'Bunga gugur semua'),
                    _CheckboxItem('kelilingMayang2', 'Agas keliling mayang'),
                  ],
                ),
                _buildAttachmentSection(controller),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapSection(IdentitasController controller) {
    return _frame(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 200,
          child: Obx(
            () {
              final marker = controller.currentMarker.value;
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: controller.mapCenter.value,
                  zoom: controller.mapZoom.value,
                ),
                onMapCreated: controller.onMapCreated,
                myLocationEnabled: controller.locationPermissionGranted.value,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                markers: marker != null ? {marker} : <Marker>{},
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDateRow(
    BuildContext context,
    IdentitasController controller,
  ) {
    return _frame(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Tanggal Sensus',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.transDateCtrl,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'Pilih tanggal..',
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 36,
                  width: 36,
                  child: ElevatedButton(
                    onPressed: () => controller.chooseDate(context),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: const Color(0xFF4D918E),
                    ),
                    child: const Icon(Icons.calendar_month, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow({
    required String label,
    required List<String> items,
    required RxnString value,
  }) {
    return _frame(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Obx(
              () => DropdownButtonFormField<String>(
                value: value.value != null && items.contains(value.value)
                    ? value.value
                    : null,
                items: items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (selected) => value.value = selected,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxColumn({
    required IdentitasController controller,
    required String heading,
    required List<_CheckboxItem> items,
  }) {
    return _frame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
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
                onChanged: (val) => controller.setFlag(item.flagKey, val),
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(item.label),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultilineRow({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return _frame(
      child: Column(
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
            maxLines: null,
            minLines: 3,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentSection(IdentitasController controller) {
    return _frame(
      child: Column(
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
                return _attachmentAction(
                  icon: Icons.image_search,
                  label: 'Lihat Gambar',
                  onTap: controller.viewAttachment,
                  accentColor: const Color(0xFF4D918E),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          _attachmentAction(
            icon: Icons.attachment,
            label: 'Tambah Lampiran',
            onTap: controller.chooseImage,
          ),
          const SizedBox(height: 8),
          Obx(
            () {
              final picked = controller.pickedImage.value;
              if (picked == null) return const SizedBox.shrink();
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDEDEDE)),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFEEEEEE),
                        image: DecorationImage(
                          image: FileImage(File(picked.path)),
                          fit: BoxFit.cover,
                        ),
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
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: controller.removeAttachment,
                    ),
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: controller.viewAttachment,
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

  Widget _attachmentAction({
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

  Widget _buildTextRow({
    required String label,
    required Widget child,
  }) {
    return _frame(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(flex: 3, child: child),
        ],
      ),
    );
  }

  Widget _frame({required Widget child, EdgeInsets? padding}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

  static Widget _textField({
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return _frame(
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _CheckboxItem {
  final String flagKey;
  final String label;
  const _CheckboxItem(this.flagKey, this.label);
}
