import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medixpos/providers/medicine_provider.dart';
import 'package:medixpos/responsive.dart';
import 'package:medixpos/views/components/header.dart';
import 'package:medixpos/views/components/sale/invoice_page.dart';
import 'package:provider/provider.dart';
import 'package:medixpos/constants.dart';

class InvoiceList extends StatefulWidget {
  const InvoiceList({super.key});

  @override
  _InvoiceListState createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
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
    final invoiceProvider = Provider.of<MedicineProvider>(context);

    List invoices = invoiceProvider.invoices
        .where((invoice) => invoice.id.toLowerCase().contains(searchQuery))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Invoice List",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end, // Align at the bottom of the row
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              ElevatedButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding * 1.5,
                    vertical:
                    defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                  ),
                ),
                onPressed: () {
                  Get.to(InvoicePage(),transition: Transition.fadeIn);

                },
                icon: Icon(Icons.add),
                label: Text("New Sales"),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: [
                // DataColumn(label: Text("Customer Name")),
                DataColumn(label: Text("Total Amount")),
                DataColumn(label: Text("Discount")),
                if (!Responsive.isMobile(context)) DataColumn(label: Text("Payment Type")),
                if (!Responsive.isMobile(context)) DataColumn(label: Text("Date")),
                DataColumn(label: Text("Actions")),
              ],
              rows: List.generate(
                invoices.length,
                    (index) => invoiceDataRow(invoices[index], context, invoiceProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow invoiceDataRow(invoice, BuildContext context, MedicineProvider invoiceProvider) {
  return DataRow(
    cells: [
      // DataCell(Text(invoice.customerName)),
      DataCell(Text('\$${invoice.amountPaid.toString()}')),
      DataCell(Text('${invoice.discount}%')),
      if (!Responsive.isMobile(context)) DataCell(Text(invoice.paymentType)),
      if (!Responsive.isMobile(context)) DataCell(Text(invoice.createdAt.toString())),
      DataCell(
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white,),
              onPressed: () {

              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red,),
              onPressed: () {
                // invoiceProvider.deleteInvoice(invoice.id);
              },
            ),
          ],
        ),
      ),
    ],
  );
}
