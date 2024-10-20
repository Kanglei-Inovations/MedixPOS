class Medicine {
  String id;
  String name;
  double mrp;           // Maximum Retail Price
  double salePrice;      // Sale price for the customer
  int stock;            // Stock quantity
  String brand;         // Brand of the medicine
  String unitType;      // Unit type (e.g., box, strip, etc.)

  Medicine({
    required this.id,
    required this.name,
    required this.mrp,
    required this.salePrice,
    required this.stock,
    required this.brand,
    required this.unitType,
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mrp': mrp,
      'salePrice': salePrice,
      'stock': stock,
      'brand': brand,
      'unitType': unitType,
    };
  }

  // From Firestore (when fetching data from Firebase)
  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      mrp: map['mrp'],
      salePrice: map['salePrice'],
      stock: map['stock'],
      brand: map['brand'],
      unitType: map['unitType'],
    );
  }
}
