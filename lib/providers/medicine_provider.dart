import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/medicine.dart';
import 'package:path/path.dart';

class MedicineProvider extends ChangeNotifier {
  List<Medicine> _medicines = [];

  List<Medicine> get medicines => _medicines;
  Database? _database;
  // Initialize SQLite database
  Future<void> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, 'medicines.db');

    // Create the database
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE medicines(id TEXT PRIMARY KEY, name TEXT, price REAL, salePrice REAL, stock INTEGER, brand TEXT, unitType TEXT)',
        );
      },
    );

    // Load initial data if needed
    _medicines = await fetchMedicines(database);
    notifyListeners();
  }

  // Fetch medicines from SQLite
  Future<List<Medicine>> fetchMedicines(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('medicines');
    return List.generate(maps.length, (i) {
      return Medicine.fromMap(maps[i]);
    });
  }

  // Add medicine to SQLite
  Future<void> addMedicine(Medicine medicine) async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, 'medicines.db');

    final db = await openDatabase(path);
    await db.insert('medicines', medicine.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

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
  // Edit Medicine
  Future<void> updateMedicine(String id, String name, double price, double salePrice, int stock,String unit, String brand) async {
    final db = await _getDatabase(); // Ens, String texture you have a method to get the database connection

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
    // Set up your database path and create the table if not exists
    // Example:
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'medicines.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE medicines(id TEXT PRIMARY KEY, name TEXT, price REAL, salePrice REAL, stock INTEGER, brand TEXT)',
        );
      },
    );
  }
}