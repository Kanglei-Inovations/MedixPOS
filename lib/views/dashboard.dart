
import 'package:flutter/material.dart';
import 'package:medixpos/constants.dart';
import 'package:medixpos/responsive.dart';

import 'package:medixpos/views/components/dashboard/my_fields.dart';
import 'package:medixpos/views/components/dashboard/recent_files.dart';
import 'package:medixpos/views/components/dashboard/storage_details.dart';
import 'package:medixpos/views/components/header.dart';



class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    crossAxisAlignment: CrossAxisAlignment.start, // Align to the start
                    children: [
                      Container(
                        // Ensure consistent height if needed
                        constraints: BoxConstraints(
                          minHeight: 150, // Adjust this value based on your needs
                        ),
                        child: MyFiles(),
                      ),
                      SizedBox(height: defaultPadding),
                      RecentFiles(),
                      if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context))
                        Container(
                          constraints: BoxConstraints(
                            minHeight: 150, // Ensure this is the same as MyFiles
                          ),
                          child: StorageDetails(),
                        ),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 150, // Match the height with MyFiles
                      ),
                      child: StorageDetails(),
                    ),
                  ),
              ],
            ),
          ],
        ),

      ),
    );
  }
}