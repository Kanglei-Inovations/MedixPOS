import 'package:flutter/material.dart';
import 'package:medixpos/models/medicine.dart';
import 'package:medixpos/providers/medicine_provider.dart';
import 'package:provider/provider.dart';

class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  List<Medicine> invoiceItems = [];
  double subtotal = 0.0;
  double discount = 0.0;
  double taxRate = 0.0;
  double amountPaid = 0.0;
  String searchQuery = '';
  String paymentType = ''; // New variable to store payment type

  @override
  void initState() {
    super.initState();
  }

  void _calculateTotal() {
    setState(() {
      subtotal = invoiceItems.fold(0, (sum, item) => sum + item.salePrice * item.stock);
    });
  }

  void _addMedicine(Medicine medicine) {
    setState(() {
      invoiceItems.add(medicine);
      _calculateTotal();
    });
  }
// Function to submit invoice
  void _submitOrder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedPaymentType = 'Cash'; // Default selection
        return AlertDialog(
          title: Text("Select Payment Type"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile(
                title: Text("Cash"),
                value: 'Cash',
                groupValue: selectedPaymentType,
                onChanged: (value) {
                  setState(() => selectedPaymentType = value!);
                },
              ),
              RadioListTile(
                title: Text("UPI"),
                value: 'UPI',
                groupValue: selectedPaymentType,
                onChanged: (value) {
                  setState(() => selectedPaymentType = value!);
                },
              ),
              RadioListTile(
                title: Text("Due"),
                value: 'Due',
                groupValue: selectedPaymentType,
                onChanged: (value) {
                  setState(() => selectedPaymentType = value!);
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Submit"),
              onPressed: () {
                setState(() {
                  paymentType = selectedPaymentType;
                });
                // Call provider method to save invoice in SQL database
                Provider.of<MedicineProvider>(context, listen: false)
                    .saveInvoice(invoiceItems, subtotal, discount, taxRate, amountPaid, paymentType);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);
    final filteredMedicines = medicineProvider.medicines.where((medicine) {
      return medicine.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMedicineSearchField(),
            SizedBox(height: 10),
            _buildMedicineList(filteredMedicines),
            SizedBox(height: 10),
            _buildInvoiceTable(),
            SizedBox(height: 10),
            _buildTotalSummary(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitOrder, // Submit Order button
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
        tooltip: 'Submit Order',
      ),
    );
  }

  Widget _buildMedicineSearchField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search Medicine',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        setState(() {
          searchQuery = value; // Update search query
        });
      },
    );
  }

  Widget _buildMedicineList(List<Medicine> medicines) {
    if (searchQuery.isEmpty) {
      return SizedBox.shrink(); // Return an empty widget if searchQuery is empty
    } else if (medicines.isEmpty) {
      return Container(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'No medicines found.',
          style: TextStyle(color: Colors.red),
        ),
      ); // Show message if no medicines match the search
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final medicine = medicines[index];
          return ListTile(
            title: Text(medicine.name),
            subtitle: Text('Price: ${medicine.salePrice.toStringAsFixed(2)}'),
            trailing: ElevatedButton(
              onPressed: () {
                _addMedicine(medicine); // Add selected medicine to invoice
              },
              child: Text('Add'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInvoiceTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Text('Sl. No.'),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text('Item Name'),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Text('Quantity'),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Text('Price'),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Text('Total'),
                ),
              ),
            ],
          ),



          Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: invoiceItems.length,
            itemBuilder: (context, index) {
              final item = invoiceItems[index];
              return
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('${index + 1}'),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(item.name),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: TextFormField(
                          initialValue: item.stock.toString(),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(isDense: true, border: InputBorder.none), // Remove border
                          textAlign: TextAlign.center, // Center align text in the input field
                          onChanged: (value) {
                            setState(() {
                              item.stock = int.tryParse(value) ?? item.stock;
                              _calculateTotal();
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('${item.salePrice.toStringAsFixed(2)}'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('${(item.salePrice * item.stock).toStringAsFixed(2)}'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          invoiceItems.removeAt(index);
                          _calculateTotal();
                        });
                      },
                    ),
                  ],
                )
              ;


            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSummary() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Subtotal'),
            trailing: Text(subtotal.toStringAsFixed(2),),
          ),
          ListTile(
            title: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Discount'),
              onChanged: (value) {
                setState(() {
                  discount = double.tryParse(value) ?? 0.0;
                  _calculateTotal();
                });
              },
            ),
            trailing: Text('Discount: $discount'),
          ),
          ListTile(
            title: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Tax Rate (%)'),
              onChanged: (value) {
                setState(() {
                  taxRate = double.tryParse(value) ?? 0.0;
                  _calculateTotal();
                });
              },
            ),
          ),
          ListTile(
            title: Text('Total After Tax'),
            trailing: Text((subtotal - discount + (subtotal * taxRate / 100)).toStringAsFixed(2)),
          ),
          ListTile(
            title: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount Paid'),
              onChanged: (value) {
                setState(() {
                  amountPaid = double.tryParse(value) ?? 0.0;
                  _calculateTotal();
                });
              },
            ),
          ),
          ListTile(
            title: Text('Amount Due'),
            trailing: Text((subtotal - discount + (subtotal * taxRate / 100) - amountPaid).toStringAsFixed(2)),
          ),
        ],
      ),
    );
  }
}
