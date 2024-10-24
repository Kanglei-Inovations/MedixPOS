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
  // Initialize controllers in the constructor
  final TextEditingController nameController;
  final TextEditingController stockController;
  final TextEditingController priceController;
  final TextEditingController salePriceController;
  final TextEditingController brandController;
  final TextEditingController unitController;
  EditMedicineDialog({
    Key? key,
    required this.id,
    required this.name,
    required this.price,
    required this.salePrice,
    required this.stock,
    required this.brand, required this.unit,
  })  : nameController = TextEditingController(text: name),
        stockController = TextEditingController(text: stock.toString()),
        priceController = TextEditingController(text: price.toString()),
        salePriceController = TextEditingController(text: salePrice.toString()),
        brandController = TextEditingController(text: brand),
        unitController = TextEditingController(text: unit),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Medicine'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Medicine Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: stockController,
              decoration: InputDecoration(
                labelText: 'Stock',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Strike MRP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: salePriceController,
              decoration: InputDecoration(
                labelText: 'Sale Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: unitController,
              decoration: InputDecoration(
                labelText: 'Unit Type',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: brandController,
              decoration: InputDecoration(
                labelText: 'Brand',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Call updateMedicine method from your provider
            Provider.of<MedicineProvider>(context, listen: false).updateMedicine(
              id,
              nameController.text,
              double.tryParse(priceController.text) ?? 0,
              double.tryParse(salePriceController.text) ?? 0,
              int.tryParse(stockController.text) ?? 0,
              unitController.text,
              brandController.text,
            );
            // Close the dialog
            Navigator.of(context).pop();
          },
          child: Text('Update Medicine'),
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
}
