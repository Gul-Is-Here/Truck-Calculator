import 'package:dispatched_calculator_app/constants/colors.dart';
import 'package:dispatched_calculator_app/controllers/auth_controller.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:dispatched_calculator_app/screens/load_screen/load_screen.dart';
import 'package:dispatched_calculator_app/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../constants/fonts_strings.dart';
import '../../constants/image_strings.dart';
import '../../services/firebase_services.dart';
import '../../widgets/custome_textFormField.dart';
import '../../widgets/customized_row_label_widget.dart';

// ignore: must_be_immutable
class CalculatorScreen extends StatelessWidget {
  CalculatorScreen({Key? key}) : super(key: key);

  final HomeController homeController = Get.put(HomeController());
  final AuthController authController = Get.put(AuthController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Truck Monthly Cost',
                          style: TextStyle(
                            fontFamily: robotoRegular,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Truck Payment TextFormField
                      buildRowWithLabel(
                        label: 'Truck Payment',
                        hint: 'e.g., \$2000',
                        controller: homeController.tTruckPaymentController,
                        value: homeController.weeklyTruckPayment,
                        validator: homeController.validateInput,
                      ),

                      // Truck Insurance TextFormField
                      buildRowWithLabel(
                        label: 'Insurance',
                        hint: 'e.g., \$400',
                        controller: homeController.tInsuranceController,
                        value: homeController.weeklyInsurance,
                        validator: homeController.validateInput,
                      ),

                      // Truck Trailer Lease TextFormField
                      buildRowWithLabel(
                          label: 'Trailer lease',
                          hint: 'e.g., \$300',
                          controller: homeController.tTrailerLeaseController,
                          value: homeController.weeklyTrailerLease,
                          validator: homeController.validateInput),

                      // Truck ELD Service TextFormField
                      buildRowWithLabel(
                        label: 'ELD Service',
                        hint: 'e.g., \$100',
                        controller: homeController.tEldServicesController,
                        value: homeController.weeklyEldService,
                        validator: homeController.validateInput,
                      ),

                      // Truck Overhead Cost TextFormField
                      Row(
                        children: [
                          Expanded(
                            child: buildTextFormField(
                              controller: homeController.tOverHeadController,
                              label: 'Overhead',
                              hint: 'e.g., \$50',
                              validator: homeController.validateNonNegative,
                            ),
                          ),

                          // Truck Other Cost TextFormField
                          Expanded(
                            child: buildTextFormField(
                              controller: homeController.tOtherController,
                              label: 'Other',
                              hint: 'e.g., \$200',
                              validator: homeController.validateNonNegative,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Fixed Footer
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColor().primaryAppColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(40, 40),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Weekly fixed cost',
                      style: TextStyle(
                        color: AppColor().appTextColor,
                        fontFamily: robotoRegular,
                        fontSize: 16,
                      ),
                    ),
                    Obx(
                      () => Text(
                        '\$${homeController.weeklyFixedCost.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: robotoRegular,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColor().appTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Perform form submission
                      FirebaseServices().storeTruckMonthlyPayments(
                        weeklyTruckPayment: double.tryParse(
                                homeController.tTruckPaymentController.text) ??
                            0.0,
                        weeklyInsurance: double.tryParse(
                                homeController.tInsuranceController.text) ??
                            0.0,
                        weeklyTrailerLease: double.tryParse(
                                homeController.tTrailerLeaseController.text) ??
                            0.0,
                        weeklyEldService: double.tryParse(
                                homeController.tEldServicesController.text) ??
                            0.0,
                        weeklyOverheadAmount: double.tryParse(
                                homeController.tOverHeadController.text) ??
                            0.0,
                        weeklyOtherCost: double.tryParse(
                                homeController.tOtherController.text) ??
                            0.0,
                        weeklyFixedCost: homeController.weeklyFixedCost.value,
                      );
                    }
                  },
                  icon: SvgPicture.asset(
                    arrow_forward,
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
