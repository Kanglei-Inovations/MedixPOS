import 'package:flutter/material.dart';
import 'package:medixpos/providers/medicine_provider.dart';
import 'package:medixpos/responsive.dart';
import 'package:provider/provider.dart';

import 'package:medixpos/views/dialog/add_medicine_dialog.dart';
import 'package:medixpos/views/dialog/edit_medicine_dialog.dart';
import 'package:medixpos/constants.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  _MedicineScreenState createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Initialize the database when the widget is created
    Future(() async {
      await context.read<MedicineProvider>().initializeDatabase();
      // Optionally, you can setState to rebuild the UI if needed
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);

    List medicines = medicineProvider.medicines
        .where((medicine) =>
        medicine.name.toLowerCase().contains(searchQuery))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Medicine List",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding * 1.5,
                    vertical: defaultPadding /
                        (Responsive.isMobile(context) ? 2 : 1),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddMedicineDialog(),
                  );
                },
                icon: Icon(Icons.add),
                label: Text("Add Medicine"),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: [

                DataColumn(label: Text("Medicine")),
                DataColumn(label: Text("MRP/Price")),
                DataColumn(label: Text("Stock")),
                if (!Responsive.isMobile(context))
                DataColumn(label: Text("Brand")),
                if (!Responsive.isMobile(context))
                DataColumn(label: Text("Unit")),
                DataColumn(label: Text("Actions")),
              ],
              rows: List.generate(
                medicines.length,
                    (index) => medicineDataRow(medicines[index], context, medicineProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow medicineDataRow(medicine, BuildContext context, MedicineProvider medicineProvider) {
  return DataRow(
    cells: [
      DataCell(Text(medicine.name)),

      DataCell(
        medicine.salePrice != null && medicine.salePrice > 0
            ?

        Row(

          children: [
            Text(
              '\$${medicine.price.toString()}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.white38,
                fontSize: 18,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '\$${medicine.salePrice.toString()}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

          ],
        )
            : Text('\$${medicine.price.toString()}'),  // Only show price if no sale price
      ),
      DataCell(Text(medicine.stock.toString())),
      if (!Responsive.isMobile(context))
      DataCell(Text(medicine.unitType)),
      if (!Responsive.isMobile(context))
      DataCell(Text(medicine.brand)),
      DataCell(
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white,),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => EditMedicineDialog(
                    id: medicine.id,
                    name: medicine.name,
                    price: medicine.price,
                    salePrice: medicine.salePrice,
                    stock: medicine.stock,
                    unit: medicine.unitType,
                    brand: medicine.brand,
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red,),
              onPressed: () {
                medicineProvider.deleteMedicine(medicine.id);
              },
            ),
          ],
        ),
      ),
    ],
  );
}
