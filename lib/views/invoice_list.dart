import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medixpos/views/components/sale/invoice_page.dart';
import 'package:medixpos/constants.dart';
import 'package:medixpos/responsive.dart';

class InvoiceList extends StatelessWidget {
  const InvoiceList({super.key});

  @override
  Widget build(BuildContext context) {
    String searchQuery = '';

    // Real-time stream of invoices from Firebase Firestore
    final invoiceStream = FirebaseFirestore.instance
        .collection('invoices')
        .snapshots();

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(color: secondaryColor),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Invoice List",
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
                        vertical: defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                      ),
                    ),
                    onPressed: () {
                      Get.to(InvoicePage(), transition: Transition.fadeIn);
                    },
                    icon: Icon(Icons.add),
                    label: Text("New Sales"),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: invoiceStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text("No invoices available"));
                  }

                  final invoices = snapshot.data!.docs.where((doc) =>
                      doc['id'].toString().toLowerCase().contains(searchQuery.toLowerCase())).toList();

                  return SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      columnSpacing: defaultPadding,
                      columns: [
                        DataColumn(label: Text("Total Amount")),
                        DataColumn(label: Text("Discount")),
                        if (!Responsive.isMobile(context)) DataColumn(label: Text("Payment Type")),
                        if (!Responsive.isMobile(context)) DataColumn(label: Text("Date")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: List.generate(
                        invoices.length,
                            (index) => invoiceDataRow(invoices[index], context),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

DataRow invoiceDataRow(QueryDocumentSnapshot invoiceDoc, BuildContext context) {
  final invoice = invoiceDoc.data() as Map<String, dynamic>;

  return DataRow(
    cells: [
      DataCell(Text('\$${invoice['amountPaid'].toString()}')),
      DataCell(Text('${invoice['discount']}%')),
      if (!Responsive.isMobile(context)) DataCell(Text(invoice['paymentType'])),
      if (!Responsive.isMobile(context)) DataCell(Text(invoice['createdAt'].toString())),
      DataCell(
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                // Define edit action or open dialog if needed
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('invoices')
                    .doc(invoiceDoc.id)
                    .delete();
              },
            ),
          ],
        ),
      ),
    ],
  );
}
