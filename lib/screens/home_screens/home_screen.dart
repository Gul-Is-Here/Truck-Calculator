import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../widgets/custome_textFormField.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var homeController = Get.put(HomeController());
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Truck Calculator',
          style: TextStyle(color: Colors.white, fontFamily: 'Raleway-Bold'),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.heightBox,
              Center(
                  child: Text(
                'Truck Weekly Cost',
                style: TextStyle(fontFamily: 'Raleway-Bold', fontSize: 18),
              )),
              10.heightBox,

              // Truck Payment TextFormField
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: buildTextFormField(
                      controller: homeController.tPaymentController,
                      label: 'TRUCK PAYMENT',
                      hint: 'e.g., \$2000',
                      validator: homeController.validateInput,
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      child: Center(
                          child: Obx(() => Text(homeController
                              .weeklyTruckPayment.value
                              .toStringAsFixed(2)))),
                    ),
                  ))
                ],
              ),
              // Truck Insurance TextFormField
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: buildTextFormField(
                      controller: homeController.tInsuranceController,
                      label: 'INSURANCE',
                      hint: 'e.g., \$400',
                      validator: homeController.validateInput,
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      child: Center(
                          child: Obx(() => Text(homeController
                              .weeklyTruckInsurance.value
                              .toStringAsFixed(2)))),
                    ),
                  ))
                ],
              ),
              // Truck Trailer Lease TextFormField
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: buildTextFormField(
                      controller: homeController.tTrailerLeaseController,
                      label: 'TRAILER LEASE',
                      hint: 'e.g., \$300',
                      validator: homeController.validateInput,
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      child: Center(
                          child: Obx(() => Text(homeController
                              .weeklyTrailerLease.value
                              .toStringAsFixed(2)))),
                    ),
                  ))
                ],
              ),
              // Truck ELD Service TextFormField
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: buildTextFormField(
                      controller: homeController.tEldServicesController,
                      label: 'ELD SERVICE',
                      hint: 'e.g., \$100',
                      validator: homeController.validateInput,
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      child: Center(
                          child: Obx(() => Text(homeController
                              .weeklyEldService.value
                              .toStringAsFixed(2)))),
                    ),
                  ))
                ],
              ),
              // Truck Overhead Cost TextFormField
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: buildTextFormField(
                      controller: homeController.tOverHeadController,
                      label: 'OVERHEAD',
                      hint: 'e.g., \$50',
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      child: Center(
                          child: Obx(() => Text(homeController
                              .weeklyOverHead.value
                              .toStringAsFixed(2)))),
                    ),
                  ))
                ],
              ),
              // Truck Other Cost TextFormField
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: buildTextFormField(
                      controller: homeController.tOtherController,
                      label: 'OTHER',
                      hint: 'e.g., \$200',
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      child: Center(
                          child: Obx(() => Text(homeController.weeklyOther.value
                              .toStringAsFixed(2)))),
                    ),
                  ))
                ],
              ),
              20.heightBox,
              Center(
                child: Obx(() => Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        'Weekly Fixed Cost  \$${homeController.weeklyFixedCost.value.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )),
              ),
              const Divider()
              // Trcuk Cost per Miles
              
            ],
          ),
        ),
      ),
    );
  }
}
