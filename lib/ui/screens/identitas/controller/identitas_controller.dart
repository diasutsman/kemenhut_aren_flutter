// lib/ui/screens/identitas/controller/identitas_controller.dart
//
// Flutter translation of the legacy `IdentitasFragment`. This controller
// mirrors the Java logic: it manages text fields, checkbox flags, location
// updates, Google Maps state, and photo attachment handling. Any intentional
// deviations from the Android behaviour are documented inline.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import 'identitas_form_data.dart';

class IdentitasController extends GetxController {
  IdentitasController({this.initialData});

  final IdentitasFormData? initialData;

  // Text controllers map directly to the EditText controls in the legacy layout.
  final TextEditingController nomorPengehetCtrl = TextEditingController();
  final TextEditingController namaPengehetCtrl = TextEditingController();
  final TextEditingController lokasiTempatCtrl = TextEditingController();
  final TextEditingController desaCtrl = TextEditingController();
  final TextEditingController transDateCtrl = TextEditingController();
  final TextEditingController tinggiPohonCtrl = TextEditingController();
  final TextEditingController diameterPohonCtrl = TextEditingController();
  final TextEditingController jumlahDaunCtrl = TextEditingController();
  final TextEditingController taliwatuCtrl = TextEditingController();
  final TextEditingController mayangCtrl = TextEditingController();
  final TextEditingController panjangMayangCtrl = TextEditingController();
  final TextEditingController adaPestisidaCtrl = TextEditingController();
  final TextEditingController lamaKetukCtrl = TextEditingController();
  final TextEditingController ketukMingguCtrl = TextEditingController();
  final TextEditingController jumlahPengetukkanCtrl = TextEditingController();
  final TextEditingController faktorCtrl = TextEditingController();

  // Dropdown options mirror the Spinner entries.
  final List<String> pelepahOptions = const ['Kiri', 'Kanan'];
  final List<String> yesNoOptions = const ['Ya', 'Tidak'];

  final RxnString selectedPelepah = RxnString();
  final RxnString selectedAkar = RxnString();

  // Checkbox flags; legacy sends "1" for checked values.
  final RxMap<String, bool> flags = <String, bool>{}.obs;

  final RxString altitudeLabel = '0 m'.obs;
  final RxnString remoteImageUrl = RxnString();
  final Rxn<XFile> pickedImage = Rxn<XFile>();
  final RxString attachmentName = ''.obs;

  final Rx<LatLng> mapCenter =
      const LatLng(-2.548926, 118.0148634).obs; // default: centre of Indonesia
  final RxDouble mapZoom = 15.0.obs;
  final Rxn<Marker> currentMarker = Rxn<Marker>();
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  final RxBool locationPermissionGranted = false.obs;
  final RxBool isRequestingLocation = false.obs;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  StreamSubscription<Position>? _positionSubscription;

  double? _latestLatitude;
  double? _latestLongitude;
  double? _latestAltitude;

  static const List<String> _flagKeys = [
    'daunHijauTebal',
    'daunHijauTipis',
    'daunMerunduk',
    'daunTegak',
    'tanahLiat',
    'tanahHitam',
    'tanahCoklat',
    'tanahPasir',
    'tanahDomato',
    'tanahKurus',
    'tanahSumberLain',
    'lingkunganTerbuka',
    'lingkunganSemak',
    'lingkunganHutanSedikit',
    'lingkunganHutanLebat',
    'lingkunganPadat',
    'lingkunganSedang',
    'lingkunganHutanAren',
    'kemiringanCuramSekali',
    'kemiringanCuram',
    'kemiringanAgakCuram',
    'kemiringanDatar',
    'posisiKanan',
    'posisiKiri',
    'posisiTengah',
    'posisiKeluar',
    'bungaMerah',
    'bungaMerahKuning',
    'bungaKuning',
    'bungaBerlemak',
    'bungaBerharum',
    'perlakuanSinombor',
    'perlakuanPinakakiit',
    'perlakuanDiayun',
    'perlakuanLain',
    'limahlihlih2',
    'rimeka2',
    'mahresik2',
    'sariBunga2',
    'kinagogoan2',
    'kelilingMayang2',
  ];

  @override
  void onInit() {
    super.onInit();
    _initFlags();
    _populateForm();
    _initLocationHandling();
  }

  @override
  void onClose() {
    nomorPengehetCtrl.dispose();
    namaPengehetCtrl.dispose();
    lokasiTempatCtrl.dispose();
    desaCtrl.dispose();
    transDateCtrl.dispose();
    tinggiPohonCtrl.dispose();
    diameterPohonCtrl.dispose();
    jumlahDaunCtrl.dispose();
    taliwatuCtrl.dispose();
    mayangCtrl.dispose();
    panjangMayangCtrl.dispose();
    adaPestisidaCtrl.dispose();
    lamaKetukCtrl.dispose();
    ketukMingguCtrl.dispose();
    jumlahPengetukkanCtrl.dispose();
    faktorCtrl.dispose();
    _positionSubscription?.cancel();
    super.onClose();
  }

