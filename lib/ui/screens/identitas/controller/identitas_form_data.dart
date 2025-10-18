// lib/ui/screens/identitas/controller/identitas_form_data.dart
//
// Holds the data that pre-populates the Identitas form. This mirrors the legacy
// Android `Identitas` model so the Flutter UI can stay in sync with the existing
// behaviour while we complete the migration.

class IdentitasFormData {
  final String? nomorPengehet;
  final String? namaPengehet;
  final String? lokasiTempat;
  final String? desa;
  final String? tinggiPohon;
  final String? diameterPohon;
  final String? jumlahDaun;
  final String? taliwatu;
  final String? mayangKe;
  final String? panjangMayang;
  final String? adaPestisida;
  final String? lamaKetuk;
  final String? ketukMinggu;
  final String? jumlahPengetukkan;
  final String? faktorTeknis;
  final String? pelepah;
  final String? akarDiatasTanah;
  final String? tanggalSensus;
  final String? filePhoto;
  final double? latitude;
  final double? longitude;

  // Checkbox flags (value "1" => checked in legacy app)
  final Map<String, String?> flags;

  const IdentitasFormData({
    this.nomorPengehet,
    this.namaPengehet,
    this.lokasiTempat,
    this.desa,
    this.tinggiPohon,
    this.diameterPohon,
    this.jumlahDaun,
    this.taliwatu,
    this.mayangKe,
    this.panjangMayang,
    this.adaPestisida,
    this.lamaKetuk,
    this.ketukMinggu,
    this.jumlahPengetukkan,
    this.faktorTeknis,
    this.pelepah,
    this.akarDiatasTanah,
    this.tanggalSensus,
    this.filePhoto,
    this.latitude,
    this.longitude,
    this.flags = const {},
  });

  factory IdentitasFormData.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      final parsed = double.tryParse(value.toString());
      return parsed;
    }

    String? _string(dynamic value) {
      if (value == null) return null;
      final str = value.toString().trim();
      return str.isEmpty ? null : str;
    }

    final Map<String, String?> flags = {
      'daunHijauTebal': _string(json['daun_hijau_tebal']),
      'daunHijauTipis': _string(json['daun_hijau_tipis']),
      'daunMerunduk': _string(json['daun_merunduk']),
      'daunTegak': _string(json['daun_tegak']),
      'tanahLiat': _string(json['tanah_liat']),
      'tanahHitam': _string(json['tanah_hitam']),
      'tanahCoklat': _string(json['tanah_coklat']),
      'tanahPasir': _string(json['tanah_pasir']),
      'tanahDomato': _string(json['tanah_domato']),
      'tanahKurus': _string(json['tanah_kurus']),
      'tanahSumberLain': _string(json['tanah_sumber_lain']),
      'lingkunganTerbuka': _string(json['lingkungan_terbuka']),
      'lingkunganSemak': _string(json['lingkungan_semak']),
      'lingkunganHutanSedikit': _string(json['lingkungan_hutan_sedikit']),
      'lingkunganHutanLebat': _string(json['lingkungan_hutan_lebat']),
      'lingkunganPadat': _string(json['lingkungan_padat']),
      'lingkunganSedang': _string(json['lingkungan_sedang']),
      'lingkunganHutanAren': _string(json['lingkungan_hutan_aren']),
      'kemiringanCuramSekali': _string(json['kemiringan_curam_sekali']),
      'kemiringanCuram': _string(json['kemiringan_curam']),
      'kemiringanAgakCuram': _string(json['kemiringan_agak_curam']),
      'kemiringanDatar': _string(json['kemiringan_datar']),
      'posisiKanan': _string(json['posisi_kanan']),
      'posisiKiri': _string(json['posisi_kiri']),
      'posisiTengah': _string(json['posisi_tengah']),
      'posisiKeluar': _string(json['posisi_keluar']),
      'bungaMerah': _string(json['bunga_merah']),
      'bungaMerahKuning': _string(json['bunga_merah_kuning']),
      'bungaKuning': _string(json['bunga_kuning']),
      'bungaBerlemak': _string(json['bunga_berlemak']),
      'bungaBerharum': _string(json['bunga_berharum']),
      'perlakuanSinombor': _string(json['perlakuan_sinombor']),
      'perlakuanPinakakiit': _string(json['perlakuan_pinakakiit']),
      'perlakuanDiayun': _string(json['perlakuan_diayun']),
      'perlakuanLain': _string(json['perlakuan_lain']),
      'limahlihlih2': _string(json['limahlihlih_2']),
      'rimeka2': _string(json['rimeka_2']),
      'mahresik2': _string(json['mahresik_2']),
      'sariBunga2': _string(json['sari_bunga_2']),
      'kinagogoan2': _string(json['kinagogoan_2']),
      'kelilingMayang2': _string(json['keliling_mayang_2']),
    };

    return IdentitasFormData(
      nomorPengehet: _string(json['nomor_pengehet']),
      namaPengehet: _string(json['nama_pengehet']),
      lokasiTempat: _string(json['lokasi_tempat']),
      desa: _string(json['desa']),
      tinggiPohon: _string(json['tinggi_pohon']),
      diameterPohon: _string(json['diameter_pohon']),
      jumlahDaun: _string(json['jumlah_daun']),
      taliwatu: _string(json['taliwatu']),
      mayangKe: _string(json['mayang_ke']),
      panjangMayang: _string(json['panjang_mayang']),
      adaPestisida: _string(json['ada_pestisida']),
      lamaKetuk: _string(json['lama_ketuk']),
      ketukMinggu: _string(json['ketuk_minggu']),
      jumlahPengetukkan: _string(json['jumlah_pengetukkan']),
      faktorTeknis: _string(json['faktor_teknis']),
      pelepah: _string(json['pelepah']),
      akarDiatasTanah: _string(json['akar_diatas_tanah']),
      tanggalSensus: _string(json['tanggal_sensus']),
      filePhoto: _string(json['file_photo']),
      latitude: _toDouble(json['lat']),
      longitude: _toDouble(json['lang']),
      flags: flags,
    );
  }
}
