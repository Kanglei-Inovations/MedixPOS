import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/medicine.dart';
import '../providers/medicine_provider.dart';

class AddMedicine extends StatefulWidget {
  @override
  _AddMedicineState createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double price = 0.0;
  double salePrice = 0.0;
  int stock = 0;
  String brand = '';
  String unitType = '';

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medicine'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
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
                    SizedBox(height: 20),
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

                          Navigator.pop(context); // Go back to the MedicinePage
                        }
                      },
                      child: Text('Add Medicine'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
