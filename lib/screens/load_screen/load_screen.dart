import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispatched_calculator_app/screens/load_screen/result_screen.dart';
import 'package:dispatched_calculator_app/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:dispatched_calculator_app/widgets/addLoad_dialogBox.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/colors.dart';
import '../../constants/fonts_strings.dart';
import '../../services/firebase_services.dart';
import '../../widgets/custome_textFormField.dart';


class LoadScreen extends StatefulWidget {
  final HomeController homeController;
  final Map<String, dynamic>? loadData;
  final String? documentId;
  final bool isUpdate;

  const LoadScreen(
      {super.key,
      required this.homeController,
      this.loadData,
      this.documentId,
      required this.isUpdate});

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.homeController.freightChargeControllers.clear();
    widget.homeController.dispatchedMilesControllers.clear();
    widget.homeController.estimatedTollsControllers.clear();
    widget.homeController.otherCostsControllers.clear();
    super.initState();
    // Check if the data has already been loaded
    if (widget.loadData != null) {
      // Load data only if it hasn't been loaded before
      if (widget.homeController.freightChargeControllers.isEmpty) {
        _initializeControllers();
      }
    } else {
      // Ensure at least one load is present
      widget.homeController.addNewLoad();
    }
  }

  void _initializeControllers() {
    var loads = widget.loadData!['loads'] as List<dynamic>;
    for (var load in loads) {
      widget.homeController.freightChargeControllers.add(TextEditingController(
          text: (load['freightCharge'] as num).toString()));
      widget.homeController.dispatchedMilesControllers.add(
          TextEditingController(
              text: (load['dispatchedMiles'] as num).toString()));
      widget.homeController.estimatedTollsControllers.add(TextEditingController(
          text: (load['estimatedTolls'] as num).toString()));
      widget.homeController.otherCostsControllers.add(
          TextEditingController(text: (load['otherCosts'] as num).toString()));
    }
  }

  Future<void> showConfirmationDialog(
      BuildContext context, VoidCallback onYesPressed) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(widget.isUpdate ? 'Confirm Update' : 'Confirm Submit'),
          titleTextStyle: const TextStyle(
              fontFamily: robotoRegular, color: Colors.black, fontSize: 18),
          content: Text(widget.isUpdate
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
                style: TextStyle(color: Colors.red, fontFamily: robotoRegular),
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

  @override
  Widget build(BuildContext context) {
    print(widget.homeController.totalMilageCost.value);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MyDrawerWidget(),
      appBar: AppBar(
          // title: Text('Additional Costs'),
          ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Obx(
                () => Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget
                              .homeController.freightChargeControllers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // const SizedBox(height: 20)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Card(
                                        color: AppColor().secondaryAppColor,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            'Load ${index + 1}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: AppColor().appTextColor,
                                              fontFamily: robotoRegular,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    10.heightBox,
                                    buildTextFormField(
                                      controller: widget.homeController
                                          .freightChargeControllers[index],
                                      label: 'Freight Charge (\$)',
                                      hint: 'e.g., \$1000',
                                      validator:
                                          widget.homeController.validateInput, intialValue: null,
                                    ),
                                    buildTextFormField(
                                      controller: widget.homeController
                                          .dispatchedMilesControllers[index],
                                      label: 'Dispatched Miles',
                                      hint: 'e.g., 2000',
                                      validator:
                                          widget.homeController.validateInput, intialValue: null,
                                    ),
                                    buildTextFormField(
                                      controller: widget.homeController
                                          .estimatedTollsControllers[index],
                                      label: 'Estimated Tolls (\$)',
                                      hint: 'e.g., \$50',
                                      validator:
                                          widget.homeController.validateInput, intialValue: null,
                                    ),
                                    buildTextFormField(
                                        controller: widget.homeController
                                            .otherCostsControllers[index],
                                        label: 'Other Costs (\$)',
                                        hint: 'e.g., \$100',
                                        validator: widget.homeController
                                            .validateNonNegative, intialValue: null, ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 24,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            // Show delete confirmation dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Delete Load'),
                                                  content: Text(
                                                      'Are you sure you want to delete this load?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Delete'),
                                                      onPressed: () {
                                                        if (widget.isUpdate) {
                                                          widget.homeController
                                                              .removeLoad(
                                                                  index);
                                                          Navigator.of(context)
                                                              .pop();
                                                        } else {
                                                          var userId =
                                                              FirebaseServices()
                                                                  .auth
                                                                  .currentUser
                                                                  ?.uid;
                                                          var documentId =
                                                              widget.documentId;
                                                          if (userId != null &&
                                                              documentId !=
                                                                  null) {
                                                            FirebaseServices().deleteLoad(
                                                                documentId:
                                                                    documentId,
                                                                loadIndex:
                                                                    index,
                                                                context:
                                                                    context,
                                                                freightChargeControllers: widget
                                                                    .homeController
                                                                    .freightChargeControllers,
                                                                dispatchedMilesControllers: widget
                                                                    .homeController
                                                                    .dispatchedMilesControllers,
                                                                estimatedTollsControllers: widget
                                                                    .homeController
                                                                    .estimatedTollsControllers,
                                                                otherCostsControllers: widget
                                                                    .homeController
                                                                    .otherCostsControllers,
                                                                userId: userId);
                                                          } else {
                                                            print(
                                                                'User ID or Document ID is null.');
                                                          }
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: TextButton.icon(
                                            style: TextButton.styleFrom(
                                              side: BorderSide(
                                                  color: AppColor()
                                                      .secondaryAppColor),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () => showAddLoadDialog(
                                                context, widget.homeController),
                                            icon: const Icon(Icons.add),
                                            label: Text(
                                              'Add',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    20.heightBox,
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      20.heightBox,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: AppColor().primaryAppColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.elliptical(40, 40),
                  )),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        widget.isUpdate
                            ? TextButton(
                                style: TextButton.styleFrom(
                                  side: const BorderSide(
                                      width: 1, color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  showConfirmationDialog(context, () {
                                    if (formKey.currentState!.validate()) {
                                      widget.homeController
                                          .calculateVariableCosts();
                                      FirebaseServices().updateEntry(
                                        documentId: widget.documentId!,
                                        data: {
                                          'weeklyFixedCost': widget
                                              .homeController
                                              .weeklyFixedCost
                                              .value,
                                          'totalFreightCharges': widget
                                              .homeController
                                              .totalFreightCharges
                                              .value,
                                          'totalDispatchedMiles': widget
                                              .homeController
                                              .totalDispatchedMiles
                                              .value,
                                          'totalMilageCost': widget
                                              .homeController
                                              .totalMilageCost
                                              .value,
                                         
                                          'timestamp':
                                              FieldValue.serverTimestamp(),
                                          'updateTime': DateTime.now(),
                                          'loads': List.generate(
                                            widget
                                                .homeController
                                                .freightChargeControllers
                                                .length,
                                            (index) {
                                              return {
                                                'freightCharge':
                                                    double.tryParse(widget
                                                            .homeController
                                                            .freightChargeControllers[
                                                                index]
                                                            .text) ??
                                                        0.0,
                                                'dispatchedMiles':
                                                    double.tryParse(widget
                                                            .homeController
                                                            .dispatchedMilesControllers[
                                                                index]
                                                            .text) ??
                                                        0.0,
                                                'estimatedTolls':
                                                    double.tryParse(widget
                                                            .homeController
                                                            .estimatedTollsControllers[
                                                                index]
                                                            .text) ??
                                                        0.0,
                                                'otherCosts': double.tryParse(
                                                        widget
                                                            .homeController
                                                            .otherCostsControllers[
                                                                index]
                                                            .text) ??
                                                    0.0,
                                              };
                                            },
                                          ),
                                           'totalProfit': widget
                                              .homeController.totalProfit.value,
                                        },
                                        
                                        

                                      );
                                       widget.homeController
                                          .calculateVariableCosts();
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      Get.to(() => ResultsScreen(
                                          homeController:
                                              widget.homeController));
                                    }
                                  });
                                },
                                child: const Text(
                                  textAlign: TextAlign.center,
                                  'Update',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: robotoRegular),
                                ),
                              )
                            : TextButton(
                                style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                      width: 1, color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  showConfirmationDialog(context, () {
                                    if (formKey.currentState!.validate()) {
                                      widget.homeController
                                          .calculateVariableCosts();

                                      FirebaseServices().storeCalculatedValues(
                                          totalFactoringFee: widget
                                              .homeController
                                              .totalFactoringFee
                                              .value,
                                          totalFreightCharges: widget
                                              .homeController
                                              .totalFreightCharges
                                              .value,
                                          totalDispatchedMiles: widget
                                              .homeController
                                              .totalDispatchedMiles
                                              .value,
                                          totalMileageCost: widget
                                              .homeController
                                              .totalMilageCost
                                              .value,
                                          totalProfit: widget
                                              .homeController.totalProfit.value,
                                          freightChargeControllers: widget
                                              .homeController
                                              .freightChargeControllers
                                              .map((controller) =>
                                                  controller.text)
                                              .toList(),
                                          dispatchedMilesControllers:
                                              widget.homeController.dispatchedMilesControllers.map((controller) => controller.text).toList(),
                                          estimatedTollsControllers: widget.homeController.estimatedTollsControllers.map((controller) => controller.text).toList(),
                                          otherCostsControllers: widget.homeController.otherCostsControllers.map((controller) => controller.text).toList());
                                      Get.snackbar('Success',
                                          'Data submitted successfully',
                                          // backgroundColor: Colors.deepPurpleAccent,
                                          colorText: Colors.white);
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      Get.to(() => ResultsScreen(
                                          homeController:
                                              widget.homeController));
                                    }
                                  });
                                },
                                child: const Text(
                                  textAlign: TextAlign.center,
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: robotoRegular),
                                ),
                              ),
                      ],
                    ),
                  ]))
        ],
      ),
    );
  }
}