  void _initFlags() {
    for (final key in _flagKeys) {
      flags[key] = false;
    }
  }

  void _populateForm() {
    // Defaults
    transDateCtrl.text = _dateFormat.format(DateTime.now());

    final data = initialData;
    if (data == null) return;
    _applyData(data);
  }

  void _applyData(IdentitasFormData data) {
    for (final key in _flagKeys) {
      flags[key] = false;
    }
    flags.refresh();

    pickedImage.value = null;
    attachmentName.value = '';

    nomorPengehetCtrl.text = data.nomorPengehet ?? '';
    namaPengehetCtrl.text = data.namaPengehet ?? '';
    lokasiTempatCtrl.text = data.lokasiTempat ?? '';
    desaCtrl.text = data.desa ?? '';
    tinggiPohonCtrl.text = data.tinggiPohon ?? '';
    diameterPohonCtrl.text = data.diameterPohon ?? '';
    jumlahDaunCtrl.text = data.jumlahDaun ?? '';
    taliwatuCtrl.text = data.taliwatu ?? '';
    mayangCtrl.text = data.mayangKe ?? '';
    panjangMayangCtrl.text = data.panjangMayang ?? '';
    adaPestisidaCtrl.text = data.adaPestisida ?? '';
    lamaKetukCtrl.text = data.lamaKetuk ?? '';
    ketukMingguCtrl.text = data.ketukMinggu ?? '';
    jumlahPengetukkanCtrl.text = data.jumlahPengetukkan ?? '';
    faktorCtrl.text = data.faktorTeknis ?? '';

    if (data.tanggalSensus != null && data.tanggalSensus!.isNotEmpty) {
      transDateCtrl.text = data.tanggalSensus!;
    }

    selectedPelepah.value =
        _matchDropdownValue(data.pelepah, pelepahOptions);
    selectedAkar.value =
        _matchDropdownValue(data.akarDiatasTanah, yesNoOptions);

    data.flags.forEach((key, value) {
      if (_flagKeys.contains(key) && value != null) {
        setFlag(key, value == '1');
      }
    });

    if (data.filePhoto != null && data.filePhoto!.isNotEmpty) {
      remoteImageUrl.value = data.filePhoto;
    }

    if (data.latitude != null && data.longitude != null) {
      final latLng = LatLng(data.latitude!, data.longitude!);
      mapCenter.value = latLng;
      currentMarker.value = Marker(
        markerId: const MarkerId('identitas'),
        position: latLng,
      );
      _latestLatitude = data.latitude;
      _latestLongitude = data.longitude;
    }
  }

  void applyServerData(IdentitasFormData data) {
    _applyData(data);
  }

  String? _matchDropdownValue(String? value, List<String> options) {
    if (value == null) return null;
    final lower = value.toLowerCase();
    for (final option in options) {
      if (option.toLowerCase() == lower) {
        return option;
      }
    }
    return null;
  }

  Future<void> _initLocationHandling() async {
    isRequestingLocation.value = true;

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isRequestingLocation.value = false;
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      locationPermissionGranted.value = false;
      isRequestingLocation.value = false;
      return;
    }

    locationPermissionGranted.value = true;

    // We rely on Geolocator (instead of Android's LocationManager) to obtain
    // altitude information because Flutter does not expose the legacy API.
    await _updateCurrentPosition();
    _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen(
      _handlePositionUpdate,
      onError: (error) {
        debugPrint('IdentitasController: location stream error => $error');
      },
    );

