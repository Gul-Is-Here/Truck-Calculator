import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/addLoad_dialogBox.dart';
import '../../widgets/custome_textFormField.dart';
import '../../screens/home_screens/mileage_fee_section.dart';
import '../../widgets/delete_dialogBox.dart';

class LoadScreen extends StatelessWidget {
  final HomeController homeController;

  LoadScreen({required this.homeController});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

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
                    itemCount: homeController.freightChargeControllers.length,
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
                            
                            controller:
                                homeController.freightChargeControllers[index],
                            label: 'Freight Charge (\$)',
                            hint: 'e.g., \$1000',
                            validator: homeController.validateInput,
                          ),
                          buildTextFormField(
                            controller: homeController
                                .dispatchedMilesControllers[index],
                            label: 'Dispatched Miles',
                            hint: 'e.g., 2000',
                            validator: homeController.validateInput,
                          ),
                          buildTextFormField(
                            controller:
                                homeController.estimatedTollsControllers[index],
                            label: 'Estimated Tolls (\$)',
                            hint: 'e.g., \$50',
                            validator: homeController.validateInput,
                          ),
                          buildTextFormField(
                            controller:
                                homeController.otherCostsControllers[index],
                            label: 'Other Costs (\$)',
                            hint: 'e.g., \$100',
                            validator: homeController.validateInput,
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
                                  context, index, homeController),
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
                            showAddLoadDialog(context, homeController),
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
                                homeController: homeController));
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
