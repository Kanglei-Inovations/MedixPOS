class Medicine {
  String id;
  String name;
  double price;
  double salePrice; // Added salePrice field
  int stock;
  String brand; // Added brand field
  String unitType; // Added unitType field

  Medicine({
    required this.id,
    required this.name,
    required this.price,
    required this.salePrice,
    required this.stock,
    required this.brand,
    required this.unitType,
  });

  // Convert to Map for Firebase and SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'salePrice': salePrice,
      'stock': stock,
      'brand': brand,
      'unitType': unitType,
    };
  }

  // From Firestore
  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      salePrice: map['salePrice'],
      stock: map['stock'],
      brand: map['brand'],
      unitType: map['unitType'],
    );
  }
}
