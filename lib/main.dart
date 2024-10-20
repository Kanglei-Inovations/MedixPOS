import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'providers/medicine_provider.dart';
import 'views/home_page.dart';
import 'views/medicine_page.dart';
import 'views/purchase_page.dart';
import 'views/report_page.dart';
import 'views/sale_page.dart';
import 'views/setting_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

// Initialize the provider
  final medicineProvider = MedicineProvider();
  await medicineProvider.initializeDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        // Add other providers here
      ],
      child: GetMaterialApp(
        title: 'Pharmacy App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/home', // Define the initial route
        getPages: [
          GetPage(name: '/home', page: () => HomePage()),
          GetPage(name: '/medicine', page: () => MedicinePage()), // Define routes
          GetPage(name: '/sale', page: () => SalePage()),
          GetPage(name: '/purchase', page: () => PurchasePage()),
          GetPage(name: '/report', page: () => ReportPage()),
          GetPage(name: '/settings', page: () => SettingPage()),
        ],
      ),
    );
  }
}
