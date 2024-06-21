import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:dispatched_calculator_app/services/firebase_services.dart';
import 'package:dispatched_calculator_app/widgets/my_drawer_widget.dart';
import '../../constants/fonts_strings.dart';
import '../../widgets/customized_row_label_widget.dart';
import '../../constants/colors.dart';

class MileageFeSection extends StatelessWidget {
  final HomeController homeController;
  final bool isUpdate;

  const MileageFeSection(
      {Key? key, required this.homeController, required this.isUpdate});

  @override
  Widget build(BuildContext context) {
    final formKey1 = GlobalKey<FormState>();

    void _submitForm() async {
      if (formKey1.currentState!.validate()) {
        FirebaseServices().storePerMileageAmount(
          isEditabbleMilage: homeController.isEditableMilage.value,
          perMileFee:
              double.tryParse(homeController.perMileageFeeController.text) ??
                  0.0,
          perMileFuel:
              double.tryParse(homeController.perMileFuelController.text) ?? 0.0,
          perMileDef:
              double.tryParse(homeController.perMileDefController.text) ?? 0.0,
          perMileDriverPay:
              double.tryParse(homeController.perMileDriverPayController.text) ??
                  0.0,
        );
        // After submitting, hide the submit button
        homeController.isEditableMilage.value = false;
        await FirebaseServices().toggleIsEditabbleMilage();
        bool updatedIsEditableMilage =
            await FirebaseServices().fetchIsEditabbleMilage();
        homeController.isEditableMilage.value = updatedIsEditableMilage;
      }
    }

    Future<void> showSubmitConfirmationDialog() async {
      bool? shouldSubmit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm Submission'),
          content: Text('Are you sure you want to submit the data?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                _submitForm();
              },
              child: Text('Yes'),
            ),
          ],
        ),
      );
    }

    Future<void> showEditConfirmationDialog() async {
      bool? shouldEdit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm Edit'),
          content: Text('Are you sure you want to edit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                homeController.isEditableMilage.value = true;
                await FirebaseServices().toggleIsEditabbleMilage();
                // After toggling, update UI based on the new value
                homeController.updatedIsEditableMilage.value =
                    await FirebaseServices().fetchIsEditabbleMilage();
                homeController.updatedIsEditableMilage.value =
                    homeController.isEditableMilage.value;

                Navigator.of(context).pop(true);
              },
              child: Text('Yes'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MyDrawerWidget(),
      appBar: AppBar(),
      body: Obx(
        () => Column(
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {
                                  showEditConfirmationDialog();
                                },
                                icon: Icon(Icons.edit),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        buildRowWithLabel(
                          label: 'Mileage Fee (\$/mile)',
                          hint: 'e.g., \$0.50',
                          controller: homeController.perMileageFeeController,
                          value: homeController.permileageFee.obs,
                          validator: homeController.validateInput,
                          isEnable:
                              homeController.updatedIsEditableMilage.value,
                        ),
                        buildRowWithLabel(
                          label: 'Fuel (\$/mile)',
                          hint: 'e.g., \$0.20',
                          controller: homeController.perMileFuelController,
                          value: homeController.perMileFuel.obs,
                          validator: homeController.validateInput,
                          isEnable:
                              homeController.updatedIsEditableMilage.value,
                        ),
                        buildRowWithLabel(
                          label: 'DEF (\$/mile)',
                          hint: 'e.g., \$0.05',
                          controller: homeController.perMileDefController,
                          value: homeController.perMileDef.obs,
                          validator: homeController.validateInput,
                          isEnable:
                              homeController.updatedIsEditableMilage.value,
                        ),
                        buildRowWithLabel(
                          label: 'Driver Pay (\$/mile)',
                          hint: 'e.g., \$0.30',
                          controller: homeController.perMileDriverPayController,
                          value: homeController.perMileDriverPay.obs,
                          validator: homeController.validateInput,
                          isEnable:
                              homeController.updatedIsEditableMilage.value,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColor().primaryAppColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(45, 25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              color: AppColor().appTextColor,
                              fontFamily: robotoRegular,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 5),
                          Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message:
                                'Factoring fee is the 2% of total freight charges ${(homeController.totalFreightCharges.value * 2) / 100}',
                            child: Icon(
                              Icons.info_outline,
                              color: AppColor().appTextColor,
                            ),
                          ),
                        ],
                      ),
                      Obx(() => Text(
                            '\$${homeController.totalMilageCost.value.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AppColor().appTextColor,
                              fontFamily: robotoRegular,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                  Obx(
                    () => homeController.updatedIsEditableMilage.value
                        ? ElevatedButton(
                            onPressed: () {
                              showSubmitConfirmationDialog();
                            },
                            child: Text('Submit'),
                          )
                        : Container(),
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
