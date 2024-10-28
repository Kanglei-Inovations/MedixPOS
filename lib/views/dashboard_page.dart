

import 'package:flutter/material.dart';
import 'package:medixpos/controllers/menu_app_controller.dart';
import 'package:medixpos/responsive.dart';
import 'package:medixpos/views/components/dashboard/dashboard.dart';
import 'package:medixpos/views/components/side_menu.dart';




import 'package:provider/provider.dart';


class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().dashboardKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }
}