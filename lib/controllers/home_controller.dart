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

  TextEditingController mileageFeeController = TextEditingController();
  TextEditingController fuelController = TextEditingController();
  TextEditingController defController = TextEditingController();
  TextEditingController driverPayController = TextEditingController();
  TextEditingController factoringFeeController = TextEditingController();

  // Lists to handle multiple loads
  var freightChargeControllers = <TextEditingController>[].obs;
  var dispatchedMilesControllers = <TextEditingController>[].obs;
  var estimatedTollsControllers = <TextEditingController>[].obs;
  var otherCostsControllers = <TextEditingController>[].obs;

  RxDouble totalMilageCostPerWeek = 0.0.obs;
  RxDouble totalMileageAndWeeklyFixedCost = 0.0.obs;
  RxDouble profit = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    tPaymentController.addListener(_calculateFixedCost);
    tInsuranceController.addListener(_calculateFixedCost);
    tTrailerLeaseController.addListener(_calculateFixedCost);
    tEldServicesController.addListener(_calculateFixedCost);
    tOverHeadController.addListener(_calculateFixedCost);
    tOtherController.addListener(_calculateFixedCost);

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
    // Reset total values
    double totalFreightCharge = 0.0;
    double totalDispatchedMiles = 0.0;
    double totalEstimatedTolls = 0.0;
    double totalOtherCosts = 0.0;

    for (int i = 0; i < freightChargeControllers.length; i++) {
      totalFreightCharge +=
          double.tryParse(freightChargeControllers[i].text) ?? 0.0;
      totalDispatchedMiles +=
          double.tryParse(dispatchedMilesControllers[i].text) ?? 0.0;
      totalEstimatedTolls +=
          double.tryParse(estimatedTollsControllers[i].text) ?? 0.0;
      totalOtherCosts += double.tryParse(otherCostsControllers[i].text) ?? 0.0;
    }

    // Calculation logic for total costs and profit
    double totalMileageFee =
        (double.tryParse(mileageFeeController.text) ?? 0.0) *
            totalDispatchedMiles;
    double totalFuelCost =
        (double.tryParse(fuelController.text) ?? 0.0) * totalDispatchedMiles;
    double totalDefCost =
        (double.tryParse(defController.text) ?? 0.0) * totalDispatchedMiles;
    double totalDriverPay = (double.tryParse(driverPayController.text) ?? 0.0) *
        totalDispatchedMiles;
    double totalFactoringFee =
        (double.tryParse(factoringFeeController.text) ?? 0.0) *
            totalFreightCharge /
            100; // Factoring fee as a percentage of freight charge

    totalMilageCostPerWeek.value = totalMileageFee +
        totalFuelCost +
        totalDefCost +
        totalDriverPay +
        totalFactoringFee +
        totalEstimatedTolls +
        totalOtherCosts;

    totalMileageAndWeeklyFixedCost.value =
        totalMilageCostPerWeek.value + weeklyFixedCost.value;
    profit.value = totalFreightCharge - totalMileageAndWeeklyFixedCost.value;
  }

  void addNewLoad() {
    freightChargeControllers.add(TextEditingController());
    dispatchedMilesControllers.add(TextEditingController());
    estimatedTollsControllers.add(TextEditingController());
    otherCostsControllers.add(TextEditingController());
  }

  void clearLoadFields() {
    freightChargeControllers.forEach((controller) => controller.clear());
    dispatchedMilesControllers.forEach((controller) => controller.clear());
    estimatedTollsControllers.forEach((controller) => controller.clear());
    otherCostsControllers.forEach((controller) => controller.clear());
  }
}
