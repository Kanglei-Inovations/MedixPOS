import 'package:flutter/material.dart';
import 'package:medixpos/constants.dart';

import 'package:medixpos/providers/medicine_provider.dart';
import 'package:medixpos/responsive.dart';
import 'package:medixpos/views/components/header.dart';
import 'package:medixpos/views/components/side_menu.dart';
import 'package:medixpos/views/components/sync_to_server.dart';
import 'package:provider/provider.dart';

class SyncPage extends StatelessWidget {
  const SyncPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: SingleChildScrollView(
            primary: false,
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sync Data",
                  style: Theme.of(context).textTheme.titleMedium,
                ),

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
                              // ElevatedButton.icon(
                              //   style: TextButton.styleFrom(
                              //     padding: EdgeInsets.symmetric(
                              //       horizontal: defaultPadding * 1.5,
                              //       vertical: defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                              //     ),
                              //   ),
                              //   onPressed: () async {
                              //     // await medicineProvider.scanForOfflineData();
                              //   },
                              //   icon: Icon(Icons.add),
                              //   label: Text("Scan for Unsynced Data"),
                              // ),
                            ],
                          ),
                          SizedBox(height: defaultPadding),
                          SyncScreen(),  // Use SyncScreen here instead of SyncPage
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
