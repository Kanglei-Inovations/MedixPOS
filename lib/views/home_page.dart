import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MedixPOS'),
      ),
      drawer: _buildDrawer(context), // Drawer for mobile
      body: Row(
        children: [
          if (!isMobile(context)) _buildSideNavigation(), // SideNav for desktop
          Expanded(
            child: _buildPageContent(),
          ),
        ],
      ),
    );
  }

  // Method to determine if the device is mobile
  bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  // Drawer for mobile navigation
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Navigation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home', '/home'),
          _buildDrawerItem(Icons.medical_services, 'Medicine', '/medicine'),
          _buildDrawerItem(Icons.shopping_cart, 'Sale', '/sale'),
          _buildDrawerItem(Icons.shopping_bag, 'Purchase', '/purchase'),
          _buildDrawerItem(Icons.report, 'Report', '/report'),
          _buildDrawerItem(Icons.sync, 'Sync', '/sync'),
          _buildDrawerItem(Icons.settings, 'Settings', '/settings'),
        ],
      ),
    );
  }

  // Drawer item helper method
  Widget _buildDrawerItem(IconData icon, String title, String routeName) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Get.toNamed(routeName);
      },
    );
  }


  // Sidebar navigation for larger screens
  Widget _buildSideNavigation() {
    return Container(
      width: 250,
      child: Drawer(
        elevation: 0,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            _buildDrawerItem(Icons.home, 'Home', '/home'),
            _buildDrawerItem(Icons.medical_services, 'Medicine', '/medicine'),
            _buildDrawerItem(Icons.shopping_cart, 'Sale', '/sale'),
            _buildDrawerItem(Icons.shopping_bag, 'Purchase', '/purchase'),
            _buildDrawerItem(Icons.report, 'Report', '/report'),
            _buildDrawerItem(Icons.sync, 'Sync', '/sync'),
            _buildDrawerItem(Icons.settings, 'Settings', '/settings'),
          ],
        ),
      ),
    );
  }

  // Page content builder
  Widget _buildPageContent() {
    return Center(
      child: Text(
        'Welcome to the Pharmacy Dashboard!',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
