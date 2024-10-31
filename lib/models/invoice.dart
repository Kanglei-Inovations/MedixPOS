class Invoice {
  final String id;
  final double subtotal;
  final double discount;
  final double taxRate;
  final double amountPaid;
  final String paymentType;
  final DateTime createdAt;

  Invoice({
    required this.id,
    required this.subtotal,
    required this.discount,
    required this.taxRate,
    required this.amountPaid,
    required this.paymentType,
    required this.createdAt,
  });

  // Convert a map to an Invoice instance
  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      subtotal: map['subtotal'],
      discount: map['discount'],
      taxRate: map['taxRate'],
      amountPaid: map['amountPaid'],
      paymentType: map['paymentType'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Convert an Invoice instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subtotal': subtotal,
      'discount': discount,
      'taxRate': taxRate,
      'amountPaid': amountPaid,
      'paymentType': paymentType,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
