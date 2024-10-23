import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          _buildDrawerItem(Icons.home, 'Dashboard', '/Dashboard'),
          _buildDrawerItem(Icons.shopping_cart, 'Sale', '/Sale'),
          _buildDrawerItem(Icons.shopping_bag, 'Purchase', '/Purchase'),
          _buildDrawerItem(Icons.medical_services, 'Medicine', '/Medicine'),
          _buildDrawerItem(Icons.report, 'Report', '/Report'),
          _buildDrawerItem(Icons.sync, 'Sync', '/Sync'),
          _buildDrawerItem(Icons.settings, 'Settings', '/Settings'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, String routeName) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Get.toNamed(routeName);
      },
    );
  }
}
