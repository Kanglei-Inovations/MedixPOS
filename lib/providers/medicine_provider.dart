import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medixpos/models/invoice.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:medixpos/models/medicine.dart'; // Ensure this path is correct and consistent

class MedicineProvider extends ChangeNotifier {
  List<Medicine> _medicines = [];
  List<Medicine> get medicines => _medicines;
  List<Medicine> _missingMedicinesInFirestore = [];
  List<Medicine> get missingMedicines => _missingMedicinesInFirestore;
  List<Map<String, dynamic>> unsyncedData = [];
  Database? _database;
  List<Invoice> _invoices = [];
  List<Invoice> get invoices => _invoices;
  // Initialize SQLite database
  Future<void> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, 'medicines.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create the invoices table
        await db.execute(
          'CREATE TABLE IF NOT EXISTS invoices(id TEXT PRIMARY KEY, subtotal REAL, discount REAL, taxRate REAL, amountPaid REAL, paymentType TEXT, createdAt TEXT)',
        );
        // Create the invoice_items table
        await db.execute(
          'CREATE TABLE IF NOT EXISTS invoice_items(id TEXT PRIMARY KEY, name TEXT, price REAL, salePrice REAL, stock INTEGER, brand TEXT, unitType TEXT, invoiceId TEXT, FOREIGN KEY(invoiceId) REFERENCES invoices(id))',
        );
        // Create the medicines table
        await db.execute(
          'CREATE TABLE IF NOT EXISTS medicines(id TEXT PRIMARY KEY, name TEXT, price REAL, salePrice REAL, stock INTEGER, brand TEXT, unitType TEXT, isSynced INTEGER DEFAULT 0)',
        );
      },
    );
    await fetchInvoices();  // Load invoices on initialization
    await checkFirestoreAndLoadData();
    // Ensure that _medicines is populated
    _medicines = await fetchMedicines(_database!);
    notifyListeners();
  }




  Future<void> saveInvoice(
      List<Medicine> invoiceItems,
      double subtotal,
      double discount,
      double taxRate,
      double amountPaid,
      String paymentType) async {
    final db = await _getDatabase(); // Ensure a single db instance is used

    String invoiceId = DateTime.now().millisecondsSinceEpoch.toString();

    final invoiceData = {
      'id': invoiceId,
      'subtotal': subtotal,
      'discount': discount,
      'taxRate': taxRate,
      'amountPaid': amountPaid,
      'paymentType': paymentType,
      'createdAt': DateTime.now().toIso8601String(),
    };

    try {
      // Insert into invoices table
      await db.insert('invoices', invoiceData,
          conflictAlgorithm: ConflictAlgorithm.replace);

      // Insert each medicine item associated with the invoice
      for (var item in invoiceItems) {
        final itemData = item.toMapForInvoice(invoiceId);
        await db.insert('invoice_items', itemData,
            conflictAlgorithm: ConflictAlgorithm.replace);
        print("Inserted");
      }

      notifyListeners();
    } catch (e) {
      print('Error adding invoice: $e');
    }
  }
  Future<void> fetchInvoices() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('invoices');

    _invoices = List.generate(maps.length, (i) => Invoice.fromMap(maps[i]));
    notifyListeners();  // Notify UI listeners of the change
  }

  // Check Firestore and load data if SQLite is empty
  Future<void> checkFirestoreAndLoadData() async {
    final firestoreMedicines =
        await FirebaseFirestore.instance.collection('medicines').get();
    if (firestoreMedicines.docs.isEmpty) {
      print("Warning: Firestore is empty. Please check your database setup.");
      return; // No data to load from Firestore
    }

    // Load data from Firestore into SQLite
    for (var doc in firestoreMedicines.docs) {
      final medicineData = doc.data();
      await addMedicine(Medicine.fromMap(medicineData));
    }
  }

  // Fetch medicines from SQLite
  Future<List<Medicine>> fetchMedicines(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('medicines');
    return List.generate(maps.length, (i) => Medicine.fromMap(maps[i]));
  }

  // Add medicine to SQLite
  Future<void> addMedicine(Medicine medicine) async {
    final db = await _getDatabase(); // Ensure you're using the same DB instance
    await db.insert('medicines', medicine.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    _medicines.add(medicine);
    notifyListeners();
  }

  // Delete medicine from SQLite
  Future<void> deleteMedicine(String id) async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, 'medicines.db');

    final db = await openDatabase(path);
    await db.delete('medicines', where: 'id = ?', whereArgs: [id]);

    _medicines.removeWhere((medicine) => medicine.id == id);
    notifyListeners();
  }

  // Edit Medicine
  Future<void> updateMedicine(String id, String name, double price,
      double salePrice, int stock, String unit, String brand) async {
    final db =
        await _getDatabase(); // Ens, String texture you have a method to get the database connection

    await db.update(
      'medicines',
      {
        'name': name,
        'price': price,
        'salePrice': salePrice,
        'stock': stock,
        'brand': brand,
        'unitType': unit,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    // Fetch the updated list of medicines from the database
    _medicines = await fetchMedicines(db);

    // Notify listeners that the data has changed
    notifyListeners();
  }

  Future<Database> _getDatabase() async {
    if (_database != null) return _database!;

    final databasePath = await getDatabasesPath();
    String path = join(databasePath, 'medixpos.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS medicines(id TEXT PRIMARY KEY, name TEXT, price REAL, salePrice REAL, stock INTEGER, brand TEXT, unitType TEXT, isSynced INTEGER DEFAULT 0)',
        );

        await db.execute(
          'CREATE TABLE IF NOT EXISTS invoices(id TEXT PRIMARY KEY, subtotal REAL, discount REAL, taxRate REAL, amountPaid REAL, paymentType TEXT, createdAt TEXT)',
        );

        await db.execute(
          'CREATE TABLE IF NOT EXISTS invoice_items(id TEXT PRIMARY KEY, name TEXT, price REAL, salePrice REAL, stock INTEGER, brand TEXT, unitType TEXT, invoiceId TEXT, FOREIGN KEY(invoiceId) REFERENCES invoices(id))',
        );
      },
    );

    return _database!;
  }



  Future<void> scanForOfflineData() async {
    final db = await _getDatabase();

    try {
      // Fetch all data from SQLite (you can modify this to target specific tables if needed)
      final allMedicines = await db.query('medicines');

      // Check if any data exists
      if (allMedicines.isNotEmpty) {
        unsyncedData =
            allMedicines; // Store or manipulate the fetched data as needed
      } else {
        // No data found
        print('No offline data available.');
        unsyncedData = []; // Clear unsyncedData if no records are found
      }
    } catch (e) {
      // Catch any SQLite errors and print them
      print('Error scanning for offline data: $e');
    } finally {
      notifyListeners(); // Notify listeners to update UI if necessary
    }
  }

// Check if a medicine exists in Firestore by name
  Future<bool> onlinedatacheck(String medicineName) async {
    final firestoreMedicines =
        await FirebaseFirestore.instance.collection('medicines').get();
    final firestoreMedicineNames =
        firestoreMedicines.docs.map((doc) => doc.data()['name']).toSet();
    return firestoreMedicineNames.contains(medicineName);
  }

  // Sync single data item to Firestore
  Future<void> synctoonline(Map<String, dynamic> data) async {
    final db = await _getDatabase();
    try {
      await FirebaseFirestore.instance
          .collection('medicines')
          .doc(data['id'])
          .set(data);
      // Mark as synced in local SQLite
      await db.update(
        'medicines',
        {
          'isSynced': 1
        }, // Assuming you have an 'isSynced' field to track sync status
        where: 'id = ?',
        whereArgs: [data['id']],
      );
    } catch (e) {
      print("Error syncing data: $e");
    }
  }
}
