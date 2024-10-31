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

  factory Medicine.fromMap(Map<String, dynamic> map) {
    print('Received map: $map'); // Log the map
    return Medicine(
      id: map['id']?? 'Unknown', // Handle null value
      name: map['name']?? 'Unknown', // Handle null value
      price: map['price'] != null ? map['price'].toDouble() : 0.0,
      salePrice: map['salePrice'] != null ? map['salePrice'].toDouble() : 0.0,
      stock: map['stock'] != null ? map['stock'] : 0,
      brand: map['brand']?? 'Unknown', // Handle null value
      unitType: map['unitType']?? 'Unknown', // Handle null value
    );
  }
  Map<String, dynamic> toMapForInvoice(String invoiceId) {
    return {
      'id': this.id,
      'name': this.name,
      'price': this.price,
      'salePrice': this.salePrice,
      'stock': this.stock,
      'brand': this.brand,
      'unitType': this.unitType,
      'invoiceId': invoiceId, // Link to the invoice
    };
  }

}
