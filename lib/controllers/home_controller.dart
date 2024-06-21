import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firebase_services.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool updatedIsEditableMilage = false.obs;
  var weeklyTruckPayment = 0.0.obs;
  var weeklyInsurance = 0.0.obs;
  var weeklyTrailerLease = 0.0.obs;
  var weeklyEldService = 0.0.obs;
  var weeklyoverHeadAmount = 0.0.obs;
  var weeklyOtherCost = 0.0.obs;
  var weeklyFixedCost = 0.0.obs;
  RxBool isEditable = true.obs;
  RxBool isEditableMilage = true.obs;
  RxDouble totalWeeklyFixedCost = 0.0.obs;
  final tTruckPaymentController = TextEditingController();
  final tInsuranceController = TextEditingController();
  final tTrailerLeaseController = TextEditingController();
  final tEldServicesController = TextEditingController();
  final tOverHeadController = TextEditingController();
  final tOtherController = TextEditingController();

  TextEditingController perMileageFeeController = TextEditingController();
  TextEditingController perMileFuelController = TextEditingController();
  TextEditingController perMileDefController = TextEditingController();
  TextEditingController perMileDriverPayController = TextEditingController();
  TextEditingController factoringFeeController = TextEditingController();

  var freightChargeControllers = <TextEditingController>[].obs;
  var dispatchedMilesControllers = <TextEditingController>[].obs;
  var estimatedTollsControllers = <TextEditingController>[].obs;
  var otherCostsControllers = <TextEditingController>[].obs;
  RxList<Map<String, dynamic>> historyData = <Map<String, dynamic>>[].obs;

  // Loads controller save value in variables
  RxDouble freightCharge = 0.0.obs;
  RxDouble dispatchedMiles = 0.0.obs;
  RxDouble estimatedTolls = 0.0.obs;
  RxDouble otherCost = 0.0.obs;

  RxDouble totalFrightChargesAndTolls = 0.0.obs;
  RxDouble totalMilageCost = 0.0.obs;
  RxDouble totalProfit = 0.0.obs;
  RxDouble totalFreightCharges = 0.0.obs;
  RxDouble totalEstimatedTollsCost = 0.0.obs;
  RxDouble totalOtherCost = 0.0.obs;
  RxDouble totalFactoringFee = 0.0.obs;
  RxDouble totalDispatchedMiles = 0.0.obs;

  double permileageFee = 0.0;
  double perMileFuel = 0.0;
  double perMileDef = 0.0;
  double perMileDriverPay = 0.0;
  Rx<DateTime?> timestamp = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    tTruckPaymentController.addListener(_calculateFixedCost);
    tInsuranceController.addListener(_calculateFixedCost);
    tTrailerLeaseController.addListener(_calculateFixedCost);
    tEldServicesController.addListener(_calculateFixedCost);
    tOverHeadController.addListener(_calculateFixedCost);
    tOtherController.addListener(_calculateFixedCost);
    weeklyFixedCost.addListener;

    addNewLoad(); // Initialize with the first load
    fetchHistoryData(); // Fetch data from Firebase
    FirebaseServices().perMileageAmountStoreAndFetch(); // Fetch per-mile cost
    FirebaseServices().fetchFixedWeeklyCost(); // Fetch weekly fixed costs
    loadEditableStateTruckPayment();
  }

  @override
  void onClose() {
    tTruckPaymentController.dispose();
    tInsuranceController.dispose();
    tTrailerLeaseController.dispose();
    tEldServicesController.dispose();
    tOverHeadController.dispose();
    tOtherController.dispose();

    for (var controller in freightChargeControllers) {
      controller.dispose();
    }
    for (var controller in dispatchedMilesControllers) {
      controller.dispose();
    }
    for (var controller in estimatedTollsControllers) {
      controller.dispose();
    }
    for (var controller in otherCostsControllers) {
      controller.dispose();
    }

    super.onClose();
  }

  ///------------------> Shared Prefrance for Truck Weekly Fixed payment ------------------

  Future<void> storeEditableTruckPayment() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isEditable', isEditable.value);
  }

  Future<void> loadEditableStateTruckPayment() async {
    final prefs = await SharedPreferences.getInstance();
    isEditable.value =
        prefs.getBool('isEditable') ?? true; // Default to true if not set
  }

  void toggleEditableStateTruckPayment() async {
    isEditable.value = !isEditable.value; // Toggle the state

    await storeEditableTruckPayment(); // Store the updated state
  }

  ///-----------------------------------------------------------------------------------------

  ///-----------------------------------------------------------------------------------------
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Must be filled!';
    } else if (double.tryParse(value) == null) {
      return 'Enter a valid number';
    } else if (double.parse(value) < 0) {
      return 'Cannot enter negative value';
    }
    return null;
  }

  // For non-null value only use in other costs and overhead costs
  String? validateNonNegative(String? value) {
    if (value == null || value.isEmpty) {
      return null; // No validation needed for empty values
    } else if (double.tryParse(value) == null) {
      return 'Enter a valid number';
    } else if (double.parse(value) < 0) {
      return 'Value must be positive';
    }
    return null; // No errors
  }

  void _calculateFixedCost() async {
    // Get the monthly amounts from the input fields
    double truckPaymentAmount =
        double.tryParse(tTruckPaymentController.text) ?? 0;
    double truckInsuranceAmount =
        double.tryParse(tInsuranceController.text) ?? 0;
    double trailerLeaseAmount =
        double.tryParse(tTrailerLeaseController.text) ?? 0;
    double eldService = double.tryParse(tEldServicesController.text) ?? 0;
    double overHeadAmount = double.tryParse(tOverHeadController.text) ?? 0;
    double otherAmount = double.tryParse(tOtherController.text) ?? 0;

    // Calculate weekly values from monthly amounts
    weeklyTruckPayment.value = (truckPaymentAmount * 12) / 52;
    weeklyInsurance.value = (truckInsuranceAmount * 12) / 52;
    weeklyTrailerLease.value = (trailerLeaseAmount * 12) / 52;
    weeklyEldService.value = (eldService * 12) / 52;
    weeklyoverHeadAmount.value = (overHeadAmount * 12) / 52;
    weeklyOtherCost.value = (otherAmount * 12) / 52;

    // Calculate the total weekly fixed cost from the individual weekly costs
    weeklyFixedCost.value = weeklyTruckPayment.value +
        weeklyInsurance.value +
        weeklyTrailerLease.value +
        weeklyEldService.value +
        weeklyoverHeadAmount.value +
        weeklyOtherCost.value;

    // Fetch the fixed weekly costs from Firebase
    // Map<String, double> weeklyFixedCosts =
    //     await FirebaseServices().fetchFixedWeeklyCost();

    // // Update the individual weekly costs with the fetched values if they exist
    // weeklyTruckPayment.value =
    //     weeklyFixedCosts['truckPayment'] ?? weeklyTruckPayment.value;
    // weeklyInsurance.value =
    //     weeklyFixedCosts['truckInsurance'] ?? weeklyInsurance.value;
    // weeklyTrailerLease.value =
    //     weeklyFixedCosts['trailerLease'] ?? weeklyTrailerLease.value;
    // weeklyEldService.value =
    //     weeklyFixedCosts['eldService'] ?? weeklyEldService.value;
    // weeklyoverHeadAmount.value =
    //     weeklyFixedCosts['overheadCost'] ?? weeklyoverHeadAmount.value;
    // weeklyOtherCost.value =
    //     weeklyFixedCosts['otherCost'] ?? weeklyOtherCost.value;

    // // Recalculate the total weekly fixed cost after updating with fetched values
    // weeklyFixedCost.value = weeklyTruckPayment.value +
    //     weeklyInsurance.value +
    //     weeklyTrailerLease.value +
    //     weeklyEldService.value +
    //     weeklyoverHeadAmount.value +
    //     weeklyOtherCost.value;
    // totalWeeklyFixedCost.value =
    //     weeklyFixedCosts['weeklyFixedCost'] ?? weeklyFixedCost.value;
  }

  //------------------->Truck Weekly Fixed Cost Value <----------------------
  Future<void> updateFixedCosts() async {
    Map<String, double> weeklyFixedCosts =
        await FirebaseServices().fetchFixedWeeklyCost();

    weeklyTruckPayment.value =
        weeklyFixedCosts['truckPayment'] ?? weeklyTruckPayment.value;
    weeklyInsurance.value =
        weeklyFixedCosts['truckInsurance'] ?? weeklyInsurance.value;
    weeklyTrailerLease.value =
        weeklyFixedCosts['trailerLease'] ?? weeklyTrailerLease.value;
    weeklyEldService.value =
        weeklyFixedCosts['eldService'] ?? weeklyEldService.value;
    weeklyoverHeadAmount.value =
        weeklyFixedCosts['overheadCost'] ?? weeklyoverHeadAmount.value;
    weeklyOtherCost.value =
        weeklyFixedCosts['otherCost'] ?? weeklyOtherCost.value;

    totalWeeklyFixedCost.value =
        weeklyFixedCosts['weeklyFixedCost'] ?? weeklyFixedCost.value;
    weeklyFixedCost.value = weeklyTruckPayment.value +
        weeklyInsurance.value +
        weeklyTrailerLease.value +
        weeklyEldService.value +
        weeklyoverHeadAmount.value +
        weeklyOtherCost.value;
  }

  void calculateVariableCosts() async {
    // Initialize totals
    totalFreightCharges.value = 0.0;
    totalDispatchedMiles.value = 0.0;
    totalEstimatedTollsCost.value = 0.0;
    totalOtherCost.value = 0.0;
    // Calculate totals from controllers
    for (int i = 0; i < freightChargeControllers.length; i++) {
      freightCharge.value =
          double.tryParse(freightChargeControllers[i].text) ?? 0.0;
      dispatchedMiles.value =
          double.tryParse(dispatchedMilesControllers[i].text) ?? 0.0;
      estimatedTolls.value =
          double.tryParse(estimatedTollsControllers[i].text) ?? 0.0;
      otherCost.value = double.tryParse(otherCostsControllers[i].text) ?? 0.0;

      totalFreightCharges.value += freightCharge.value;
      totalDispatchedMiles.value += dispatchedMiles.value;
      totalEstimatedTollsCost.value += estimatedTolls.value;
      totalOtherCost.value += otherCost.value;
    }
    Map<String, dynamic> weeklyFixedCosts =
        await FirebaseServices().fetchFixedWeeklyCost();

    // Update with fetched values
    weeklyTruckPayment.value =
        weeklyFixedCosts['truckPayment'] ?? weeklyTruckPayment.value;
    weeklyInsurance.value =
        weeklyFixedCosts['truckInsurance'] ?? weeklyInsurance.value;
    weeklyTrailerLease.value =
        weeklyFixedCosts['trailerLease'] ?? weeklyTrailerLease.value;
    weeklyEldService.value =
        weeklyFixedCosts['eldService'] ?? weeklyEldService.value;
    weeklyoverHeadAmount.value =
        weeklyFixedCosts['overheadCost'] ?? weeklyoverHeadAmount.value;
    weeklyOtherCost.value =
        weeklyFixedCosts['otherCost'] ?? weeklyOtherCost.value;
    totalWeeklyFixedCost.value = weeklyFixedCosts['weeklyFixedCost'];
    // Fetch per-mile costs from Firebase
    Map<String, double> perMileageCosts =
        await FirebaseServices().perMileageAmountStoreAndFetch();
    permileageFee = perMileageCosts['perMileFee'] ?? 0.0;
    perMileFuel = perMileageCosts['perMileFuel'] ?? 0.0;
    perMileDef = perMileageCosts['perMileDef'] ?? 0.0;
    perMileDriverPay = perMileageCosts['perMileDriverPay'] ?? 0.0;

    // Calculate total factoring fee
    totalFactoringFee.value = (totalFreightCharges.value * 2) / 100;

    // Calculate total mileage cost
    totalMilageCost.value = (permileageFee * totalDispatchedMiles.value) +
        (perMileFuel * totalDispatchedMiles.value) +
        (perMileDef * totalDispatchedMiles.value) +
        ((perMileDriverPay * totalDispatchedMiles.value) * 1.2) +
        totalFactoringFee.value;
    totalProfit.value = totalFreightCharges.value -
        totalWeeklyFixedCost.value -
        totalMilageCost.value -
        totalEstimatedTollsCost.value -
        totalOtherCost.value;
    print('totalProfit: ${totalProfit.value}');
    print('totalWeeklyFixedCost: ${totalWeeklyFixedCost.value}');
    print('totalMilageCost: ${totalMilageCost.value}');
    print('totalEstimatedTollsCost: ${totalEstimatedTollsCost.value}');
    print('totalOtherCost: ${totalOtherCost.value}');
  }

  void addNewLoad() {
    var freightChargeController = TextEditingController();
    var dispatchedMilesController = TextEditingController();
    var estimatedTollsController = TextEditingController();
    var otherCostsController = TextEditingController();

    freightChargeController.addListener(calculateVariableCosts);
    dispatchedMilesController.addListener(calculateVariableCosts);
    estimatedTollsController.addListener(calculateVariableCosts);
    otherCostsController.addListener(calculateVariableCosts);

    freightChargeControllers.add(freightChargeController);
    dispatchedMilesControllers.add(dispatchedMilesController);
    estimatedTollsControllers.add(estimatedTollsController);
    otherCostsControllers.add(otherCostsController);
  }

  void removeLoad(int index) {
    if (freightChargeControllers.length > 1) {
      freightChargeControllers.removeAt(index);
      dispatchedMilesControllers.removeAt(index);
      estimatedTollsControllers.removeAt(index);
      otherCostsControllers.removeAt(index);
    }
  }

  void clearLoadFields() {
    for (var controller in estimatedTollsControllers) {
      controller.clear();
    }
    for (var controller in otherCostsControllers) {
      controller.clear();
    }
  }

  void fetchHistoryData() async {
    User? user = FirebaseServices().auth.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseServices()
          .firestore
          .collection('users')
          .doc(user.uid)
          .collection('calculatedValues')
          .get();

      // Process the data from the querySnapshot as needed
      // For example, convert it to a list of entries
      List<DocumentSnapshot> documents = querySnapshot.docs;
      // Update your state with the new data
      print('Fetched ${documents.length} documents.');
    } else {
      print('Error: No user is currently logged in.');
    }
  }
}