    isRequestingLocation.value = false;
  }

  Future<void> _updateCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      _handlePositionUpdate(position);
    } catch (e) {
      debugPrint('IdentitasController: failed to get location => $e');
    }
  }

  void _handlePositionUpdate(Position position) {
    _latestLatitude = position.latitude;
    _latestLongitude = position.longitude;
    _latestAltitude = position.altitude.isFinite ? position.altitude : null;

    if (_latestAltitude != null) {
      altitudeLabel.value = '${_latestAltitude!.toStringAsFixed(1)} m';
    }

    final latLng = LatLng(position.latitude, position.longitude);
    mapCenter.value = latLng;
    currentMarker.value = Marker(
      markerId: const MarkerId('identitas'),
      position: latLng,
    );
    _animateMap(latLng);
  }

  Future<void> _animateMap(LatLng target) async {
    if (!mapController.isCompleted) return;
    try {
      final controller = await mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: mapZoom.value),
        ),
      );
    } catch (e) {
      debugPrint('IdentitasController: failed to animate map => $e');
    }
  }

  bool flag(String key) => flags[key] ?? false;

  void setFlag(String key, bool? value) {
    flags[key] = value ?? false;
    flags.refresh();
  }

  Future<void> chooseDate(BuildContext context) async {
    final initialDate = _parseDate(transDateCtrl.text) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      transDateCtrl.text = _dateFormat.format(picked);
    }
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    try {
      return _dateFormat.parse(value.trim());
    } catch (_) {
      return null;
    }
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
      remoteImageUrl.value = null; // override any server-provided photo
    } catch (e) {
      debugPrint('IdentitasController: failed to pick image => $e');
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

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
  }

  Map<String, dynamic> buildRequestBody() {
    String boolToFlag(String key) => flag(key) ? '1' : '0';

    double? lat = _latestLatitude ?? mapCenter.value.latitude;
    double? lon = _latestLongitude ?? mapCenter.value.longitude;

    return {
      'nomor_pengehet': nomorPengehetCtrl.text.trim(),
      'nama_pengehet': namaPengehetCtrl.text.trim(),
      'lokasi_tempat': lokasiTempatCtrl.text.trim(),
      'desa': desaCtrl.text.trim(),
      'tinggi_pohon': tinggiPohonCtrl.text.trim(),
      'diameter_pohon': diameterPohonCtrl.text.trim(),
      'jumlah_daun': jumlahDaunCtrl.text.trim(),
      'taliwatu': taliwatuCtrl.text.trim(),
      'mayang_ke': mayangCtrl.text.trim(),
      'panjang_mayang': panjangMayangCtrl.text.trim(),
      'ada_pestisida': adaPestisidaCtrl.text.trim(),
      'lama_ketuk': lamaKetukCtrl.text.trim(),
      'ketuk_minggu': ketukMingguCtrl.text.trim(),
      'jumlah_pengetukkan': jumlahPengetukkanCtrl.text.trim(),
      'faktor_teknis': faktorCtrl.text.trim(),
      'pelepah': selectedPelepah.value ?? '',
      'akar_diatas_tanah': selectedAkar.value ?? '',
      'tanggal_sensus': transDateCtrl.text.trim(),
      'lat': lat,
      'lang': lon,
      'altitude': _latestAltitude,
      'file_photo': remoteImageUrl.value,
      'attachment_name': attachmentName.value,
      'daun_hijau_tebal': boolToFlag('daunHijauTebal'),
      'daun_hijau_tipis': boolToFlag('daunHijauTipis'),
      'daun_merunduk': boolToFlag('daunMerunduk'),
      'daun_tegak': boolToFlag('daunTegak'),
      'tanah_liat': boolToFlag('tanahLiat'),
      'tanah_hitam': boolToFlag('tanahHitam'),
      'tanah_coklat': boolToFlag('tanahCoklat'),
      'tanah_pasir': boolToFlag('tanahPasir'),
      'tanah_domato': boolToFlag('tanahDomato'),
      'tanah_kurus': boolToFlag('tanahKurus'),
      'tanah_sumber_lain': boolToFlag('tanahSumberLain'),
      'lingkungan_terbuka': boolToFlag('lingkunganTerbuka'),
      'lingkungan_semak': boolToFlag('lingkunganSemak'),
      'lingkungan_hutan_sedikit': boolToFlag('lingkunganHutanSedikit'),
      'lingkungan_hutan_lebat': boolToFlag('lingkunganHutanLebat'),
      'lingkungan_padat': boolToFlag('lingkunganPadat'),
      'lingkungan_sedang': boolToFlag('lingkunganSedang'),
      'lingkungan_hutan_aren': boolToFlag('lingkunganHutanAren'),
      'kemiringan_curam_sekali': boolToFlag('kemiringanCuramSekali'),
      'kemiringan_curam': boolToFlag('kemiringanCuram'),
      'kemiringan_agak_curam': boolToFlag('kemiringanAgakCuram'),
      'kemiringan_datar': boolToFlag('kemiringanDatar'),
      'posisi_kanan': boolToFlag('posisiKanan'),
      'posisi_kiri': boolToFlag('posisiKiri'),
      'posisi_tengah': boolToFlag('posisiTengah'),
      'posisi_keluar': boolToFlag('posisiKeluar'),
      'bunga_merah': boolToFlag('bungaMerah'),
      'bunga_merah_kuning': boolToFlag('bungaMerahKuning'),
      'bunga_kuning': boolToFlag('bungaKuning'),
      'bunga_berlemak': boolToFlag('bungaBerlemak'),
      'bunga_berharum': boolToFlag('bungaBerharum'),
      'perlakuan_sinombor': boolToFlag('perlakuanSinombor'),
      'perlakuan_pinakakiit': boolToFlag('perlakuanPinakakiit'),
      'perlakuan_diayun': boolToFlag('perlakuanDiayun'),
      'perlakuan_lain': boolToFlag('perlakuanLain'),
      'limahlihlih_2': boolToFlag('limahlihlih2'),
      'rimeka_2': boolToFlag('rimeka2'),
      'mahresik_2': boolToFlag('mahresik2'),
      'sari_bunga_2': boolToFlag('sariBunga2'),
      'kinagogoan_2': boolToFlag('kinagogoan2'),
      'keliling_mayang_2': boolToFlag('kelilingMayang2'),
    };
  }

  XFile? get attachment => pickedImage.value;
}
