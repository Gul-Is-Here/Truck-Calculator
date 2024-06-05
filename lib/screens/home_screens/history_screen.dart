import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:intl/intl.dart';
import 'edit_screen.dart'; // Import the EditScreen

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
        child: Obx(() {
          if (homeController.historyData.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: homeController.historyData.length,
            itemBuilder: (context, index) {
              final data = homeController.historyData[index];
              

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
                            '\$${(data['totalFreightCharges'] as double? ?? 0.0).toStringAsFixed(2)}',
                      ),
                      _buildResultRow(
                        title: 'Total Estimated Tolls:',
                        value:
                            '\$${(data['totalEstimatedTolls'] as double? ?? 0.0).toStringAsFixed(2)}',
                      ),
                      _buildResultRow(
                        title: 'Total Other Costs:',
                        value:
                            '\$${(data['totalOtherCosts'] as double? ?? 0.0).toStringAsFixed(2)}',
                      ),
                      _buildResultRow(
                        title: 'Total Dispatched Miles:',
                        value:
                            '${(data['totalDispatchedMiles'] as double? ?? 0.0).toStringAsFixed(2)} miles',
                      ),
                      _buildResultRow(
                        title: 'Total Weekly Fixed Cost:',
                        value:
                            '\$${(data['weeklyFixedCost'] as double? ?? 0.0).toStringAsFixed(2)}',
                      ),
                      _buildResultRow(
                        title: 'Total Cost Per Week:',
                        value:
                            '\$${(data['totalMilageCost'] as double? ?? 0.0).toStringAsFixed(2)}',
                      ),
                      _buildResultRow(
                        title: 'Total Profit:',
                        value:
                            '\$${(data['totalProfit'] as double? ?? 0.0).toStringAsFixed(2)}',
                      ),
                      _buildResultRow(
                        title: 'Timestamp:',
                        value: data['timestamp'] != null
                            ? DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                (data['timestamp'] as Timestamp).toDate())
                            : 'N/A',
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          var datas = data['id'];
                          print(datas);
                          Get.to(() => EditScreen(
                                documentId: datas,
                                homeController: homeController,
                              ));
                        },
                        child: Text('Edit'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
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
