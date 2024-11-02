import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medixpos/constants.dart';

import 'package:medixpos/firebase_options.dart';
import 'package:medixpos/views/components/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'providers/medicine_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        home: SideMenu(),


      ),
    );
  }
}
