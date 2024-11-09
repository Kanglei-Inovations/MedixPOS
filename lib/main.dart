import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medixpos/constants.dart';
import 'package:medixpos/firebase_options.dart';
import 'package:medixpos/views/components/side_menu.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:medixpos/providers/medicine_provider.dart';  // Import your provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for the app
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MedicineProvider()),  // Add providers here
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pharmacy App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: SideMenu(),
    );
  }
}
