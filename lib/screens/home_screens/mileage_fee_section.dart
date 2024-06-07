import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispatched_calculator_app/screens/home_screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/customized_row_label_widget.dart';

class MileageFeSection extends StatelessWidget {
  final HomeController homeController;
  final bool isUpdate;

  MileageFeSection({required this.homeController, required this.isUpdate});

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
                    width: 400,
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
                    width: 400,
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
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: isUpdate == false
                        ? ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                homeController.calculateVariableCosts();
                                homeController.updateEntry({
                                  'weeklyFixedCost':
                                      homeController.weeklyFixedCost.value,
                                  'totalFreightCharges':
                                      homeController.totalFreightCharges.value,
                                  'totalDispatchedMiles':
                                      homeController.totalDispatchedMiles.value,
                                  'totalMilageCost':
                                      homeController.totalMilageCost.value,
                                  'totalProfit':
                                      homeController.totalProfit.value,
                                  'timestamp': FieldValue.serverTimestamp(),
                                  'loads': List.generate(
                                    homeController
                                        .freightChargeControllers.length,
                                    (index) {
                                      return {
                                        'freightCharge': double.tryParse(
                                                homeController
                                                    .freightChargeControllers[
                                                        index]
                                                    .text) ??
                                            0.0,
                                        'dispatchedMiles': double.tryParse(
                                                homeController
                                                    .dispatchedMilesControllers[
                                                        index]
                                                    .text) ??
                                            0.0,
                                        'estimatedTolls': double.tryParse(
                                                homeController
                                                    .estimatedTollsControllers[
                                                        index]
                                                    .text) ??
                                            0.0,
                                        'otherCosts': double.tryParse(
                                                homeController
                                                    .otherCostsControllers[
                                                        index]
                                                    .text) ??
                                            0.0,
                                      };
                                    },
                                  ),
                                });
                                Navigator.of(context).pop(); // Close the dialog
                                Get.to(() => ResultsScreen(
                                    homeController: homeController));
                              }
                            },
                            icon: const Icon(
                              Icons.update,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Update',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                homeController.calculateVariableCosts();
                                homeController.storeCalculatedValues();
                                Get.snackbar(
                                    'Success', 'Data submitted successfully',
                                    backgroundColor: Colors.deepPurpleAccent,
                                    colorText: Colors.white);
                                Navigator.of(context).pop(); // Close the dialog
                                Get.to(() => ResultsScreen(
                                    homeController: homeController));
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_circle_right_outlined,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
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
