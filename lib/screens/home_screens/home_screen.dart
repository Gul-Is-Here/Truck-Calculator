import 'package:dispatched_calculator_app/controllers/auth_controller.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:dispatched_calculator_app/screens/home_screens/history_screen.dart';
import 'package:dispatched_calculator_app/screens/home_screens/load_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custome_textFormField.dart';
import '../../widgets/customized_row_label_widget.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  var homeController = Get.put(HomeController());
  var authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Get.to(() => HistoryScreen(homeController: homeController));
                  },
                  child: Text('History Screen')),
              ElevatedButton(
                  onPressed: authController.signOut,
                  child: const Text('LogOut')),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Truck Calculator',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Truck Monthly Cost',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 20),

                // Truck Payment TextFormField
                buildRowWithLabel(
                  label: 'TRUCK PAYMENT',
                  hint: 'e.g., \$2000',
                  controller: homeController.tPaymentController,
                  value: homeController.weeklyTruckPayment,
                  validator: homeController.validateInput,
                ),

                // Truck Insurance TextFormField
                buildRowWithLabel(
                  label: 'INSURANCE',
                  hint: 'e.g., \$400',
                  controller: homeController.tInsuranceController,
                  value: homeController.weeklyInsurance,
                  validator: homeController.validateInput,
                ),

                // Truck Trailer Lease TextFormField
                buildRowWithLabel(
                  label: 'TRAILER LEASE',
                  hint: 'e.g., \$300',
                  controller: homeController.tTrailerLeaseController,
                  value: homeController.weeklyTrailerLease,
                  validator: homeController.validateInput,
                ),

                // Truck ELD Service TextFormField
                buildRowWithLabel(
                  label: 'ELD SERVICE',
                  hint: 'e.g., \$100',
                  controller: homeController.tEldServicesController,
                  value: homeController.weeklyEldService,
                  validator: homeController.validateInput,
                ),

                // Truck Overhead Cost TextFormField
                buildTextFormField(
                  controller: homeController.tOverHeadController,
                  label: 'OVERHEAD',
                  hint: 'e.g., \$50',
                ),

                // Truck Other Cost TextFormField
                buildTextFormField(
                  controller: homeController.tOtherController,
                  label: 'OTHER',
                  hint: 'e.g., \$200',
                ),

                const SizedBox(height: 40),
                Center(
                  child: Obx(() => Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '\$${homeController.weeklyFixedCost.value.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Navigate to MileageFeeSection

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
