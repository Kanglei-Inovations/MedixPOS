import 'package:flutter/material.dart';
import 'package:medixpos/models/medicine.dart';
import 'package:medixpos/providers/medicine_provider.dart';
import 'package:provider/provider.dart';


class AddMedicineDialog extends StatefulWidget {
  @override
  _AddMedicineDialogState createState() => _AddMedicineDialogState();
}

class _AddMedicineDialogState extends State<AddMedicineDialog> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double price = 0.0;
  double salePrice = 0.0;
  int stock = 0;
  String brand = '';
  String unitType = '';

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context, listen: false);

    return AlertDialog(
      title: Text('Add Medicine'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Medicine Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter medicine name';
                  }
                  return null;
                },
                onChanged: (value) {
                  name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'MRP'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter MRP';
                  }
                  return null;
                },
                onChanged: (value) {
                  price = double.parse(value);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Sale Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter sale price';
                  }
                  return null;
                },
                onChanged: (value) {
                  salePrice = double.parse(value);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter stock';
                  }
                  return null;
                },
                onChanged: (value) {
                  stock = int.parse(value);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Brand'),
                onChanged: (value) {
                  brand = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Unit Type (e.g., box, strip)'),
                onChanged: (value) {
                  unitType = value;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newMedicine = Medicine(
                id: DateTime.now().toString(),
                name: name,
                price: price,
                salePrice: salePrice,
                stock: stock,
                brand: brand,
                unitType: unitType,
              );

              medicineProvider.addMedicine(newMedicine);
              Navigator.of(context).pop(); // Close the dialog
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
}
