// lib/ui/screens/product/controller/product_form_data.dart
//
// Structures to hydrate the Produk tab with legacy data.

class ProductEntry {
  final String productName;
  final double price;
  final String satuan;
  final String? lastUpdate;

  const ProductEntry({
    required this.productName,
    required this.price,
    required this.satuan,
    this.lastUpdate,
  });

  factory ProductEntry.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    String _string(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    return ProductEntry(
      productName: _string(json['productName']),
      price: _toDouble(json['price']),
      satuan: _string(json['satuan']),
      lastUpdate: json['last_update']?.toString(),
    );
  }

  ProductEntry copyWith({
    String? productName,
    double? price,
    String? satuan,
    String? lastUpdate,
  }) {
    return ProductEntry(
      productName: productName ?? this.productName,
      price: price ?? this.price,
      satuan: satuan ?? this.satuan,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'price': price,
      'satuan': satuan,
      'last_update': lastUpdate,
    };
  }
}

class ProductFormData {
  final List<ProductEntry> entries;

  const ProductFormData({
    this.entries = const [],
  });

  factory ProductFormData.fromJson(Map<String, dynamic> json) {
    List<ProductEntry> _entries() {
      final src = json['produk'];
      if (src is List) {
        return src
            .whereType<Map<String, dynamic>>()
            .map(ProductEntry.fromJson)
            .toList();
      }
      return [];
    }

    return ProductFormData(entries: _entries());
  }
}
