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
  final String? documentId;
  final bool isUpdate;

  LoadScreen(
      {required this.homeController,
      this.loadData,
      this.documentId,
      required this.isUpdate});

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.homeController.freightChargeControllers.clear();
    widget.homeController.dispatchedMilesControllers.clear();
    widget.homeController.estimatedTollsControllers.clear();
    widget.homeController.otherCostsControllers.clear();
    super.initState();
    // Check if the data has already been loaded
    if (widget.loadData != null) {
      // Load data only if it hasn't been loaded before

      if (widget.homeController.freightChargeControllers.isEmpty) {
        _initializeControllers();
      }
    } else {
      // Ensure at least one load is present
      widget.homeController.addNewLoad();
    }
  }

  void _initializeControllers() {
    var loads = widget.loadData!['loads'] as List<dynamic>;
    for (var load in loads) {
      widget.homeController.freightChargeControllers.add(TextEditingController(
          text: (load['freightCharge'] as num).toString()));
      widget.homeController.dispatchedMilesControllers.add(
          TextEditingController(
              text: (load['dispatchedMiles'] as num).toString()));
      widget.homeController.estimatedTollsControllers.add(TextEditingController(
          text: (load['estimatedTolls'] as num).toString()));
      widget.homeController.otherCostsControllers.add(
          TextEditingController(text: (load['otherCosts'] as num).toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.documentId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Additional Costs'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Obx(
          () => Form(
            key: formKey,
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          10.heightBox,
                          buildTextFormField(
                            controller: widget
                                .homeController.freightChargeControllers[index],
                            label: 'Freight Charge (\$)',
                            hint: 'e.g., \$1000',
                            validator: widget.homeController.validateInput,
                          ),
                          buildTextFormField(
                            controller: widget.homeController
                                .dispatchedMilesControllers[index],
                            label: 'Dispatched Miles',
                            hint: 'e.g., 2000',
                            validator: widget.homeController.validateInput,
                          ),
                          buildTextFormField(
                            controller: widget.homeController
                                .estimatedTollsControllers[index],
                            label: 'Estimated Tolls (\$)',
                            hint: 'e.g., \$50',
                            validator: widget.homeController.validateInput,
                          ),
                          buildTextFormField(
                            controller: widget
                                .homeController.otherCostsControllers[index],
                            label: 'Other Costs (\$)',
                            hint: 'e.g., \$100',
                            // validator: widget.homeController.validateInput,
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
                              onPressed: () {
                                // Show delete confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Load'),
                                      content: Text(
                                          'Are you sure you want to delete this load?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            if (widget.isUpdate == true) {
                                              widget.homeController
                                                  .removeLoad(index);
                                            } else {
                                              Navigator.of(context)
                                                  .pop(); // Close dialog
                                              var userId = widget.homeController
                                                  .auth.currentUser?.uid;
                                              var documentId =
                                                  widget.documentId;
                                              if (userId != null &&
                                                  documentId != null) {
                                                widget.homeController
                                                    .deleteLoad(userId,
                                                        documentId, index);
                                              } else {
                                                print(
                                                    'User ID or Document ID is null.');
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          )
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
                            Get.to(() => MileageFeSection(
                                  isUpdate: widget.isUpdate,
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
