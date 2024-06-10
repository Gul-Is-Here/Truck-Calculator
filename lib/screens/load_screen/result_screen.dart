import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:dispatched_calculator_app/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../widgets/result_widget.dart';

class ResultsScreen extends StatelessWidget {
  final HomeController homeController;

  ResultsScreen({required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ResultWidget(
                title: 'Total Freight Charges and Tolls',
                value:
                    '\$${homeController.totalFrightChargesAndTolls.value.toStringAsFixed(2)}',
              ),
              ResultWidget(
                title: 'Total Profit',
                value:
                    '\$${homeController.totalProfit.value.toStringAsFixed(2)}',
              ),
              ResultWidget(
                title: 'Total Miles',
                value:
                    '\$${homeController.totalMilageCost.value.toStringAsFixed(2)}',
              ),
              10.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
