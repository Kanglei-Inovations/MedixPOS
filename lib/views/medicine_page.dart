import 'package:flutter/material.dart';
import 'package:medixpos/views/dialog/add_medicine_dialog.dart';
import 'package:medixpos/views/dialog/edit_medicine_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';


class MedicinePage extends StatefulWidget {
  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine List'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Medicines',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: medicineProvider.medicines
            .where((medicine) =>
            medicine.name.toLowerCase().contains(searchQuery))
            .toList()
            .length,
        itemBuilder: (context, index) {
          final medicine = medicineProvider.medicines
              .where((medicine) =>
              medicine.name.toLowerCase().contains(searchQuery))
              .toList()[index];

          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              title: Text(medicine.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Stock: ${medicine.stock}'),
                  Text('MRP: \$${medicine.price}'),
                  Text('Sale Price: \$${medicine.salePrice}'),
                  Text('Brand: ${medicine.brand}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditMedicineDialog(
                          id: medicine.id,
                          name: medicine.name,
                          price: medicine.price,
                          salePrice: medicine.salePrice,
                          stock: medicine.stock,
                          brand: medicine.brand,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Delete medicine functionality
                      medicineProvider.deleteMedicine(medicine.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddMedicineDialog(),  // Show the dialog
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
