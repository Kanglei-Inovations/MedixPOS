class CompanySettings {
  int? id; // Ensure this is nullable if not always set
  String companyName;
  String businessType;
  String ownerName;
  String address;
  String phoneNumber;
  String logoPath;
  String gstNumber;
  String registrationNumber;
  String bankAccountNumber;
  String ifscCode;
  String accountName;
  String upiAddress;

  CompanySettings({
    this.id,
    required this.companyName,
    required this.businessType,
    required this.ownerName,
    required this.address,
    required this.phoneNumber,
    required this.logoPath,
    required this.gstNumber,
    required this.registrationNumber,
    required this.bankAccountNumber,
    required this.ifscCode,
    required this.accountName,
    required this.upiAddress,
  });

  // Convert a CompanySettings object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyName': companyName,
      'businessType': businessType,
      'ownerName': ownerName,
      'address': address,
      'phoneNumber': phoneNumber,
      'logoPath': logoPath,
      'gstNumber': gstNumber,
      'registrationNumber': registrationNumber,
      'bankAccountNumber': bankAccountNumber,
      'ifscCode': ifscCode,
      'accountName': accountName,
      'upiAddress': upiAddress,
    };
  }

  // Create a CompanySettings object from a Map
  factory CompanySettings.fromMap(Map<String, dynamic> map) {
    return CompanySettings(
      id: map['id'] as int?,
      companyName: map['companyName'] as String,
      businessType: map['businessType'] as String,
      ownerName: map['ownerName'] as String,
      address: map['address'] as String,
      phoneNumber: map['phoneNumber'] as String,
      logoPath: map['logoPath'] as String,
      gstNumber: map['gstNumber'] as String,
      registrationNumber: map['registrationNumber'] as String,
      bankAccountNumber: map['bankAccountNumber'] as String,
      ifscCode: map['ifscCode'] as String,
      accountName: map['accountName'] as String,
      upiAddress: map['upiAddress'] as String,
    );
  }
}
