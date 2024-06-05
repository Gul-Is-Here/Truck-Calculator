import 'package:dispatched_calculator_app/screens/home_screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/customized_row_label_widget.dart';

class MileageFeSection extends StatelessWidget {
  final HomeController homeController;

  MileageFeSection({required this.homeController});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Mileage Fee Section',
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
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
                          "Weekly Fixed Cost \$${homeController.weeklyFixedCost.value.toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                ),
                const SizedBox(height: 40),
                buildRowWithLabel(
                  label: 'Mileage Fee (\$/mile)',
                  hint: 'e.g., \$0.50',
                  controller: homeController.perMileageFeeController,
                  value: homeController.permileageFee,
                  validator: homeController.validateInput,
                ),
                buildRowWithLabel(
                  label: 'Fuel (\$/mile)',
                  hint: 'e.g., \$0.20',
                  controller: homeController.perMileFuelController,
                  value: homeController.perMileFuel,
                  validator: homeController.validateInput,
                ),
                buildRowWithLabel(
                  label: 'DEF (\$/mile)',
                  hint: 'e.g., \$0.05',
                  controller: homeController.perMileDefController,
                  value: homeController.perMileDef,
                  validator: homeController.validateInput,
                ),
                buildRowWithLabel(
                  label: 'Driver Pay (\$/mile)',
                  hint: 'e.g., \$0.30',
                  controller: homeController.perMileDriverPayController,
                  value: homeController.perMileDriverPay,
                  validator: homeController.validateInput,
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
                          "Cost After Adding Factoring Fee \$${homeController.totalMilageCost.value.toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                ),
                20.heightBox,
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Submission'),
                              content: const Text(
                                  'Are you sure you want to submit the data?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () {
                                    homeController.calculateVariableCosts();
                                    homeController.storeCalculatedValues();
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    // Navigate to the next screen
                                    Get.to(() => ResultsScreen(
                                        homeController: homeController));
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.arrow_circle_right_outlined),
                      label: const Text('Next'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
