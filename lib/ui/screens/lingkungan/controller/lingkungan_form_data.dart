// lib/ui/screens/lingkungan/controller/lingkungan_form_data.dart
//
// Data holder for the Lingkungan (penyayap) tab. Mirrors the legacy Identitas
// model fields so the Flutter UI can stay in sync with the Android behaviour.

class LingkunganFormData {
  final String? penilaian;
  final String? avgMayang;
  final String? mampuSadapGula;
  final String? mampuSadapHari;
  final String? sadapTanpaNira;
  final String? jumlahTahun;
  final String? tandaProduksi;
  final String? ambilIjuk;
  final String? jenisTanaman;
  final String? jenisHama;
  final String? kolangKaling;
  final String? musimMayang;
  final String? bulanProduksi;
  final String? bulanManis;
  final String? kejadianLain;
  final String? binatangPengganggu;
  final String? cuaca;
  final String? resikoPenyadap;
  final String? belajarDari;
  final String? filePhoto3;

  final Map<String, String?> flags;

  const LingkunganFormData({
    this.penilaian,
    this.avgMayang,
    this.mampuSadapGula,
    this.mampuSadapHari,
    this.sadapTanpaNira,
    this.jumlahTahun,
    this.tandaProduksi,
    this.ambilIjuk,
    this.jenisTanaman,
    this.jenisHama,
    this.kolangKaling,
    this.musimMayang,
    this.bulanProduksi,
    this.bulanManis,
    this.kejadianLain,
    this.binatangPengganggu,
    this.cuaca,
    this.resikoPenyadap,
    this.belajarDari,
    this.filePhoto3,
    this.flags = const {},
  });

  factory LingkunganFormData.fromJson(Map<String, dynamic> json) {
    String? _string(dynamic value) {
      if (value == null) return null;
      final str = value.toString().trim();
      return str.isEmpty ? null : str;
    }

    final Map<String, String?> flags = {
      'pucukTerlibat': _string(json['pucuk_terlibat']),
      'buahJatuh': _string(json['buah_jatuh']),
      'daunMelebar': _string(json['daun_melebar']),
      'daunTerlipat': _string(json['daun_terlipat']),
    };

    return LingkunganFormData(
      penilaian: _string(json['penilaian']),
      avgMayang: _string(json['avg_mayang']),
      mampuSadapGula: _string(json['mampu_sadap_gula']),
      mampuSadapHari: _string(json['mampu_sadap_hari']),
      sadapTanpaNira: _string(json['sadap_tanpa_nira']),
      jumlahTahun: _string(json['jumlah_tahun']),
      tandaProduksi: _string(json['tanda_produksi']),
      ambilIjuk: _string(json['ambil_ijuk']),
      jenisTanaman: _string(json['jenis_tanaman']),
      jenisHama: _string(json['jenis_hama']),
      kolangKaling: _string(json['kolang_kaling']),
      musimMayang: _string(json['musim_mayang']),
      bulanProduksi: _string(json['bulan_produksi']),
      bulanManis: _string(json['bulan_manis']),
      kejadianLain: _string(json['kejadian_lain']),
      binatangPengganggu: _string(json['binatang_pengganggu']),
      cuaca: _string(json['cuaca']),
      resikoPenyadap: _string(json['resiko_penyadap']),
      belajarDari: _string(json['belajar_dari']),
      filePhoto3: _string(json['file_photo3']),
      flags: flags,
    );
  }
}
