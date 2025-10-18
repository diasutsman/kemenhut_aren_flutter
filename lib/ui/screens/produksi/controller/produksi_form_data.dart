// lib/ui/screens/produksi/controller/produksi_form_data.dart
//
// Data structures for the Produksi (penyayatan) screen. These mirror the legacy
// Android models so we can populate the Flutter UI with the same payload.

class PerangsanganEntry {
  final String? id;
  final String tanggal;
  final String irisan;
  final String lamaNira;
  final String tainaKete;
  final String tainaRara;
  final String simewu;

  const PerangsanganEntry({
    this.id,
    required this.tanggal,
    required this.irisan,
    required this.lamaNira,
    required this.tainaKete,
    required this.tainaRara,
    required this.simewu,
  });

  factory PerangsanganEntry.fromJson(Map<String, dynamic> json) {
    String _string(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    return PerangsanganEntry(
      id: json['rangsangID']?.toString(),
      tanggal: _string(json['tanggal']),
      irisan: _string(json['irisan']),
      lamaNira: _string(json['lama_nira']),
      tainaKete: _string(json['taina_kete']),
      tainaRara: _string(json['taina_rara']),
      simewu: _string(json['simewu']),
    );
  }

  PerangsanganEntry copyWith({
    String? id,
    String? tanggal,
    String? irisan,
    String? lamaNira,
    String? tainaKete,
    String? tainaRara,
    String? simewu,
  }) {
    return PerangsanganEntry(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      irisan: irisan ?? this.irisan,
      lamaNira: lamaNira ?? this.lamaNira,
      tainaKete: tainaKete ?? this.tainaKete,
      tainaRara: tainaRara ?? this.tainaRara,
      simewu: simewu ?? this.simewu,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rangsangID': id,
      'tanggal': tanggal,
      'irisan': irisan,
      'lama_nira': lamaNira,
      'taina_kete': tainaKete,
      'taina_rara': tainaRara,
      'simewu': simewu,
    };
  }
}

class ProduksiFormData {
  final String? caraPerangsangan;
  final String? pengawetNira;
  final String? filePhoto2;
  final List<PerangsanganEntry> entries;

  const ProduksiFormData({
    this.caraPerangsangan,
    this.pengawetNira,
    this.filePhoto2,
    this.entries = const [],
  });

  factory ProduksiFormData.fromJson(Map<String, dynamic> json) {
    List<PerangsanganEntry> _entries() {
      final source = json['rangsang'];
      if (source is List) {
        return source
            .whereType<Map<String, dynamic>>()
            .map(PerangsanganEntry.fromJson)
            .toList();
      }
      return [];
    }

    String? _string(dynamic value) {
      if (value == null) return null;
      final str = value.toString().trim();
      return str.isEmpty ? null : str;
    }

    return ProduksiFormData(
      caraPerangsangan: _string(json['cara_perangsangan']),
      pengawetNira: _string(json['pengawet_nira']),
      filePhoto2: _string(json['file_photo2']),
      entries: _entries(),
    );
  }
}
