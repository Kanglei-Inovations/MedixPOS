import 'package:flutter/material.dart';
import 'package:medixpos/constants.dart';
import 'package:medixpos/providers/medicine_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class SyncScreen extends StatefulWidget {
  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: FutureBuilder(
                future: medicineProvider.scanForOfflineData(), // Scan for offline data
                builder: (context, snapshot) {

                    return DataTable(
                      columnSpacing: defaultPadding,
                      columns: [
                        DataColumn(label: Text("Medicine")),
                        DataColumn(label: Text("Created Date")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: List.generate(
                        medicineProvider.unsyncedData.length,
                            (index) => unsyncedDataRow(medicineProvider.unsyncedData[index], context, medicineProvider),
                      ),
                    );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow unsyncedDataRow(Map<String, dynamic> data, BuildContext context, MedicineProvider medicineProvider) {

    return DataRow(
      cells: [
        DataCell(Text(data['name'] ?? 'Unknown Medicine')),
        DataCell(Text(data['id'] ?? 'Unknown Date')),
        DataCell(
          IconButton(
            
            icon: Icon(Icons.cloud_upload_rounded, color: Colors.red),
            onPressed: () async {
              // Check if the medicine exists in Firestore
              final exists = await medicineProvider.onlinedatacheck(data['name']);
              if (exists) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Already synced: ${data['name']}")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Syncing ${data['name']}...")),
                );
                await medicineProvider.synctoonline(data);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Synced ${data['name']} to Firestore!")),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
