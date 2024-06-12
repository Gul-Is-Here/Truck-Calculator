import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispatched_calculator_app/constants/colors.dart';
import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:dispatched_calculator_app/screens/load_screen/result_screen.dart';
import 'package:dispatched_calculator_app/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/customized_row_label_widget.dart';

class MileageFeSection extends StatelessWidget {
  final HomeController homeController;
  final bool isUpdate;

  const MileageFeSection(
      {super.key, required this.homeController, required this.isUpdate});

  @override
  Widget build(BuildContext context) {
    final formKey1 = GlobalKey<FormState>();

    Future<void> showConfirmationDialog(
        BuildContext context, VoidCallback onYesPressed) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button for close
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title:
                Text(isUpdate == false ? 'Confirm Update' : 'Confirm Submit'),
            titleTextStyle: const TextStyle(
                fontFamily: robotoRegular, color: Colors.black, fontSize: 18),
            content: Text(isUpdate == false
                ? 'Are you sure you want to update?'
                : 'Are you sure you want to submit?'),
            contentTextStyle: TextStyle(
              fontFamily: robotoRegular,
              color: Colors.black,
            ),
            actions: [
              TextButton(
                child: const Text(
                  'No',
                  style:
                      TextStyle(color: Colors.red, fontFamily: robotoRegular),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss the dialog
                },
              ),
              TextButton(
                child: Text(
                  'Yes',
                  style: TextStyle(
                      color: AppColor().primaryAppColor,
                      fontFamily: robotoRegular),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss the dialog
                  onYesPressed(); // Call the provided callback
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MyDrawerWidget(),
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: formKey1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Mileage Fee',
                            style: TextStyle(
                                fontFamily: robotoRegular,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          10.widthBox,
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Tooltip(
                              triggerMode: TooltipTriggerMode.tap,
                              message:
                                  'Factoring fee is the 2% of total fright changres ${(homeController.totalFreightCharges.value * 2) / 100}',
                              child: Icon(
                                Icons.info_outline,
                                size: 30,
                                color: AppColor().primaryAppColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
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
                      // screenHeight < 800
                      //     ? SizedBox(
                      //         height: MediaQuery.of(context).size.height * .1,
                      //       )
                      //     : SizedBox(
                      //         height: MediaQuery.of(context).size.height * .15,
                      //       ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          10.heightBox,
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: AppColor().primaryAppColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(45, 25),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          "Total",
                          style: TextStyle(
                            color: AppColor().appTextColor,
                            fontFamily: robotoRegular,
                            fontSize: 16,
                          ),
                          maxLines:
                              null, // Allows the text to use as many lines as needed
                          overflow: TextOverflow
                              .visible, // Ensures text is visible and wrapped
                          softWrap: true,
                        ),
                        5.widthBox,
                        Tooltip(
                          triggerMode: TooltipTriggerMode.tap,
                          message:
                              'Factoring fee is the 2% of total fright changres ${(homeController.totalFreightCharges.value * 2) / 100}',
                          child: Icon(
                            Icons.info_outline,
                            color: AppColor().appTextColor,
                          ),
                        )
                      ],
                    ),
                    Obx(() => Text(
                          textAlign: TextAlign.center,
                          '\$${homeController.totalMilageCost.value.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: AppColor().appTextColor,
                              fontFamily: robotoRegular,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                isUpdate == false
                    ? TextButton(
                        style: TextButton.styleFrom(
                          side: const BorderSide(width: 1, color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          showConfirmationDialog(context, () {
                            if (formKey1.currentState!.validate()) {
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
                                'totalProfit': homeController.totalProfit.value,
                                'timestamp': FieldValue.serverTimestamp(),
                                'updateTime': DateTime.now(),
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
                                                  .otherCostsControllers[index]
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
                          });
                        },
                        child: const Text(
                          textAlign: TextAlign.center,
                          'Update',
                          style: TextStyle(
                              color: Colors.white, fontFamily: robotoRegular),
                        ),
                      )
                    : TextButton(
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(width: 1, color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          showConfirmationDialog(context, () {
                            if (formKey1.currentState!.validate()) {
                              homeController.calculateVariableCosts();
                              homeController.storeCalculatedValues();
                              Get.snackbar(
                                  'Success', 'Data submitted successfully',
                                  // backgroundColor: Colors.deepPurpleAccent,
                                  colorText: Colors.white);
                              Navigator.of(context).pop(); // Close the dialog
                              Get.to(() => ResultsScreen(
                                  homeController: homeController));
                            }
                          });
                        },
                        child: const Text(
                          textAlign: TextAlign.center,
                          'Submit',
                          style: TextStyle(
                              color: Colors.white, fontFamily: robotoRegular),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
