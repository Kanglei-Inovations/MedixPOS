import 'package:flutter/material.dart';
import 'package:medixpos/providers/medicine_provider.dart';
import 'package:medixpos/responsive.dart';
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
  Widget build(BuildContext context) {
    final invoiceProvider = Provider.of<MedicineProvider>(context);

    List invoices = invoiceProvider.invoices
        .where((invoice) => invoice.id.toLowerCase().contains(searchQuery))
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Invoice List",
              style: Theme.of(context).textTheme.titleMedium,
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
