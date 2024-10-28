import 'package:flutter/material.dart';
import 'package:medixpos/constants.dart';
import 'package:medixpos/controllers/menu_app_controller.dart';
import 'package:medixpos/responsive.dart';
import 'package:medixpos/views/components/header.dart';
import 'package:medixpos/views/components/medicine/medicine_screen.dart';
import 'package:medixpos/views/components/side_menu.dart';
import 'package:medixpos/views/dialog/add_medicine_dialog.dart';
import 'package:provider/provider.dart';
import 'package:medixpos/providers/medicine_provider.dart'; // Import your MedicineProvider

class MedicinePage extends StatefulWidget {
  const MedicinePage({super.key});

  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  @override
  void initState() {
    super.initState();
    // Initialize the database when the widget is created
    Future(() async {
      await context.read<MedicineProvider>().initializeDatabase();
      // Optionally, you can setState to rebuild the UI if needed
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().medicineKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SafeArea(
                child: SingleChildScrollView(
                  primary: false,
                  padding: EdgeInsets.all(defaultPadding),
                  child: Column(
                    children: [
                       Header(),
                      SizedBox(height: defaultPadding),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: defaultPadding * 1.5,
                                          vertical: defaultPadding /
                                              (Responsive.isMobile(context) ? 2 : 1),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AddMedicineDialog(),
                                        );
                                      },
                                      icon: Icon(Icons.add),
                                      label: Text("Add Medicine"),
                                    ),
                                  ],
                                ),
                                SizedBox(height: defaultPadding),
                                MedicineScreen(), // Displays the list of medicines
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
