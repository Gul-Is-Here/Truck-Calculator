import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/custome_textFormField.dart';

class LoadScreen extends StatelessWidget {
  final HomeController homeController;

  LoadScreen({required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Additional Costs'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Obx(
          () => ListView(
            children: [
              for (int i = 0;
                  i < homeController.freightChargeControllers.length;
                  i++) ...[
                Text('Load ${i + 1}',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                10.heightBox,
                buildTextFormField(
                  controller: homeController.freightChargeControllers[i],
                  label: 'Freight Charge (\$)',
                  hint: 'e.g., \$1000',
                  validator: homeController.validateInput,
                ),
                buildTextFormField(
                  controller: homeController.dispatchedMilesControllers[i],
                  label: 'Dispatched Miles',
                  hint: 'e.g., 2000',
                  validator: homeController.validateInput,
                ),
                buildTextFormField(
                  controller: homeController.estimatedTollsControllers[i],
                  label: 'Estimated Tolls (\$)',
                  hint: 'e.g., \$50',
                  validator: homeController.validateInput,
                ),
                buildTextFormField(
                  controller: homeController.otherCostsControllers[i],
                  label: 'Other Costs (\$)',
                  hint: 'e.g., \$100',
                  validator: homeController.validateInput,
                ),
                20.heightBox,
              ],
              ElevatedButton(
                onPressed: () async {
                  homeController.calculateVariableCosts();

                  final snackBar = SnackBar(
                    content: Text('Do you want to add another load?'),
                    action: SnackBarAction(
                      label: 'Add',
                      onPressed: () {
                        homeController.addNewLoad();
                      },
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text('Calculate Total Cost'),
              ),
              20.heightBox,
              Obx(() => Column(
                    children: [
                      Text(
                          'Total Cost Per Week: \$${homeController.totalMileageAndWeeklyFixedCost.value.toStringAsFixed(2)}'),
                      Text(
                          'Profit: \$${homeController.totalMileageAndWeeklyFixedCost.value.toStringAsFixed(2)}'),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
