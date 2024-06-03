import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class ResultsScreen extends StatelessWidget {
  final HomeController homeController;

  ResultsScreen({required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation Results'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultRow(
              title: 'Total Freight Charges:',
              value:
                  '\$${homeController.totalFreightCharges.value.toStringAsFixed(2)}',
            ),
            _buildResultRow(
              title: 'Total Estimated Tolls:',
              value:
                  '\$${homeController.totalEstimatedTollsCost.value.toStringAsFixed(2)}',
            ),
            _buildResultRow(
              title: 'Total Other Costs:',
              value:
                  '\$${homeController.totalOtherCost.value.toStringAsFixed(2)}',
            ),
            _buildResultRow(
              title: 'Total Mileage Cost Per Week:',
              value:
                  '\$${homeController.totalMilageCostPerWeek.value.toStringAsFixed(2)}',
            ),
            _buildResultRow(
              title: 'Total Weekly Fixed Cost:',
              value:
                  '\$${homeController.weeklyFixedCost.value.toStringAsFixed(2)}',
            ),
            _buildResultRow(
              title: 'Total Cost Per Week:',
              value:
                  '\$${homeController.totalMilageCost.value.toStringAsFixed(2)}',
            ),
            10.heightBox,
            Center(
              child: Container(
                alignment: Alignment.center,
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(() => Text(
                      textAlign: TextAlign.center,
                      "Profit     \$${homeController.totalProfit.value.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ],
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
