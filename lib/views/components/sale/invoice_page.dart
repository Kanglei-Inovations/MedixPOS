import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:medixpos/constants.dart';
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
    double afterdiscount = 0.0;
  double taxRate = 0.0;
  double taxAmount = 0.0; // New variable for tax amount
  double total = 0.0; // New variable for total amount
  double amountPaid = 0.0;
  String searchQuery = '';
  String paymentType = ''; // New variable to store payment type
  String? selectedMedicineName;
  final TextEditingController textEditingController = TextEditingController();

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
      invoiceItems.add(medicine);
      _calculateTotal();
    });
  }

// Function to submit invoice
  void _submitOrder() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Collect Payment'),
        duration: Duration(seconds: 2),
      ),
    );

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
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<Medicine>(
          isExpanded: true,
          hint: Text(
            'Select Medicine',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: filteredMedicines
              .map((medicine) => DropdownMenuItem(
            value: medicine,
            child: Text(
              medicine.name,
              style: const TextStyle(fontSize: 14),
            ),
          ))
              .toList(),
          value: selectedMedicineName == null
              ? null
              : filteredMedicines.firstWhere((med) => med.name == selectedMedicineName, orElse: () => filteredMedicines[0]),
          onChanged: (Medicine? selectedMedicine) {
            setState(() {
              selectedMedicineName = selectedMedicine?.name;
            });
            if (selectedMedicine != null) {
              _addMedicine(selectedMedicine);
            }
          },
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            width: 500,
            decoration: BoxDecoration(
              color: secondary2Color, // Background color
              borderRadius: BorderRadius.circular(20), // Rounded corners
              boxShadow: const [
                BoxShadow(
                  color: secondaryColor,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.search_sharp,
              color: Colors.white, // Icon color
            ),


          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 500,
            decoration: BoxDecoration(
              // Dropdown background color
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,

          ),
          dropdownSearchData: DropdownSearchData(
            searchController: textEditingController,
            searchInnerWidgetHeight: 80,
            searchInnerWidget: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TextFormField(
                controller: textEditingController,
                autofocus: true,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: "Search", // Updated hint text
                  fillColor: secondaryColor, // Background color
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
                      padding: EdgeInsets.all(defaultPadding * 0.75), // Adjust padding as needed
                      margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2), // Adjust margin as needed
                      decoration: BoxDecoration(
                        color: primaryColor, // Background color for the icon container
                        borderRadius: const BorderRadius.all(Radius.circular(10)), // Rounded corners
                      ),
                      child: Icon(Icons.search_sharp), // Search icon
                    ),
                  ),
                ),

              ),

            ),
            searchMatchFn: (item, searchValue) {
              return (item.value as Medicine)
                  .name
                  .toLowerCase()
                  .contains(searchValue.toLowerCase());
            },
          ),
          customButton: Container(

            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: secondary2Color, // Custom button background color
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Medicine',
                  style: TextStyle(color: Colors.white), // Text color
                ),
                Icon(
                  Icons.search, // Custom icon
                  color: Colors.white,
                ),
              ],
            ),
          ),
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textEditingController.clear();
            }
          },
        ),
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
            width: 450, // Set a fixed width to control the size, if desired
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        fillColor: secondary2Color, // Set input background color
                        filled: true, // Enables background color
                        contentPadding: EdgeInsets.symmetric(vertical: 20), // Adjust padding for better text centering
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none, // No border line
                          borderRadius: const BorderRadius.all(Radius.circular(10)), // Rounded corners
                        ),
                        labelText: 'Discount (₹)'

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
                        fillColor: secondary2Color, // Set input background color
                        filled: true, // Enables background color
                        contentPadding: EdgeInsets.symmetric(vertical: 20), // Adjust padding for better text centering
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none, // No border line
                          borderRadius: const BorderRadius.all(Radius.circular(10)), // Rounded corners
                        ),
                        labelText: 'Tax Rate (%)'

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
                      Text('After Tax: ₹ ${total.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold  )),
                    ],
                  ),
                ),



                ListTile(
                  title: TextField(
                    textAlign: TextAlign.center,
                    autofocus: true,
                    autocorrect: true,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isDense: true,
                      fillColor: secondaryColor, // Set input background color
                      filled: true, // Enables background color
                      contentPadding: EdgeInsets.symmetric(vertical: 20), // Adjust padding for better text centering
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none, // No border line
                        borderRadius: const BorderRadius.all(Radius.circular(10)), // Rounded corners
                      ),
                        labelText: 'Paid Amount'

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
                      Text('Amount Due:',style: TextStyle( fontWeight: FontWeight.bold  )),
                      Text((total - amountPaid).toStringAsFixed(2),
                          style: TextStyle(color: Colors.redAccent, fontSize: 20, fontWeight: FontWeight.bold  )),
                    ],
                  ),
                ),
SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      ],
    );
  }

}
