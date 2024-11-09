class Medicine {
  final String id;
  final String name;
  final double price;
  final double salePrice;
  late final int stock;
  final String brand;
  final String unitType;
  final String barcode;
  final DateTime mfgDate;
  final DateTime expiryDate;

  Medicine({
    required this.id,
    required this.name,
    required this.price,
    required this.salePrice,
    required this.stock,
    required this.brand,
    required this.unitType,
    required this.barcode,
    required this.mfgDate,
    required this.expiryDate,
  });

  // Convert object to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'salePrice': salePrice,
      'stock': stock,
      'brand': brand,
      'unitType': unitType,
      'barcode': barcode,
      'mfgDate': mfgDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
    };
  }
  // Add this method for converting Medicine to a map for an invoice
  Map<String, dynamic> toMapForInvoice(String invoiceId) {
    return {
      'invoiceId': invoiceId,
      'name': name,
      'price': price,
      'salePrice': salePrice,
      'stock': stock,
      'brand': brand,
      'unitType': unitType,
      'barcode': barcode,
      'mfgDate': mfgDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
    };
  }
  // Optionally, add a setter for stock if you want to customize it
  set setStock(int value) {
    stock = value;
  }
  // Convert map to Medicine object
  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      salePrice: map['salePrice'],
      stock: map['stock'],
      brand: map['brand'],
      unitType: map['unitType'],
      barcode: map['barcode'],
      mfgDate: DateTime.parse(map['mfgDate']),
      expiryDate: DateTime.parse(map['expiryDate']),
    );
  }
}
