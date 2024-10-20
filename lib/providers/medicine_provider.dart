import 'package:flutter/material.dart';
import '../models/medicine.dart';

class MedicineProvider extends ChangeNotifier {
  List<Medicine> _medicines = [];

  List<Medicine> get medicines => _medicines;

  void addMedicine(Medicine medicine) {
    _medicines.add(medicine);
    notifyListeners();
  }

  void removeMedicine(Medicine medicine) {
    _medicines.remove(medicine);
    notifyListeners();
  }

// Additional methods for syncing with Firebase and SQLite will be added later.
}
