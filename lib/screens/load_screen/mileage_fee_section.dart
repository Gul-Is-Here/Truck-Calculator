import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../constants/fonts_strings.dart';
import '../../controllers/home_controller.dart';
import '../../services/firebase_services.dart';
import '../../widgets/customized_row_mileage.dart';
import '../../widgets/my_drawer_widget.dart';

class MileageFeSection extends StatelessWidget {
  final HomeController homeController;
  final bool isUpdate;

  const MileageFeSection(
      {Key? key, required this.homeController, required this.isUpdate});

  @override
  Widget build(BuildContext context) {
    final formKey1 = GlobalKey<FormState>();

    void submitForm() async {
      if (formKey1.currentState!.validate()) {
        await FirebaseServices().storePerMileageAmount(
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
                submitForm();
                homeController.updatedIsEditableMilage.value = false;
                homeController.isEditableMilage.value =
                    homeController.updatedIsEditableMilage.value;
                Navigator.of(context).pop(true);
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
                await FirebaseServices().toggleIsEditabbleMilage();
                homeController.updatedIsEditableMilage.value =
                    await FirebaseServices().fetchIsEditabbleMilage();

                homeController.isEditableMilage.value =
                    homeController.updatedIsEditableMilage.value;

                Navigator.of(context).pop(true);
              },
              child: Text('Yes'),
            ),
          ],
        ),
      );
    }

    void initializeControllers() async {
      var fetchedValues = await FirebaseServices().fetchPerMileageAmount();
      homeController.perMileageFeeController.text =
          fetchedValues['milageFeePerMile'].toString();
      homeController.perMileFuelController.text =
          fetchedValues['fuelFeePerMile'].toString();
      homeController.perMileDefController.text =
          fetchedValues['defFeePerMile'].toString();
      homeController.perMileDriverPayController.text =
          fetchedValues['driverPayFeePerMile'].toString();
    }

    initializeControllers();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MyDrawerWidget(),
      appBar: AppBar(),
      body: Obx(
        () => Column(
          children: [
            SingleChildScrollView(
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
                      buildRowForMileage(
                        intialValue:
                            homeController.fPermileageFee.value.toString(),
                        label: 'Mileage Fee (\$/mile)',
                        hint: 'e.g., \$0.50',
                        controller: homeController.perMileageFeeController,
                        value: homeController.fPermileageFee,
                        validator: homeController.validateInput,
                        isEnable: homeController.updatedIsEditableMilage.value,
                      ),
                      buildRowForMileage(
                        intialValue:
                            homeController.fPerMileFuel.value.toString(),
                        label: 'Fuel (\$/mile)',
                        hint: 'e.g., \$0.20',
                        controller: homeController.perMileFuelController,
                        value: homeController.fPerMileFuel,
                        validator: homeController.validateInput,
                        isEnable: homeController.updatedIsEditableMilage.value,
                      ),
                      buildRowForMileage(
                        intialValue:
                            homeController.fPerMileDef.value.toString(),
                        label: 'DEF (\$/mile)',
                        hint: 'e.g., \$0.05',
                        controller: homeController.perMileDefController,
                        value: homeController.fPerMileDef,
                        validator: homeController.validateInput,
                        isEnable: homeController.updatedIsEditableMilage.value,
                      ),
                      buildRowForMileage(
                        intialValue:
                            homeController.fPerMileDriverPay.value.toString(),
                        label: 'Driver Pay (\$/mile)',
                        hint: 'e.g., \$0.30',
                        controller: homeController.perMileDriverPayController,
                        value: homeController.fPerMileDriverPay,
                        validator: homeController.validateInput,
                        isEnable: homeController.updatedIsEditableMilage.value,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            const SizedBox(height: 20),
            Obx(
              () => homeController.isEditableMilage.value == true
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor().primaryAppColor,
                          foregroundColor: AppColor().appTextColor,
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * .36)),
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
    );
  }
}
