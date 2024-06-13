import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispatched_calculator_app/constants/colors.dart';
import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:dispatched_calculator_app/screens/load_screen/result_screen.dart';
import 'package:dispatched_calculator_app/services/firebase_services.dart';
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
                        )),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      FirebaseServices().storePerMileageAmount(
                          perMileFeeController: double.tryParse(homeController
                                  .perMileageFeeController.text) ??
                              0.0,
                          perMileFuelController: double.tryParse(
                                  homeController.perMileFuelController.text) ??
                              0.0,
                          perMileDefController: double.tryParse(
                                  homeController.perMileDefController.text) ??
                              0.0,
                          perMileDriverPayController: double.tryParse(
                                  homeController
                                      .perMileDriverPayController.text) ??
                              0.0);
                    },
                    child: Text('Mileage Fee'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
