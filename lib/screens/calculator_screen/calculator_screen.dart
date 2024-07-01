import 'package:dispatched_calculator_app/widgets/custome_textFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/colors.dart';
import '../../constants/fonts_strings.dart';
import '../../controllers/home_controller.dart';
import '../../services/firebase_services.dart';
import '../../widgets/customized_row_label_widget.dart';
import '../../widgets/my_drawer_widget.dart';

class CalculatorScreen extends StatelessWidget {
  CalculatorScreen({super.key});

  final HomeController homeController = Get.put(HomeController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void initializeControllers() async {
    var fetchedValues = await FirebaseServices().fetchFixedWeeklyCost();
    homeController.tTruckPaymentController.text =
        fetchedValues['monthlyTruckPayment'].toString();
    homeController.tInsuranceController.text =
        fetchedValues['monthlyTruckInsurance'].toString();
    homeController.tTrailerLeaseController.text =
        fetchedValues['monthlyTrailerLease'].toString();
    homeController.tEldServicesController.text =
        fetchedValues['monthlyEldService'].toString();
    homeController.tOverHeadController.text =
        fetchedValues['monthlyOverheadCost'].toString();
    homeController.tOtherController.text =
        fetchedValues['monthlyOtherCost'].toString();
    homeController.fTruckWeeklyPayment.value =
        fetchedValues['weeklyTruckPayment']!;
    homeController.fTruckWeeklyTrailerLease.value =
        fetchedValues['weeklyTrailerLease']!;
    homeController.fTruckWeeklyInsurance.value =
        fetchedValues['weeklyInsurancePayment']!;
    homeController.fTruckWeeklyEldServices.value =
        fetchedValues['weeklyEldService']!;
  }

  void _submitForm(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      // Perform form submission
      await FirebaseServices().storeTruckMonthlyPayments(
        isEditableTruckPayment: homeController.isEditableTruckPayment.value,
        weeklyTruckPayment: double.tryParse(
                homeController.weeklyTruckPayment.value.toString()) ??
            0.0,
        weeklyInsurance:
            double.tryParse(homeController.weeklyInsurance.value.toString()) ??
                0.0,
        weeklyTrailerLease: double.tryParse(
                homeController.weeklyTrailerLease.value.toString()) ??
            0.0,
        weeklyEldService:
            double.tryParse(homeController.weeklyEldService.value.toString()) ??
                0.0,
        weeklyOverheadAmount:
            double.tryParse(homeController.tOverHeadController.text) ?? 0.0,
        weeklyOtherCost:
            double.tryParse(homeController.tOtherController.text) ?? 0.0,
        weeklyFixedCost: homeController.weeklyFixedCost.value,
        tWeeklyTruckPayment:
            double.tryParse(homeController.tTruckPaymentController.text) ?? 0.0,
        tWeeklyInsurance:
            double.tryParse(homeController.tInsuranceController.text) ?? 0.0,
        tWeeklyTrailerLease:
            double.tryParse(homeController.tTrailerLeaseController.text) ?? 0.0,
        tWeeklyEldService:
            double.tryParse(homeController.tEldServicesController.text) ?? 0.0,
      );

      homeController.isEditableTruckPayment.value = false;
      await FirebaseServices().toggleIsEditabbleTruckPayment();
      bool updatedIsEditableTruckPayment =
          await FirebaseServices().fetchIsEditabbleTruckPayment();
      homeController.isEditableTruckPayment.value =
          updatedIsEditableTruckPayment;
      initializeControllers();
    }
  }

  void toggleEditMode(BuildContext context) async {
    bool? shouldEdit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Edit'),
        content: const Text('Are you sure you want to edit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              homeController.isEditableTruckPayment.value = true;
              await FirebaseServices().toggleIsEditabbleTruckPayment();
              homeController.updatedIsEditableTruckPayment.value =
                  await FirebaseServices().fetchIsEditabbleTruckPayment();

              homeController.isEditableTruckPayment.value =
                  homeController.updatedIsEditableTruckPayment.value;
              Future.delayed((Duration(seconds: 3)));
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit Amount'),
          content: const Text('Are you sure you want to submit the amount?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _submitForm(context);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeControllers();

    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              'Fixed Cost',
                              style: TextStyle(
                                fontFamily: robotoRegular,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            10.widthBox,
                            IconButton(
                              onPressed: () {
                                toggleEditMode(context);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildRowWithLabel(
                          label: 'Truck Payment',
                          hint: 'e.g., \$2000',
                          controller: homeController.tTruckPaymentController,
                          value: homeController.fTruckWeeklyPayment,
                          validator: homeController.validateInput,
                          isEnable: homeController.isEditableTruckPayment.value,
                        ),
                        buildRowWithLabel(
                          label: 'Insurance',
                          hint: 'e.g., \$400',
                          controller: homeController.tInsuranceController,
                          value: homeController.fTruckWeeklyInsurance,
                          validator: homeController.validateInput,
                          isEnable: homeController.isEditableTruckPayment.value,
                        ),
                        buildRowWithLabel(
                          label: 'Trailer lease',
                          hint: 'e.g., \$300',
                          controller: homeController.tTrailerLeaseController,
                          value: homeController.fTruckWeeklyTrailerLease,
                          validator: homeController.validateInput,
                          isEnable: homeController.isEditableTruckPayment.value,
                        ),
                        buildRowWithLabel(
                          label: 'ELD Service',
                          hint: 'e.g., \$100',
                          controller: homeController.tEldServicesController,
                          value: homeController.fTruckWeeklyEldServices,
                          validator: homeController.validateInput,
                          isEnable: homeController.isEditableTruckPayment.value,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: buildTextFormField(
                                controller: homeController.tOverHeadController,
                                label: 'Overhead',
                                hint: 'e.g., \$50',
                                validator: homeController.validateNonNegative,
                                isEnable:
                                    homeController.isEditableTruckPayment.value,
                                intialValue: homeController.fTrcukOverhead,
                              ),
                            ),
                            Expanded(
                              child: buildTextFormField(
                                controller: homeController.tOtherController,
                                label: 'Other',
                                hint: 'e.g., \$200',
                                validator: homeController.validateNonNegative,
                                isEnable:
                                    homeController.isEditableTruckPayment.value,
                                intialValue: homeController.fTrcukOther,
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
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColor().primaryAppColor,
                borderRadius: const BorderRadius.only(
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
                  if (homeController.isEditableTruckPayment.value)
                    ElevatedButton(
                      onPressed: () {
                        _showConfirmationDialog(context);
                      },
                      child: const Text('Submit'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
