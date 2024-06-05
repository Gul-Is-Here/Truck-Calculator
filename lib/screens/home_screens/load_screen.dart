import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:dispatched_calculator_app/widgets/addLoad_dialogBox.dart';

import 'package:dispatched_calculator_app/widgets/delete_dialogBox.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../widgets/custome_textFormField.dart';
import 'mileage_fee_section.dart';

class LoadScreen extends StatefulWidget {
  final HomeController homeController;
  final Map<String, dynamic>? loadData;

  LoadScreen({required this.homeController, this.loadData});

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  final formKey = GlobalKey<FormState>(); // Move this line here

  @override
  Widget build(BuildContext context) {
    print(widget.loadData);

    return Scaffold(
      appBar: AppBar(
        title: Text('Additional Costs'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Obx(
          () => Form(
            key: formKey, // Assign the formKey here
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        widget.homeController.freightChargeControllers.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Load ${index + 1}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          10.heightBox,
                          buildTextFormField(
                            controller: widget
                                .homeController.freightChargeControllers[index],
                            label: 'Freight Charge (\$)',
                            hint: 'e.g., \$1000',
                            validator: widget.homeController.validateInput,
                            initialValue: widget.loadData != null
                                ? (widget.loadData!['loads'][index]
                                        ['freightCharge'] as double)
                                    .toString()
                                : null,
                          ),
                          buildTextFormField(
                            controller: widget.homeController
                                .dispatchedMilesControllers[index],
                            label: 'Dispatched Miles',
                            hint: 'e.g., 2000',
                            validator: widget.homeController.validateInput,
                            initialValue: widget.loadData != null
                                ? (widget.loadData!['loads'][index]
                                        ['dispatchedMiles'] as double)
                                    .toString()
                                : null,
                          ),
                          buildTextFormField(
                            controller: widget.homeController
                                .estimatedTollsControllers[index],
                            label: 'Estimated Tolls (\$)',
                            hint: 'e.g., \$50',
                            validator: widget.homeController.validateInput,
                            initialValue: widget.loadData != null
                                ? (widget.loadData!['loads'][index]
                                        ['estimatedTolls'] as double)
                                    .toString()
                                : null,
                          ),
                          buildTextFormField(
                            controller: widget
                                .homeController.otherCostsControllers[index],
                            label: 'Other Costs (\$)',
                            hint: 'e.g., \$100',
                            validator: widget.homeController.validateInput,
                            initialValue: widget.loadData != null
                                ? (widget.loadData!['loads'][index]
                                        ['otherCosts'] as double)
                                    .toString()
                                : null,
                          ),
                          20.heightBox,
                          Card(
                            elevation: 5,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 30,
                                color: Colors.red,
                              ),
                              onPressed: () => showDeleteConfirmationDialog(
                                  context, index, widget.homeController),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                10.heightBox,
                Card(
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () =>
                            showAddLoadDialog(context, widget.homeController),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Load'),
                      ),
                      10.widthBox,
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            widget.homeController
                                .storeCalculatedValues(); // Add this line to store data
                            Get.to(() => MileageFeSection(
                                  homeController: widget.homeController,
                                ));
                          }
                        },
                        icon: const Icon(Icons.arrow_circle_right_outlined),
                        label: const Text('Next'),
                      ),
                    ],
                  ),
                ),
                10.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
