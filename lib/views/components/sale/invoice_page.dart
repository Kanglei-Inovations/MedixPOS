import 'package:flutter/material.dart';
import 'package:medixpos/constants.dart';
import 'package:medixpos/models/medicine.dart';
import 'package:medixpos/providers/medicine_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  List<Medicine> invoiceItems = [];
  double subtotal = 0.0;
  double discount = 0.0;
    double afterdiscount = 0.0;
  double taxRate = 0.0;
  double taxAmount = 0.0; // New variable for tax amount
  double total = 0.0; // New variable for total amount
  double amountPaid = 0.0;
  String searchQuery = '';
  String paymentType = ''; // New variable to store payment type
  String? selectedMedicineName;
  final TextEditingController textEditingController = TextEditingController();
  String? selectedPaymentType = 'Cash';
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }
  void _calculateTotal() {
    setState(() {
      subtotal = invoiceItems.fold(0, (sum, item) => sum + item.salePrice * item.stock);
      afterdiscount = subtotal - discount; // Calculate amount after discount
      taxAmount = afterdiscount * (taxRate / 100); // Calculate tax amount
      total = afterdiscount + taxAmount; // Calculate total
    });
  }

  void _addMedicine(Medicine medicine) {
    setState(() {
      // Only add the medicine if it's not already in the invoiceItems list
      if (!invoiceItems.contains(medicine)) {
        invoiceItems.add(medicine);
        _calculateTotal();
      }
    });
  }

