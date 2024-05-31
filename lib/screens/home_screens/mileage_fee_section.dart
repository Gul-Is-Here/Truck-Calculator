import 'package:dispatched_calculator_app/screens/home_screens/dispatched_miles_screen.dart';
import 'package:flutter/material.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../widgets/custome_textFormField.dart';

class MileageFeSection extends StatelessWidget {
  final HomeController homeController;

  MileageFeSection({required this.homeController});

  @override
  Widget build(BuildContext context) {
    var homeController = Get.put(HomeController());
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
                    child: Text(
                      "Weekly Fixed Cost \$${homeController.weeklyFixedCost.value.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                buildTextFormField(
                  controller: homeController.mileageFeeController,
                  label: 'Mileage Fee (\$/mile)',
                  hint: 'e.g., \$0.50',
                  validator: homeController.validateInput,
                ),
                buildTextFormField(
                  controller: homeController.fuelController,
                  label: 'Fuel (\$/mile)',
                  hint: 'e.g., \$0.20',
                  validator: homeController.validateInput,
                ),
                buildTextFormField(
                  controller: homeController.defController,
                  label: 'DEF (\$/mile)',
                  hint: 'e.g., \$0.05',
                  validator: homeController.validateInput,
                ),
                buildTextFormField(
                  controller: homeController.driverPayController,
                  label: 'Driver Pay (\$/mile)',
                  hint: 'e.g., \$0.30',
                  validator: homeController.validateInput,
                ),
                buildTextFormField(
                  controller: homeController.factoringFeeController,
                  label: 'Factoring Fee (\$/mile)',
                  hint: 'e.g., \$0.02',
                  validator: homeController.validateInput,
                ),
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
                        if (formKey.currentState!.validate()) {
                          // Navigate to the next screen
                          Get.to(
                              () => LoadScreen(homeController: homeController));
                        }
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
