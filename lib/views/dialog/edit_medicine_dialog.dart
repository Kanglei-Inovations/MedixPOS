import 'package:flutter/material.dart';
import 'package:medixpos/providers/medicine_provider.dart';
import 'package:provider/provider.dart';

class EditMedicineDialog extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final double salePrice;
  final int stock;
  final String brand;
  final String unit;
  final String barcode;
  final DateTime mfgDate;
  final DateTime expiryDate;

  final TextEditingController nameController;
  final TextEditingController stockController;
  final TextEditingController priceController;
  final TextEditingController salePriceController;
  final TextEditingController brandController;
  final TextEditingController unitController;
  final TextEditingController barcodeController;

  EditMedicineDialog({
    Key? key,
    required this.id,
    required this.name,
    required this.price,
    required this.salePrice,
    required this.stock,
    required this.brand,
    required this.unit,
    required this.barcode,
    required this.mfgDate,
    required this.expiryDate,
  })  : nameController = TextEditingController(text: name),
        stockController = TextEditingController(text: stock.toString()),
        priceController = TextEditingController(text: price.toString()),
        salePriceController = TextEditingController(text: salePrice.toString()),
        brandController = TextEditingController(text: brand),
        unitController = TextEditingController(text: unit),
        barcodeController = TextEditingController(text: barcode),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Medicine'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(nameController, 'Medicine Name'),
            _buildTextField(stockController, 'Stock', isNumeric: true),
            _buildTextField(priceController, 'Strike MRP', isNumeric: true),
            _buildTextField(salePriceController, 'Sale Price', isNumeric: true),
            _buildTextField(unitController, 'Unit Type'),
            _buildTextField(brandController, 'Brand'),
            _buildTextField(barcodeController, 'Barcode'),
            _buildDateTile(context, 'Munufature Date', mfgDate, (picked) {
              // Handle picked purchase date here if using external state management.
            }),
            _buildDateTile(context, 'Expiry Date', expiryDate, (picked) {
              // Handle picked expiry date here if using external state management.
            }),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Provider.of<MedicineProvider>(context, listen: false).updateMedicine(
              id,
              nameController.text,
              double.tryParse(priceController.text) ?? 0,
              double.tryParse(salePriceController.text) ?? 0,
              int.tryParse(stockController.text) ?? 0,
              unitController.text,
              brandController.text,
              barcodeController.text,
              mfgDate,
              expiryDate,
            );
            Navigator.of(context).pop();
          },
          child: Text('Update Medicine'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  Widget _buildDateTile(BuildContext context, String label, DateTime date, Function(DateTime) onDatePicked) {
    return ListTile(
      title: Text('$label: ${date.toLocal()}'.split(' ')[0]),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          onDatePicked(pickedDate);
        }
      },
    );
  }
}
