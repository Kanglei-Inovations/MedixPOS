import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medixpos/models/invoice.dart';
import 'package:medixpos/models/medicine.dart';

class MedicineProvider extends ChangeNotifier {
  List<Medicine> _medicines = [];
  List<Medicine> get medicines => _medicines;

  List<Invoice> _invoices = [];
  List<Invoice> get invoices => _invoices;

  List<Medicine> _missingMedicinesInFirestore = [];
  List<Medicine> get missingMedicines => _missingMedicinesInFirestore;

  List<Map<String, dynamic>> unsyncedData = [];

  /// Fetch medicines from Firestore
  Future<void> fetchMedicines() async {
    try {
      final firestoreMedicines = await FirebaseFirestore.instance.collection('medicines').get();
      _medicines = firestoreMedicines.docs.map((doc) => Medicine.fromMap(doc.data())).toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }

  }

  /// Add a new medicine to Firestore
  Future<void> addMedicine(Medicine medicine) async {
    try {
      await FirebaseFirestore.instance.collection('medicines').doc(medicine.id).set(medicine.toMap());
      _medicines.add(medicine);
      notifyListeners();
      print("Added");
    } catch (e) {
      print("Error adding medicine to Firestore: $e");
    }
  }

  /// Delete a medicine from Firestore
  Future<void> deleteMedicine(String id) async {
    try {
      await FirebaseFirestore.instance.collection('medicines').doc(id).delete();
      _medicines.removeWhere((medicine) => medicine.id == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting medicine from Firestore: $e");
    }
  }

  /// Update an existing medicine in Firestore
  Future<void> updateMedicine(
      String id,
      String name,
      double price,
      double salePrice,
      int stock,
      String unit,
      String brand,
      String barcode,
      DateTime mfgDate,
      DateTime expiryDate,
      ) async {
    try {
      final updatedData = {
        'name': name,
        'price': price,
        'salePrice': salePrice,
        'stock': stock,
        'brand': brand,
        'unitType': unit,
        'barcode': barcode,
        'mfgDate': mfgDate.toIso8601String(),
        'expiryDate': expiryDate.toIso8601String(),
      };
      await FirebaseFirestore.instance.collection('medicines').doc(id).update(updatedData);
      await fetchMedicines(); // Reload data from Firestore
    } catch (e) {
      print("Error updating medicine in Firestore: $e");
    }
  }

  /// Save a new invoice with associated medicine items to Firestore
  Future<void> saveInvoice(
      List<Medicine> invoiceItems,
      double subtotal,
      double discount,
      double taxRate,
      double amountPaid,
      String paymentType,
      ) async {
    final invoiceId = DateTime.now().millisecondsSinceEpoch.toString();

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
      await FirebaseFirestore.instance.collection('invoices').doc(invoiceId).set(invoiceData);

      for (var item in invoiceItems) {
        await FirebaseFirestore.instance
            .collection('invoices')
            .doc(invoiceId)
            .collection('invoice_items')
            .doc(item.id)
            .set(item.toMapForInvoice(invoiceId));
      }
      print('Invoice added to Firestore');
      notifyListeners();
    } catch (e) {
      print('Error saving invoice to Firestore: $e');
    }
  }

  /// Delete an invoice and its items from Firestore
  Future<void> deleteInvoice(String id) async {
    try {
      // Delete all invoice items associated with this invoice
      final invoiceItems = await FirebaseFirestore.instance
          .collection('invoices')
          .doc(id)
          .collection('invoice_items')
          .get();

      for (var item in invoiceItems.docs) {
        await item.reference.delete();
      }

      // Now delete the invoice itself
      await FirebaseFirestore.instance.collection('invoices').doc(id).delete();
      _invoices.removeWhere((invoice) => invoice.id == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting invoice from Firestore: $e");
    }
  }

  /// Fetch all invoices from Firestore
  Future<void> fetchInvoices() async {
    final firestoreInvoices = await FirebaseFirestore.instance.collection('invoices').get();
    _invoices = firestoreInvoices.docs.map((doc) => Invoice.fromMap(doc.data())).toList();
    notifyListeners();
  }
}
