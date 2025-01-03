import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medixpos/constants.dart';
import 'package:medixpos/views/dashboard.dart';
import 'package:medixpos/views/invoice_list.dart';
import 'package:medixpos/views/medicine_screen.dart';
import 'package:medixpos/views/purchase_page.dart';
import 'package:medixpos/views/report_page.dart';
import 'package:medixpos/views/setting_page.dart';
import 'package:medixpos/views/sync_page.dart';

// Basic responsive utility to detect desktop screens
class Responsive {
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;
}

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int _currentIndex = 0;

  // List of pages corresponding to each menu item
  final List<Widget> _pages = [
    DashboardScreen(),
    InvoiceList(),
    PurchasePage(),
    MedicineScreen(),
    ReportPage(),
    SyncPage(),
    SettingsPage(),
  ];

  void _onSelectPage(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (!Responsive.isDesktop(context)) {
      Navigator.pop(context); // Close the drawer on mobile
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Row(
        children: [
          // Show Drawer as a permanent sidebar on desktop
          if (Responsive.isDesktop(context))
            Container(
              width: 250, // Fixed width for the side menu
              child: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(color: primaryColor),
                      child: Column(
                        children: [
                          Text(
                            'MedixPOS',
                            style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Billing and Management System',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          Text(
                            'By- KANGLEI INOVATIONS',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Dashboard'),
                      onTap: () => _onSelectPage(0),
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Text('Sale'),
                      onTap: () => _onSelectPage(1),
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_bag),
                      title: Text('Purchase'),
                      onTap: () => _onSelectPage(2),
                    ),
                    ListTile(
                      leading: Icon(Icons.medical_services),
                      title: Text('Medicine'),
                      onTap: () => _onSelectPage(3),
                    ),
                    ListTile(
                      leading: Icon(Icons.report),
                      title: Text('Report'),
                      onTap: () => _onSelectPage(4),
                    ),
                    ListTile(
                      leading: Icon(Icons.sync),
                      title: Text('Sync'),
                      onTap: () => _onSelectPage(5),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () => _onSelectPage(6),
                    ),
                  ],
                ),
              ),
            ),
          // Main content area
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0), // Customize as needed
                topRight: Radius.circular(20.0),
              ),
              child: _pages[_currentIndex],
            ),
          ),
        ],
      ),
      // Show drawer as a collapsible menu only on mobile
      drawer: Responsive.isDesktop(context) ? null : Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.redAccent),
              child: Text('Navigation', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Dashboard'),
              onTap: () => _onSelectPage(0),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Sale'),
              onTap: () => _onSelectPage(1),
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('Purchase'),
              onTap: () => _onSelectPage(2),
            ),
            ListTile(
              leading: Icon(Icons.medical_services),
              title: Text('Medicine'),
              onTap: () => _onSelectPage(3),
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Report'),
              onTap: () => _onSelectPage(4),
            ),
            ListTile(
              leading: Icon(Icons.sync),
              title: Text('Sync'),
              onTap: () => _onSelectPage(5),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => _onSelectPage(6),
            ),
          ],
        ),
      ),
    );
  }
}
