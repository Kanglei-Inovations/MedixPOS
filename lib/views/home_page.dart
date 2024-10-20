import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';
import '../models/medicine.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacy App'),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () {
              // Sync data with Firebase
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: medicineProvider.medicines.length,
        itemBuilder: (context, index) {
          final medicine = medicineProvider.medicines[index];
          return ListTile(
            title: Text(medicine.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Brand: ${medicine.brand}'),
                Text('MRP: ₹${medicine.mrp}'),
                Text('Sale Price: ₹${medicine.salePrice}'),
                Text('Stock: ${medicine.stock} ${medicine.unitType}(s)'),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add a new medicine
          medicineProvider.addMedicine(
            Medicine(
              id: DateTime.now().toString(),
              name: 'Paracetamol',
              mrp: 50.0,
              salePrice: 45.0,
              stock: 100,
              brand: 'XYZ Pharma',
              unitType: 'strip',
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
