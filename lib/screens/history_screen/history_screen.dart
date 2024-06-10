import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispatched_calculator_app/screens/load_screen/load_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:intl/intl.dart';


class HistoryScreen extends StatelessWidget {
  final HomeController homeController;

  HistoryScreen({required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation History'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: homeController.fetchAllEntriesForEditing(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var data = snapshot.data!;
            if (data.isEmpty) {
              return Center(child: Text('No history data available.'));
            }

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final load = data[index];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildResultRow(
                          title: 'Total Freight Charges:',
                          value:
                              '\$${(load['totalFreightCharges'] as double? ?? 0.0).toStringAsFixed(2)}',
                        ),
                        _buildResultRow(
                          title: 'Total Estimated Tolls:',
                          value:
                              '\$${(load['totalEstimatedTolls'] as double? ?? 0.0).toStringAsFixed(2)}',
                        ),
                        _buildResultRow(
                          title: 'Total Other Costs:',
                          value:
                              '\$${(load['totalOtherCosts'] as double? ?? 0.0).toStringAsFixed(2)}',
                        ),
                        _buildResultRow(
                          title: 'Total Dispatched Miles:',
                          value:
                              '${(load['totalDispatchedMiles'] as double? ?? 0.0).toStringAsFixed(2)} miles',
                        ),
                        _buildResultRow(
                          title: 'Total Weekly Fixed Cost:',
                          value:
                              '\$${(load['weeklyFixedCost'] as double? ?? 0.0).toStringAsFixed(2)}',
                        ),
                        _buildResultRow(
                          title: 'Total Cost Per Week:',
                          value:
                              '\$${(load['totalMilageCost'] as double? ?? 0.0).toStringAsFixed(2)}',
                        ),
                        _buildResultRow(
                          title: 'Total Profit:',
                          value:
                              '\$${(load['totalProfit'] as double? ?? 0.0).toStringAsFixed(2)}',
                        ),
                        _buildResultRow(
                          title: 'Timestamp:',
                          value: load['timestamp'] != null
                              ? DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                  (load['timestamp'] as Timestamp).toDate())
                              : 'N/A',
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            var documentId = load['id'] as String?;

                            if (documentId != null) {
                              var loadData = await homeController
                                  .fetchEntryForEditing(documentId);
                              print(loadData);
                              Get.to(() => LoadScreen(
                                isUpdate: false,
                                    documentId: documentId,
                                    homeController: homeController,
                                    loadData: loadData,
                                  ));
                            }
                          },
                          child: Text('Edit'),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultRow({required String title, required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
