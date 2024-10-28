import 'package:flutter/material.dart';
import 'package:medixpos/constants.dart';
import 'package:medixpos/controllers/menu_app_controller.dart';
import 'package:medixpos/responsive.dart';
import 'package:medixpos/views/components/dashboard/recent_files.dart';
import 'package:medixpos/views/components/header.dart';
import 'package:medixpos/views/components/side_menu.dart';
import 'package:provider/provider.dart';

class SalePage extends StatelessWidget {
  const SalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().saleKey,
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
                child: SafeArea(
                  child: SingleChildScrollView(
                    primary: false,
                    padding: EdgeInsets.all(defaultPadding),
                    child: Column(
                      children: [
                        // if (!Responsive.isMobile(context))
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
                                    crossAxisAlignment: CrossAxisAlignment.end, // Align at the bottom of the row
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      ElevatedButton.icon(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: defaultPadding * 1.5,
                                            vertical:
                                            defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                                          ),
                                        ),
                                        onPressed: () {},
                                        icon: Icon(Icons.add),
                                        label: Text("New Sales"),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: defaultPadding),
                                  RecentFiles(),

                                ],
                              ),
                            ),

                          ],
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
