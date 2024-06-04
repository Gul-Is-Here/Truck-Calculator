
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxDouble weeklyFixedCost = 0.0.obs;
  RxDouble weeklyTruckPayment = 0.0.obs;
  RxDouble weeklyInsurance = 0.0.obs;
  RxDouble weeklyTrailerLease = 0.0.obs;
  RxDouble weeklyEldService = 0.0.obs;
  RxBool fixedCostCalculated = false.obs;

  TextEditingController tPaymentController = TextEditingController();
  TextEditingController tInsuranceController = TextEditingController();
  TextEditingController tTrailerLeaseController = TextEditingController();
  TextEditingController tEldServicesController = TextEditingController();
  TextEditingController tOverHeadController = TextEditingController();
  TextEditingController tOtherController = TextEditingController();

  TextEditingController perMileageFeeController = TextEditingController();
  TextEditingController perMileFuelController = TextEditingController();
  TextEditingController perMileDefController = TextEditingController();
  TextEditingController perMileDriverPayController = TextEditingController();
  TextEditingController factoringFeeController = TextEditingController();

  // Lists to handle multiple loads
  var freightChargeControllers = <TextEditingController>[].obs;
  var dispatchedMilesControllers = <TextEditingController>[].obs;
  var estimatedTollsControllers = <TextEditingController>[].obs;
  var otherCostsControllers = <TextEditingController>[].obs;

  RxDouble totalMilageCostPerWeek = 0.0.obs;
  RxDouble totalMilageCost = 0.0.obs;
  RxDouble totalProfit = 0.0.obs;

  // Variables to store overall values
  RxDouble totalFreightCharges = 0.0.obs;
  RxDouble totalEstimatedTollsCost = 0.0.obs;
  RxDouble totalOtherCost = 0.0.obs;

  RxDouble totalFactoringFee = 0.0.obs;
  RxDouble totalDispatchedMiles = 0.0.obs;
  // Per Mile Value Stores Variables
  RxDouble permileageFee = 0.0.obs;
  RxDouble perMileFuel = 0.0.obs;
  RxDouble perMileDef = 0.0.obs;
  RxDouble perMileDriverPay = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    tPaymentController.addListener(_calculateFixedCost);
    tInsuranceController.addListener(_calculateFixedCost);
    tTrailerLeaseController.addListener(_calculateFixedCost);
    tEldServicesController.addListener(_calculateFixedCost);
    tOverHeadController.addListener(_calculateFixedCost);
    tOtherController.addListener(_calculateFixedCost);

    perMileageFeeController.addListener(calculateVariableCosts);
    perMileFuelController.addListener(calculateVariableCosts);
    perMileDefController.addListener(calculateVariableCosts);
    perMileDriverPayController.addListener(calculateVariableCosts);

    addNewLoad(); // Initialize with the first load
  }

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    } else if (double.tryParse(value) == null) {
      return 'Enter a valid number';
    }
    return null;
  }

  void _calculateFixedCost() {
    if (validateInput(tPaymentController.text) != null ||
        validateInput(tInsuranceController.text) != null ||
        validateInput(tTrailerLeaseController.text) != null ||
        validateInput(tEldServicesController.text) != null) {
      weeklyFixedCost.value =
          0.0; // Reset to 0 if any required field is invalid
      return;
    }

    double truckPaymentAmount = double.tryParse(tPaymentController.text) ?? 0;
    double truckInsuranceAmount =
        double.tryParse(tInsuranceController.text) ?? 0;
    double trailerLeaseAmount =
        double.tryParse(tTrailerLeaseController.text) ?? 0;
    double eldService = double.tryParse(tEldServicesController.text) ?? 0;
    double overHeadAmount = double.tryParse(tOverHeadController.text) ?? 0;
    double otherAmount = double.tryParse(tOtherController.text) ?? 0;

    calculateFixedWeeklyCost(
      truckPaymentAmount,
      truckInsuranceAmount,
      trailerLeaseAmount,
      eldService,
      overHeadAmount,
      otherAmount,
    );

    fixedCostCalculated.value = true;
  }

  void calculateFixedWeeklyCost(
    double truckPaymentAmount,
    double truckInsuranceAmount,
    double trailerLeaseAmount,
    double eldService,
    double overHeadAmount,
    double otherAmount,
  ) {
    weeklyTruckPayment.value = (truckPaymentAmount * 12) / 52;
    weeklyInsurance.value = (truckInsuranceAmount * 12) / 52;
    weeklyTrailerLease.value = (trailerLeaseAmount * 12) / 52;
    weeklyEldService.value = (eldService * 12) / 52;

    overHeadAmount = (overHeadAmount * 12) / 52;
    otherAmount = (otherAmount * 12) / 52;

    weeklyFixedCost.value = weeklyTruckPayment.value +
        weeklyInsurance.value +
        weeklyTrailerLease.value +
        weeklyEldService.value +
        overHeadAmount +
        otherAmount;
  }

  void calculateVariableCosts() {
    totalFreightCharges.value = 0.0;
    totalDispatchedMiles.value = 0.0;
    totalEstimatedTollsCost.value = 0.0;
    totalOtherCost.value = 0.0;

    for (int i = 0; i < freightChargeControllers.length; i++) {
      double freightCharge =
          double.tryParse(freightChargeControllers[i].text) ?? 0.0;
      double dispatchedMiles =
          double.tryParse(dispatchedMilesControllers[i].text) ?? 0.0;
      double estimatedTolls =
          double.tryParse(estimatedTollsControllers[i].text) ?? 0.0;
      double otherCosts = double.tryParse(otherCostsControllers[i].text) ?? 0.0;

      totalFreightCharges.value += freightCharge;
      totalDispatchedMiles.value += dispatchedMiles;
      totalEstimatedTollsCost.value += estimatedTolls;
      totalOtherCost.value += otherCosts;
    }

    permileageFee.value =
        (double.tryParse(perMileageFeeController.text) ?? 0.0) *
            totalDispatchedMiles.value;
    perMileFuel.value = (double.tryParse(perMileFuelController.text) ?? 0.0) *
        totalDispatchedMiles.value;
    perMileDef.value = (double.tryParse(perMileDefController.text) ?? 0.0) *
        totalDispatchedMiles.value;
    perMileDriverPay.value =
        (double.tryParse(perMileDriverPayController.text) ?? 0.0) *
            totalDispatchedMiles.value;

    totalFactoringFee.value = (totalFreightCharges.value * 2) / 100;
    totalMilageCost.value = permileageFee.value +
        perMileFuel.value +
        perMileDef.value +
        perMileDriverPay.value +
        totalFactoringFee.value;
    totalProfit.value = totalFreightCharges.value -
        weeklyFixedCost.value -
            totalMilageCost.value -
            totalEstimatedTollsCost.value;
  }

  // void calculateVariableCosts() {
  //   totalFreightCharges.value = 0.0;
  //   totalDispatchedMiles.value = 0.0;
  //   totalEstimatedTollsCost.value = 0.0;
  //   totalOtherCost.value = 0.0;

  //   for (int i = 0; i < freightChargeControllers.length; i++) {
  //     double freightCharge =
  //         double.tryParse(freightChargeControllers[i].text) ?? 0.0;
  //     double dispatchedMiles =
  //         double.tryParse(dispatchedMilesControllers[i].text) ?? 0.0;
  //     double estimatedTolls =
  //         double.tryParse(estimatedTollsControllers[i].text) ?? 0.0;
  //     double otherCosts = double.tryParse(otherCostsControllers[i].text) ?? 0.0;

  //     totalFreightCharges.value += freightCharge;
  //     totalDispatchedMiles.value += dispatchedMiles;
  //     totalEstimatedTollsCost.value += estimatedTolls;
  //     totalOtherCost.value += otherCosts;
  //   }

  //   double totalMileageFee =
  //       (double.tryParse(perMileageFeeController.text) ?? 0.0) *
  //           totalDispatchedMiles.value;
  //   double totalFuelCost =
  //       (double.tryParse(perMileFuelController.text) ?? 0.0) *
  //           totalDispatchedMiles.value;
  //   double totalDefCost = (double.tryParse(perMileDefController.text) ?? 0.0) *
  //       totalDispatchedMiles.value;
  //   double totalDriverPay =
  //       (double.tryParse(perMileDriverPayController.text) ?? 0.0) *
  //           totalDispatchedMiles.value;

  //   totalFactoringFee.value = (totalFreightCharges.value * 2) / 100;

  //   totalMilageCostPerWeek.value =
  //       totalMileageFee + totalFuelCost + totalDefCost + totalDriverPay;

  //   totalMileageAndWeeklyFixedCost.value = totalMilageCostPerWeek.value +
  //       weeklyFixedCost.value +
  //       totalFactoringFee.value;
  //   print('Total Dispatched Miles :  ${totalDispatchedMiles.value}');
  //   print('Total Tolls Miles :  ${totalEstimatedTollsCost.value}');
  //   print('Total Factoring Fee  :  ${totalFactoringFee.value}');
  //   print('Total Freight Charges :  ${totalFreightCharges.value}');
  //   print('Total Total  Miles :  ${totalMilageCost.value}');
  // }

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
  // Remove The Load
  void removeLoad(int index) {
  if (freightChargeControllers.length > 1) {
    freightChargeControllers.removeAt(index);
    dispatchedMilesControllers.removeAt(index);
    estimatedTollsControllers.removeAt(index);
    otherCostsControllers.removeAt(index);
  }
}


  void clearLoadFields() {
    for (var controller in freightChargeControllers) {
      controller.clear();
    }
    for (var controller in dispatchedMilesControllers) {
      controller.clear();
    }
    for (var controller in estimatedTollsControllers) {
      controller.clear();
    }
    for (var controller in otherCostsControllers) {
      controller.clear();
    }
  }
}
