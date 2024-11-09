import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medixpos/views/dialog/add_medicine_dialog.dart';
import 'package:medixpos/views/dialog/edit_medicine_dialog.dart';
import 'package:medixpos/constants.dart';
import 'package:medixpos/responsive.dart';

class MedicineScreen extends StatelessWidget {
  const MedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String searchQuery = '';

    // Stream for real-time updates from Firebase Firestore
    final medicineStream = FirebaseFirestore.instance
        .collection('medicines')
        .snapshots();

    return SingleChildScrollView(
      child: Padding(
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
            StreamBuilder<QuerySnapshot>(
              stream: medicineStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Center(child: Text("No medicines available"));
                }

                final medicines = snapshot.data!.docs.where((doc) =>
                    doc['name']
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase())).toList();

                return SizedBox(
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
                          (index) => medicineDataRow(medicines[index], context),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

DataRow medicineDataRow(
    QueryDocumentSnapshot medicineDoc, BuildContext context) {
  final medicine = medicineDoc.data() as Map<String, dynamic>;

  return DataRow(
    cells: [
      DataCell(Text(medicine['name'])),
      DataCell(
        medicine['salePrice'] != null && medicine['salePrice'] > 0
            ? Row(
          children: [
            Text(
              '\$${medicine['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.white38,
                fontSize: 18,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '\$${medicine['salePrice']}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        )
            : Text('\$${medicine['price']}'), // Only show price if no sale price
      ),
      DataCell(Text(medicine['stock'].toString())),
      if (!Responsive.isMobile(context)) DataCell(Text(medicine['unitType'])),
      if (!Responsive.isMobile(context)) DataCell(Text(medicine['brand'])),
      DataCell(
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => EditMedicineDialog(
                    id: medicineDoc.id,
                    name: medicine['name'],
                    price: medicine['price'],
                    salePrice: medicine['salePrice'],
                    stock: medicine['stock'],
                    unit: medicine['unitType'],
                    brand: medicine['brand'],
                    barcode: medicine['barcode'],
                    mfgDate: DateTime.parse(medicine['mfgDate']),
                    expiryDate: DateTime.parse(medicine['expiryDate']),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('medicines')
                    .doc(medicineDoc.id)
                    .delete();
              },
            ),
          ],
        ),
      ),
    ],
  );
}
