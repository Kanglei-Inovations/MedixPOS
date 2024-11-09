import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medixpos/models/settings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:medixpos/constants.dart';

class CompanySettingProvider extends ChangeNotifier {
  List<CompanySettings> _companySettings = [];
  List<CompanySettings> get companySettings => _companySettings;

  Database? _database;

  // Initialize SQLite database
  Future<void> initializeDatabase() async {
    await _getDatabase();
    await fetchCompanySettings();
    await checkFirestoreAndLoadData();
  }

  // Get or create SQLite database
  Future<Database> _getDatabase() async {
    if (_database != null) return _database!;
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "medixposnew");
    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS company_settings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            companyName TEXT,
            businessType TEXT,
            ownerName TEXT,
            address TEXT,
            phoneNumber TEXT,
            logoPath TEXT,
            gstNumber TEXT,
            registrationNumber TEXT,
            bankAccountNumber TEXT,
            ifscCode TEXT,
            accountName TEXT,
            upiAddress TEXT
          )
        ''');
      },
    );
    return _database!;
  }

  /// Save a new company setting
  Future<void> saveCompanySetting(CompanySettings setting) async {
    final db = await _getDatabase();
    await db.insert('company_settings', setting.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    _companySettings.add(setting);
    notifyListeners();
  }

  Future<void> updateCompanySetting(CompanySettings setting) async {
    final db = await _getDatabase();

    // Check if the ID is null
    if (setting.id == null) {
      print("Cannot update. The setting ID is null.");
      return; // Handle as needed
    }

    // Prepare the data for update
    final dataToUpdate = setting.toMap();

    // Remove any null values from dataToUpdate
    dataToUpdate.removeWhere((key, value) => value == null);

    await db.update(
      'company_settings',
      dataToUpdate,
      where: 'id = ?',
      whereArgs: [setting.id],
    );

    // Update in the local list
    int index = _companySettings.indexWhere((s) => s.id == setting.id);
    if (index != -1) {
      _companySettings[index] = setting;
    }
    notifyListeners();
  }


  /// Delete a company setting
  Future<void> deleteCompanySetting(int id) async {
    final db = await _getDatabase();
    await db.delete('company_settings', where: 'id = ?', whereArgs: [id]);
    _companySettings.removeWhere((setting) => setting.id == id);
    notifyListeners();
  }

  /// Fetch all company settings from SQLite
  Future<void> fetchCompanySettings() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('company_settings');
    _companySettings = List.generate(maps.length, (i) => CompanySettings.fromMap(maps[i]));
    notifyListeners();
  }

  /// Load data from Firestore if SQLite database is empty
  Future<void> checkFirestoreAndLoadData() async {
    final firestoreSettings = await FirebaseFirestore.instance.collection('company_settings').get();
    if (firestoreSettings.docs.isEmpty) {
      print("Warning: Firestore is empty. Please check your database setup.");
      return;
    }

    for (var doc in firestoreSettings.docs) {
      await saveCompanySetting(CompanySettings.fromMap(doc.data()));
    }
  }

  /// Sync a single company setting to Firestore
  Future<void> syncToOnline(CompanySettings setting) async {
    try {
      await FirebaseFirestore.instance.collection('company_settings').doc(setting.id.toString()).set(setting.toMap());
    } catch (e) {
      print("Error syncing data: $e");
    }
  }
}
