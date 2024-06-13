import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../app_classes/date_utills.dart';
import '../services/firebase_services.dart';

class HomeController extends GetxController {

  RxBool isLoading = false.obs;
  RxDouble weeklyFixedCost = 0.0.obs;
  RxDouble weeklyTruckPayment = 0.0.obs;
  RxDouble weeklyInsurance = 0.0.obs;
  RxDouble weeklyTrailerLease = 0.0.obs;
  RxDouble weeklyEldService = 0.0.obs;
  RxBool fixedCostCalculated = false.obs;
  RxDouble weeklyoverHeadAmount = 0.0.obs;
  RxDouble weeklyOtherCost = 0.0.obs;

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

  var freightChargeControllers = <TextEditingController>[].obs;
  var dispatchedMilesControllers = <TextEditingController>[].obs;
  var estimatedTollsControllers = <TextEditingController>[].obs;
  var otherCostsControllers = <TextEditingController>[].obs;
  RxList<Map<String, dynamic>> historyData = <Map<String, dynamic>>[].obs;


// loads controller save value in variables
 RxDouble freightCharge=0.0.obs;
 RxDouble dispatchedMiles=0.0.obs;
RxDouble estimatedTolls=0.0.obs;
RxDouble otherCost=0.0.obs;
 //----------------
  RxDouble totalFrightChargesAndTolls = 0.0.obs;
  RxDouble totalMilageCost = 0.0.obs;
  RxDouble totalProfit = 0.0.obs;
  RxDouble totalFreightCharges = 0.0.obs;
  RxDouble totalEstimatedTollsCost = 0.0.obs;
  RxDouble totalOtherCost = 0.0.obs;
  RxDouble totalFactoringFee = 0.0.obs;
  RxDouble totalDispatchedMiles = 0.0.obs;
  RxDouble permileageFee = 0.0.obs;
  RxDouble perMileFuel = 0.0.obs;
  RxDouble perMileDef = 0.0.obs;
  RxDouble perMileDriverPay = 0.0.obs;
  Rx<DateTime?> timestamp = Rx<DateTime?>(null);

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
    fetchHistoryData(); // fetch data from firebase
    fetchResultData();
  }

  @override
  void onClose() {
    tPaymentController.dispose();
    tInsuranceController.dispose();
    tTrailerLeaseController.dispose();
    tEldServicesController.dispose();
    tOverHeadController.dispose();
    tOtherController.dispose();
    perMileageFeeController.dispose();
    perMileFuelController.dispose();
    perMileDefController.dispose();
    perMileDriverPayController.dispose();
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

// A method to delete data from calculatedValues Collection and transfer to History Collection
  void transferAndDeleteWeeklyData() async {
    User? user = FirebaseServices().auth.currentUser;
    if (user != null) {
      try {
        // Get a reference to the user's document
        DocumentReference userDocRef =
            FirebaseServices().firestore.collection('users').doc(user.uid);

        // Calculate the start and end dates of the current week
        DateTime now = DateTime.now();
        DateTime startOfWeek =
            DateTime(now.year, now.month, now.day - now.weekday);
        DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
        print('Current date time : $now');
        print('Start of the week :$startOfWeek');
        print('End of the week : $endOfWeek');

        // Query documents in the calculatedValues subcollection within the current week
        QuerySnapshot querySnapshot = await userDocRef
            .collection('calculatedValues')
            .where('timestamp',
                isGreaterThanOrEqualTo: startOfWeek,
                isLessThanOrEqualTo: endOfWeek)
            .get();
        if (endOfWeek == true) {
          for (QueryDocumentSnapshot doc in querySnapshot.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            await userDocRef.collection('history').doc(doc.id).set(data);
            await userDocRef
                .collection('calculatedValues')
                .doc(doc.id)
                .delete();

            print(
                'Specific data transferred to history and original documents deleted successfully.');
          }
        }

        // Transfer each document to the history subcollection
      } catch (e) {
        print(
            'Error transferring data to history and deleting original documents: $e');
      }
    } else {
      print('No user signed in');
    }
  }

  // A method to get data from History Collection
  Future<List<Map<String, dynamic>>> fetchHistoryDataById() async {
    final User? user = FirebaseServices().auth.currentUser;

    if (user == null) {
      print('Error: No user is currently logged in.');
      return [];
    }

    try {
      final QuerySnapshot querySnapshot = await FirebaseServices().firestore
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .get();

      final List<Map<String, dynamic>> documents =
          querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'data': doc.data() as Map<String, dynamic>,
        };
      }).toList();

      print('Fetched ${documents.length} documents.');
      return documents;
    } catch (e) {
      print('Error fetching history data: $e');
      return [];
    }
  }

  void calculateDateTime() {}
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

  // for non null value only use in other costs and overHead Costs
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

    weeklyoverHeadAmount.value = (overHeadAmount * 12) / 52;
    weeklyOtherCost.value = (otherAmount * 12) / 52;

    weeklyFixedCost.value = weeklyTruckPayment.value +
        weeklyInsurance.value +
        weeklyTrailerLease.value +
        weeklyEldService.value +
        weeklyoverHeadAmount.value +
        weeklyOtherCost.value;
  }

  void calculateVariableCosts() {
    totalFreightCharges.value = 0.0;
    totalDispatchedMiles.value = 0.0;
    totalEstimatedTollsCost.value = 0.0;
    totalOtherCost.value = 0.0;

    for (int i = 0; i < freightChargeControllers.length; i++) {
       freightCharge.value =
          double.tryParse(freightChargeControllers[i].text) ?? 0.0;
       dispatchedMiles.value =
          double.tryParse(dispatchedMilesControllers[i].text) ?? 0.0;
       estimatedTolls.value =
          double.tryParse(estimatedTollsControllers[i].text) ?? 0.0;
       otherCost.value = double.tryParse(otherCostsControllers[i].text) ?? 0.0;

      totalFreightCharges.value += freightCharge.value ;
      totalDispatchedMiles.value += dispatchedMiles.value ;
      totalEstimatedTollsCost.value += estimatedTolls.value ;
      totalOtherCost.value += otherCost.value ;
    }

    permileageFee.value =
        (double.tryParse(perMileageFeeController.text) ?? 0.0) *
            totalDispatchedMiles.value;
    print('Permilafee : ${permileageFee.value}');
    perMileFuel.value = (double.tryParse(perMileFuelController.text) ?? 0.0) *
        totalDispatchedMiles.value;

    print('perMileFuel : ${perMileFuel.value}');
    perMileDef.value = (double.tryParse(perMileDefController.text) ?? 0.0) *
        totalDispatchedMiles.value;
    print('perMileDef : ${perMileDef.value}');
    perMileDriverPay.value =
        ((double.tryParse(perMileDriverPayController.text) ?? 0.0) *
                totalDispatchedMiles.value) *
            1.2;
    print('perMileDriverPay : ${perMileDriverPay.value}');

    totalFactoringFee.value = (totalFreightCharges.value * 2) / 100;
    print('totalFactoringFee : ${totalFactoringFee.value}');

    totalMilageCost.value = permileageFee.value +
        perMileFuel.value +
        perMileDef.value +
        perMileDriverPay.value +
        totalFactoringFee.value;
    print('totalMilageCost : ${totalMilageCost.value}');
    totalProfit.value = totalFreightCharges.value -
        weeklyFixedCost.value -
        totalMilageCost.value -
        totalEstimatedTollsCost.value -
        totalOtherCost.value;
    print('totalProfit : ${totalProfit.value}');
    totalFrightChargesAndTolls.value = totalFreightCharges.value;
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
      QuerySnapshot querySnapshot = await FirebaseServices().firestore
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

  Future<List<Map<String, dynamic>>> fetchAllEntriesForEditing() async {
    User? user = FirebaseServices().auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseServices().firestore
            .collection('users')
            .doc(user.uid)
            .collection('calculatedValues')
            .get();

        return querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Include the document ID
          FirebaseServices().docId = data['id'];
          print(FirebaseServices().docId);
          return data;
        }).toList();
      } catch (e) {
        print('Error fetching entries for editing: $e');
      }
    }
    return [];
  }

  void updateEntry(Map<String, dynamic> newData) async {
    User? user = FirebaseServices().auth.currentUser;
    FirebaseServices().loadsId = FirebaseServices().docId;
    if (user != null) {
      if (FirebaseServices().loadsId == null || FirebaseServices().loadsId!.isEmpty) {
        print('Error: newDocumentId is null or empty.');
        return;
      }

      try {
        DocumentReference docRef = FirebaseServices().firestore
            .collection('users')
            .doc(user.uid)
            .collection('calculatedValues')
            .doc(FirebaseServices().loadsId);
        print('Document ID: $FirebaseServices().loadsId');

        // Check if the document exists before updating
        bool docExists = await docRef.get().then((doc) => doc.exists);
        if (docExists) {
          await docRef.update(newData);
          print('Data to be updated: $newData');
          fetchHistoryData(); // Refresh history data
          print('Entry updated successfully');
        } else {
          print('Document with ID $FirebaseServices().loadsId does not exist.');
        }
      } catch (e) {
        print('Error updating entry: $e');
      }
    } else {
      print('Error: No user is currently logged in.');
    }
  }

  Future<Map<String, dynamic>?> fetchEntryForEditing(String documentId) async {
    User? user = FirebaseServices().auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseServices().firestore
            .collection('users')
            .doc(user.uid)
            .collection('calculatedValues')
            .doc(documentId)
            .get();

        return doc.data() as Map<String, dynamic>?;
      } catch (e) {
        print('Error fetching entry for editing: $e');
      }
    }
    return null;
  }

  void deleteLoad(String? userId, String? documentId, int loadIndex,
      BuildContext context) async {
    try {
      // Fetch the load data that corresponds to the loadIndex
      final loadToRemove = {
        'freightCharge': num.parse(freightChargeControllers[loadIndex].text),
        'dispatchedMiles':
            num.parse(dispatchedMilesControllers[loadIndex].text),
        'estimatedTolls': num.parse(estimatedTollsControllers[loadIndex].text),
        'otherCosts': num.parse(otherCostsControllers[loadIndex].text),
      };

      // Remove the specific load entry from the 'loads' array in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('calculatedValues')
          .doc(documentId)
          .update({
        'loads': FieldValue.arrayRemove([loadToRemove])
      });

      // Remove the load from the local state
      freightChargeControllers.removeAt(loadIndex);
      dispatchedMilesControllers.removeAt(loadIndex);
      estimatedTollsControllers.removeAt(loadIndex);
      otherCostsControllers.removeAt(loadIndex);
      calculateVariableCosts();
      print('Load deleted successfully');
      //  Navigator.of(context).pop();
    } catch (error) {
      print('Error deleting load: $error');
    }
  }

  // Load ResultScreen Data from Firebase
  void fetchResultData() async {
    try {
      User? user = FirebaseServices().auth.currentUser;
      if (user != null) {
        print('Fetching data for user: ${user.uid}'); // Debug print
        QuerySnapshot querySnapshot = await FirebaseServices().firestore
            .collection('users')
            .doc(user.uid)
            .collection('calculatedValues')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
          print('Fetched data: $data'); // Debug print

          totalFrightChargesAndTolls.value =
              (data['totalFreightCharges'] ?? 0) +
                  (data['totalEstimatedTollsCost'] ?? 0);
          totalProfit.value = data['totalProfit'] ?? 0;
          totalDispatchedMiles.value = data['totalDispatchedMiles'] ?? 0;
        } else {}
      } else {
        Get.snackbar('Error', 'No user signed in',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data: $e',
          snackPosition: SnackPosition.BOTTOM);
      print('Error fetching data: $e'); // Debug print
    }
  }
}