// Function to submit invoice
  Future<void> _submitOrder() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Collect Payment'),
        duration: Duration(seconds: 2),
      ),
    );
    // Call provider method to save invoice in SQL database
    await Provider.of<MedicineProvider>(context, listen: false)
        .saveInvoice(invoiceItems, subtotal, discount, taxRate, amountPaid, paymentType);
    Navigator.of(context).pop();

  }
  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);
    final filteredMedicines = medicineProvider.medicines.where((medicine) {
      return medicine.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text('Invoice Page')), // Title of the AppBar
            SizedBox(width: 8), // Optional spacing between title and search field
            Expanded(
              child: _buildMedicineSearchField(filteredMedicines),
            ),

          ],
        ),
        backgroundColor: secondaryColor,

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            _buildInvoiceTable(),
            SizedBox(height: 10),
            _buildTotalSummary(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        onPressed: _submitOrder, // Submit Order function
        label: Text('Save Sell'), // Adds label text to the button
        icon: Icon(Icons.arrow_forward),
        backgroundColor: Colors.green,
        tooltip: 'Do not Forget to Received Money ', // Detailed tooltip
      ),
    );
  }

  Widget _buildMedicineSearchField(List<Medicine> filteredMedicines) {
    // Filter medicines that are not already in invoiceItems
    List<Medicine> availableMedicines = filteredMedicines
        .where((medicine) => !invoiceItems.contains(medicine))
        .toList();

    return Center(
      child: TypeAheadField<Medicine>(
        suggestionsCallback: (query)  {
          // Convert the Iterable to a List before returning
          return availableMedicines
              .where((medicine) => medicine.name.toLowerCase().contains(query.toLowerCase()))
              .toList(); // Ensure the return type is List<Medicine>
        },
        builder: (context, controller, focusNode) {
          return TextFormField(
            controller: controller,
            autofocus: true,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: "Search", // Updated hint text
              fillColor: bgColor, // Background color
              filled: true, // Enable filled background
              border: OutlineInputBorder(
                borderSide: BorderSide.none, // No border line
                borderRadius: const BorderRadius.all(Radius.circular(10)), // Rounded corners
              ),
              suffixIcon: InkWell(
                onTap: () {
                  // Add your search logic here, e.g., calling a search function
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal:  defaultPadding * 0.76, vertical: defaultPadding * 0.76), // Adjust padding as needed
                  margin: EdgeInsets.only(left: defaultPadding / 2), // Adjust margin as needed
                  decoration: BoxDecoration(
                    color: primaryColor, // Background color for the icon container
                    borderRadius: const BorderRadius.all(Radius.circular(10)), // Rounded corners
                  ),
                  child: Icon(Icons.search_sharp), // Search icon
                ),
              ),
            ),

          );
        },
        itemBuilder: (context, Medicine suggestion) {
          return Container(
            decoration: BoxDecoration(
              color: secondaryColor, // Background color of the item
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), // Shadow color
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2), // Shadow position
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(Icons.medical_services, color: Colors.grey),
              title: Text(suggestion.name, style: TextStyle(fontSize: 14)),
            ),
          );
        },
        onSelected: (Medicine selectedMedicine) {
          setState(() {
            selectedMedicineName = selectedMedicine.name;
            _addMedicine(selectedMedicine); // Add the selected medicine to the invoice
          });
        },
      ),
    );
  }

  Widget _buildInvoiceTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Container(
            color: primaryColor, // Background color for header
            padding: EdgeInsets.symmetric(vertical: 8), // Padding for header row
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(child: Text('Sl. No.')),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Item Name'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Brand Name'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(child: Text('Quantity')),
                ),
                Expanded(
                  flex: 1,
                  child: Center(child: Text('Price')),
                ),
                Expanded(
                  flex: 1,
                  child: Center(child: Text('Total')),
                ),
                SizedBox(width: 40), // Extra space for delete button alignment
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey),

          // Data Rows
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: invoiceItems.length,
            itemBuilder: (context, index) {
              final item = invoiceItems[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 8), // Padding for data rows
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(child: Text('${index + 1}')),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(item.name),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(item.brand),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 40, // Set the desired height here

                              child: TextFormField(
                                initialValue: item.stock.toString(),
                                autofocus: true,
                                autocorrect: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  isDense: true,
                                  fillColor: secondary2Color, // Set input background color
                                  filled: true, // Enables background color
                                  contentPadding: EdgeInsets.symmetric(vertical: 10), // Adjust padding for better text centering
                                  border: InputBorder.none,
                                ),
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  setState(() {
                                    item.stock = int.tryParse(value) ?? item.stock;
                                    _calculateTotal();
                                  });
                                },
                              ),
                            )

                          ),

                          Text(" / ${item.unitType}"), // Text widget to display the unit type
                        ],
                      )

                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(item.salePrice.toStringAsFixed(2)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text((item.salePrice * item.stock).toStringAsFixed(2)),
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildTotalSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // Aligns the container to the right
      children: [
        Card(
          elevation: 5,
          child: Container(
            width: 450,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start, // Changed to start for better alignment
              children: [
                ListTile(
                  title: Text('Subtotal'),
                  trailing: Text(subtotal.toStringAsFixed(2)),
                ),
                ListTile(
                  title: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      isDense: true,
                      fillColor: secondary2Color,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: 'Discount (₹)',
                    ),
                    onChanged: (value) {
                      setState(() {
                        discount = double.tryParse(value) ?? 0.0;
                        _calculateTotal();
                      });
                    },
                  ),
                  trailing: Text('After Dis: ₹${afterdiscount.toStringAsFixed(2)}'),
                ),
                ListTile(
                  title: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isDense: true,
                      fillColor: secondary2Color,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: 'Tax Rate (%)',
                    ),
                    onChanged: (value) {
                      setState(() {
                        taxRate = double.tryParse(value) ?? 0.0;
                        _calculateTotal();
                      });
                    },
                  ),
                  trailing: Column(
                    children: [
                      Text('Tax Amount: ₹ ${taxAmount.toStringAsFixed(2)}'),
                      Text(
                        'After Tax: ₹ ${total.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isDense: true,
                      fillColor: secondaryColor,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: 'Paid Amount',
                    ),
                    onChanged: (value) {
                      setState(() {
                        amountPaid = double.tryParse(value) ?? 0.0;
                        _calculateTotal();
                      });
                    },
                  ),
                  trailing: Column(
                    children: [
                      Text('Amount Due:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        (total - amountPaid).toStringAsFixed(2),
                        style: TextStyle(color: Colors.redAccent, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10), // Added spacing before the payment options
                Text("Payment Type:", style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space between radio buttons
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: Text("Cash"),
                        value: 'Cash',
                        groupValue: selectedPaymentType,
                        onChanged: (value) {
                          setState(() => selectedPaymentType = value!);
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text("UPI"),
                        value: 'UPI',
                        groupValue: selectedPaymentType,
                        onChanged: (value) {
                          setState(() => selectedPaymentType = value!);
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text("Due"),
                        value: 'Due',
                        groupValue: selectedPaymentType,
                        onChanged: (value) {
                          setState(() => selectedPaymentType = value!);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10), // Ensure consistent spacing
              ],
            ),
          ),
        ),

      ],
    );
  }

}
