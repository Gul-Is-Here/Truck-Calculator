import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxDouble weeklyFixedCost = 0.0.obs;
  RxDouble weeklyTruckPayment = 0.0.obs;
  RxDouble weeklyTruckInsurance = 0.0.obs;
  RxDouble weeklyTrailerLease = 0.0.obs;
  RxDouble weeklyEldService = 0.0.obs;
  RxDouble weeklyOverHead = 0.0.obs;
  RxDouble weeklyOther = 0.0.obs;

  TextEditingController tPaymentController = TextEditingController();
  TextEditingController tInsuranceController = TextEditingController();
  TextEditingController tTrailerLeaseController = TextEditingController();
  TextEditingController tEldServicesController = TextEditingController();
  TextEditingController tOverHeadController = TextEditingController();
  TextEditingController tOtherController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    tPaymentController.addListener(_calculate);
    tInsuranceController.addListener(_calculate);
    tTrailerLeaseController.addListener(_calculate);
    tEldServicesController.addListener(_calculate);
    tOverHeadController.addListener(_calculate);
    tOtherController.addListener(_calculate);
  }

  @override
  void onClose() {
    tPaymentController.dispose();
    tInsuranceController.dispose();
    tTrailerLeaseController.dispose();
    tEldServicesController.dispose();
    tOverHeadController.dispose();
    tOtherController.dispose();
    super.onClose();
  }

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    } else if (double.tryParse(value) == null) {
      return 'Enter a valid number';
    }
    return null;
  }

  void _calculate() {
    if (validateInput(tPaymentController.text) != null ||
        validateInput(tInsuranceController.text) != null ||
        validateInput(tTrailerLeaseController.text) != null ||
        validateInput(tEldServicesController.text) != null) {
      weeklyFixedCost.value = 0.0; // Reset to 0 if any required field is invalid
      return;
    }

    double truckPaymentAmount = double.tryParse(tPaymentController.text) ?? 0;
    double truckInsuranceAmount = double.tryParse(tInsuranceController.text) ?? 0;
    double trailerLeaseAmount = double.tryParse(tTrailerLeaseController.text) ?? 0;
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
    weeklyTruckInsurance.value = (truckInsuranceAmount * 12) / 52;
    weeklyTrailerLease.value = (trailerLeaseAmount * 12) / 52;
    weeklyEldService.value = (eldService * 12) / 52;
    weeklyOverHead.value = (overHeadAmount * 12) / 52;
    weeklyOther.value = (otherAmount * 12) / 52;

    weeklyFixedCost.value = weeklyTruckPayment.value +
        weeklyTruckInsurance.value +
        weeklyTrailerLease.value +
        weeklyEldService.value +
        weeklyOverHead.value +
        weeklyOther.value;
  }
}
