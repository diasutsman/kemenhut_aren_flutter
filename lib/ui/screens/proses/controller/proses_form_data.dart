// lib/ui/screens/proses/controller/proses_form_data.dart
//
// Data structures for the Proses tab, mirroring the legacy model so we can
// hydrate the Flutter UI with backend payloads.

class ProsesEntry {
  final String tglMulai;
  final String tglAkhir;
  final double panjangCm;
  final double diameterCm;
  final String lamaNetes;
  final String niraPagi;
  final String niraSore;
  final String brixPagi;
  final String brixSore;
  final String? lastUpdate;

  const ProsesEntry({
    required this.tglMulai,
    required this.tglAkhir,
    required this.panjangCm,
    required this.diameterCm,
    required this.lamaNetes,
    required this.niraPagi,
    required this.niraSore,
    required this.brixPagi,
    required this.brixSore,
    this.lastUpdate,
  });

  factory ProsesEntry.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    String _string(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    return ProsesEntry(
      tglMulai: _string(json['tgl_mulai']),
      tglAkhir: _string(json['tgl_akhir']),
      panjangCm: _toDouble(json['panjang_cm']),
      diameterCm: _toDouble(json['diameter_cm']),
      lamaNetes: _string(json['lama_netes']),
      niraPagi: _string(json['nira_pagi']),
      niraSore: _string(json['nira_sore']),
      brixPagi: _string(json['brix_pagi']),
      brixSore: _string(json['brix_sore']),
      lastUpdate: json['last_update']?.toString(),
    );
  }

  ProsesEntry copyWith({
    String? tglMulai,
    String? tglAkhir,
    double? panjangCm,
    double? diameterCm,
    String? lamaNetes,
    String? niraPagi,
    String? niraSore,
    String? brixPagi,
    String? brixSore,
    String? lastUpdate,
  }) {
    return ProsesEntry(
      tglMulai: tglMulai ?? this.tglMulai,
      tglAkhir: tglAkhir ?? this.tglAkhir,
      panjangCm: panjangCm ?? this.panjangCm,
      diameterCm: diameterCm ?? this.diameterCm,
      lamaNetes: lamaNetes ?? this.lamaNetes,
      niraPagi: niraPagi ?? this.niraPagi,
      niraSore: niraSore ?? this.niraSore,
      brixPagi: brixPagi ?? this.brixPagi,
      brixSore: brixSore ?? this.brixSore,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tgl_mulai': tglMulai,
      'tgl_akhir': tglAkhir,
      'panjang_cm': panjangCm,
      'diameter_cm': diameterCm,
      'lama_netes': lamaNetes,
      'nira_pagi': niraPagi,
      'nira_sore': niraSore,
      'brix_pagi': brixPagi,
      'brix_sore': brixSore,
      'last_update': lastUpdate,
    };
  }
}

class ProsesFormData {
  final List<ProsesEntry> entries;

  const ProsesFormData({
    this.entries = const [],
  });

  factory ProsesFormData.fromJson(Map<String, dynamic> json) {
    List<ProsesEntry> _entries() {
      final src = json['proses'];
      if (src is List) {
        return src
            .whereType<Map<String, dynamic>>()
            .map(ProsesEntry.fromJson)
            .toList();
      }
      return [];
    }

    return ProsesFormData(entries: _entries());
  }
}
