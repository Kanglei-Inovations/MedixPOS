import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medixpos/constants.dart';
import 'package:medixpos/controllers/menu_app_controller.dart';
import 'package:medixpos/views/medicine_page.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'providers/medicine_provider.dart';
import 'views/dashboard_page.dart';
import 'views/purchase_page.dart';
import 'views/report_page.dart';
import 'views/sale_page.dart';
import 'views/setting_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
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
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
        // Add other providers here
      ],
      child: GetMaterialApp(
        title: 'Pharmacy App',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),

        debugShowCheckedModeBanner: false,
        initialRoute: '/Dashboard', // Define the initial route
        getPages: [
          GetPage(
              name: '/Dashboard',
              page: () =>
                  MainScreen(),
            transition:  Transition.fadeIn
          ), // Use the persistent layout for dashboard
          GetPage(
              name: '/Sale',
              page: () => SalePage(),
            transition:  Transition.fadeIn,
          ), // Same layout but different index
          GetPage(name: '/Purchase', page: () => PurchasePage(),
            transition:  Transition.fadeIn,

          ),
          GetPage(name: '/Medicine', page: () => MedicinePage(), transition:  Transition.fadeIn,),
          GetPage(name: '/Report', page: () => ReportPage(), transition:  Transition.fadeIn,),
          GetPage(name: '/Settings', page: () => SettingPage(), transition:  Transition.fadeIn,),
        ],
      ),
    );
  }
}
