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
  TextEditingController freightChargeController = TextEditingController();
  TextEditingController dispatchedMilesController = TextEditingController();
  TextEditingController estimatedTollsController = TextEditingController();
  TextEditingController otherCostsController = TextEditingController();

  RxDouble totalMilageCostPerWeek = 0.0.obs;
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
    final double mileageFee = double.tryParse(mileageFeeController.text) ?? 0.0;
    final double fuel = double.tryParse(fuelController.text) ?? 0.0;
    final double def = double.tryParse(defController.text) ?? 0.0;
    final double driverPay = double.tryParse(driverPayController.text) ?? 0.0;
    final double factoringFee =
        double.tryParse(factoringFeeController.text) ?? 0.0;
    final double freightCharge =
        double.tryParse(freightChargeController.text) ?? 0.0;
    final double dispatchedMiles =
        double.tryParse(dispatchedMilesController.text) ?? 0.0;
    final double estimatedTolls =
        double.tryParse(estimatedTollsController.text) ?? 0.0;
    final double otherCosts = double.tryParse(otherCostsController.text) ?? 0.0;

    final double totalMileageFee = (mileageFee * dispatchedMiles);
    final double totalFuelCost = (fuel * dispatchedMiles);
    final double totalDefCost = (def * dispatchedMiles);
    final double totalDriverPay = (driverPay * dispatchedMiles);
    final double totalFactoringFee = (factoringFee * dispatchedMiles);

    totalMilageCostPerWeek.value = totalMileageFee +
        totalFuelCost +
        totalDefCost +
        totalDriverPay +
        totalFactoringFee +
        estimatedTolls +
        otherCosts +
        weeklyFixedCost.value;

    profit.value = freightCharge - totalMilageCostPerWeek.value;
  }
}
