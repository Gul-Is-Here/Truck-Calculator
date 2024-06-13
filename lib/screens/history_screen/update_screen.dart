import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:dispatched_calculator_app/screens/load_screen/load_screen.dart';
import 'package:dispatched_calculator_app/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:intl/intl.dart';

import '../../services/firebase_services.dart';

class UpdateScreen extends StatelessWidget {
  final HomeController homeController;
  final bool isUpdate;
  const UpdateScreen({required this.homeController, required this.isUpdate});

  @override
  Widget build(BuildContext context) {
    print('update screen : $isUpdate');
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: homeController.fetchAllEntriesForEditing(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            var data = snapshot.data ?? [];
            if (data.isEmpty) {
              return Center(child: Text('No history data available.'));
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'id',
                      style: TextStyle(
                          fontFamily: robotoRegular,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Date',
                      style: TextStyle(
                          fontFamily: robotoRegular,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Time',
                      style: TextStyle(
                          fontFamily: robotoRegular,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Action',
                      style: TextStyle(
                          fontFamily: robotoRegular,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: data.map<DataRow>((load) {
                  var timestamp = (load['timestamp'] as Timestamp?)?.toDate();
                  var date = timestamp != null
                      ? DateFormat('yyyy-MM-dd').format(timestamp)
                      : 'N/A';
                  var time = timestamp != null
                      ? DateFormat('HH:mm:ss').format(timestamp)
                      : 'N/A';
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(FirebaseServices().docId,
                          style: TextStyle(
                              fontFamily: robotoRegular,
                              fontSize: 14))), // Assuming all are 'Week 1'
                      DataCell(Text(
                        date,
                        style:
                            TextStyle(fontFamily: robotoRegular, fontSize: 14),
                      )),
                      DataCell(Text(time,
                          style: TextStyle(
                              fontFamily: robotoRegular, fontSize: 14))),
                      DataCell(
                        Row(
                          children: [
                            TextButton(
                              onPressed: () async {
                                var documentId = load['id'] as String?;
                                if (documentId != null) {
                                  var loadData = await homeController
                                      .fetchEntryForEditing(documentId);
                                  Get.to(() => LoadScreen(
                                        isUpdate: isUpdate,
                                        documentId: documentId,
                                        homeController: homeController,
                                        loadData: loadData,
                                      ));
                                }
                              },
                              child: Text('Edit'),
                            ),
                            ElevatedButton(
                                onPressed:
                                    homeController.transferAndDeleteWeeklyData,
                                child: Text('Delete'))
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
