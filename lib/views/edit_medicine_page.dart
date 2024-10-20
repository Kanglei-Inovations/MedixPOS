import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';

class EditMedicinePage extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final double salePrice;
  final int stock;
  final String brand;

  // Initialize controllers in the constructor
  final TextEditingController nameController;
  final TextEditingController stockController;
  final TextEditingController priceController;
  final TextEditingController salePriceController;
  final TextEditingController brandController;

  EditMedicinePage({
    Key? key,
    required this.id,
    required this.name,
    required this.price,
    required this.salePrice,
    required this.stock,
    required this.brand,
  })  : nameController = TextEditingController(text: name),
        stockController = TextEditingController(text: stock.toString()),
        priceController = TextEditingController(text: price.toString()),
        salePriceController = TextEditingController(text: salePrice.toString()),
        brandController = TextEditingController(text: brand),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Medicine'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: stockController,
                decoration: InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Strike MRP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: salePriceController,
                decoration: InputDecoration(
                  labelText: 'Sale Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: brandController,
                decoration: InputDecoration(
                  labelText: 'Brand',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Call updateMedicine method from your provider
                  Provider.of<MedicineProvider>(context, listen: false).updateMedicine(
                    id,
                    nameController.text,
                    double.tryParse(priceController.text) ?? 0,
                    double.tryParse(salePriceController.text) ?? 0,
                    int.tryParse(stockController.text) ?? 0,
                    brandController.text,
                  );
                  // Navigate back to the medicine list
                  Navigator.pop(context);
                },
                child: Text('Update Medicine'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
