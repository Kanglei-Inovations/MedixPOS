import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:medixpos/constants.dart';
import 'package:medixpos/models/medicine.dart';
import 'package:provider/provider.dart';
import 'package:medixpos/providers/medicine_provider.dart';

class AddMedicineDialog extends StatefulWidget {
  @override
  _AddMedicineDialogState createState() => _AddMedicineDialogState();
}

class _AddMedicineDialogState extends State<AddMedicineDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();

  DateTime mfgDate = DateTime.now();
  DateTime expiryDate = DateTime.now();
  String unitType = 'Strip'; // Default unit type

  // Method to clear all fields
  Future<void> clearFields() async {
    _nameController.clear();
    _priceController.clear();
    _salePriceController.clear();
    _stockController.clear();
    _brandController.clear();
    _barcodeController.clear();
    setState(() {
      unitType = 'Strip';
      mfgDate = DateTime.now();
      expiryDate = DateTime.now();
    });
    await Future.delayed(Duration(milliseconds: 50));
    _formKey.currentState?.reset(); // Reset form validation states
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _nameController.dispose();
    _priceController.dispose();
    _salePriceController.dispose();
    _stockController.dispose();
    _brandController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }
// Barcode scanning logic
  Future<void> _scanBarcode() async {
    String scannedBarcode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',  // Color of the scan line
      'Cancel',   // Text for cancel button
      true,       // Whether to show the flash icon
      ScanMode.BARCODE, // Use BARCODE scan mode
    );

    if (scannedBarcode != '-1') {
      setState(() {
        _barcodeController.text = scannedBarcode; // Update field with scanned result
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Medicine'),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextFormField('Medicine Name', _nameController),
                _buildTextFormField('Brand', _brandController),
                Row(
                  children: [
                    Expanded(child: _buildNumberFormField('MRP', _priceController)),
                    SizedBox(width: 10),
                    Expanded(child: _buildNumberFormField('Sale Price', _salePriceController)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildNumberFormField('Stock', _stockController)),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: unitType,
                        decoration: InputDecoration(labelText: 'Unit Type'),
                        items: ['Strip', 'Box'].map((type) {
                          return DropdownMenuItem(value: type, child: Text(type));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            unitType = value ?? 'Strip';
                          });
                        },
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(child: _buildTextFormField('Barcode', _barcodeController)),
                    IconButton(
                      icon: Icon(Icons.qr_code_scanner),
                      onPressed: () {
                        _scanBarcode();
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildDatePicker('Manufacture', mfgDate, (date) => mfgDate = date)),
                    SizedBox(width: 10),
                    Expanded(child: _buildDatePicker('Expiry', expiryDate, (date) => expiryDate = date)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final newMedicine = Medicine(
                id: DateTime.now().toString(),
                name: _nameController.text,
                price: double.tryParse(_priceController.text) ?? 0.0,
                salePrice: double.tryParse(_salePriceController.text) ?? 0.0,
                stock: int.tryParse(_stockController.text) ?? 0,
                brand: _brandController.text,
                unitType: unitType,
                barcode: _barcodeController.text,
                mfgDate: mfgDate,
                expiryDate: expiryDate,
              );

              // Get the MedicineProvider from the context
              final medicineProvider = Provider.of<MedicineProvider>(context, listen: false);
              await medicineProvider.addMedicine(newMedicine);
              clearFields(); // Clear fields without closing the dialog
            }
          },
          child: Text('Add Medicine'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  // Helper functions to build form fields
  Widget _buildTextFormField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildNumberFormField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker(String label, DateTime initialDate, Function(DateTime) onDatePicked) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('$label: ${initialDate.toLocal()}'.split(' ')[0]),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null && pickedDate != initialDate) {
          setState(() {
            onDatePicked(pickedDate);
          });
        }
      },
    );
  }
}
