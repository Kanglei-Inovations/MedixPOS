import 'package:flutter/material.dart';

class MenuAppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Unique GlobalKeys for each page
  late final GlobalKey<ScaffoldState> saleKey;
  late final GlobalKey<ScaffoldState> dashboardKey;
  late final GlobalKey<ScaffoldState> medicineKey;
  late final GlobalKey<ScaffoldState> purchaseKey;
  late final GlobalKey<ScaffoldState> syncKey;

  MenuAppController() {
    saleKey = GlobalKey<ScaffoldState>();
    dashboardKey = GlobalKey<ScaffoldState>();
    medicineKey = GlobalKey<ScaffoldState>();
    purchaseKey = GlobalKey<ScaffoldState>();
    syncKey = GlobalKey<ScaffoldState>();
  }

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu(GlobalKey<ScaffoldState> key) {
    if (!key.currentState!.isDrawerOpen) {
      key.currentState!.openDrawer();
    }
  }
}
