import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../app_classes/date_utills.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? newDocumentId;
  var docId;
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

  void moveCurrentWeekDataToHistory(QuerySnapshot currentWeekSnapshot) async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        // Get a reference to the user's document
        DocumentReference userDocRef =
            _firestore.collection('users').doc(user.uid);

        // Store the current week's data in the "history" collection
        for (QueryDocumentSnapshot doc in currentWeekSnapshot.docs) {
          // Cast doc.data() to the correct type
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          await userDocRef.collection('history').add(data);
        }

        // Delete the current week's data from the original collection
        for (QueryDocumentSnapshot doc in currentWeekSnapshot.docs) {
          await userDocRef.collection('calculatedValues').doc(doc.id).delete();
        }

        print('Current week data moved to history successfully');
      } catch (e) {
        print('Error moving current week data to history: $e');
      }
    } else {
      print('No user signed in');
    }
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
    print('Permilafee : ${permileageFee.value}');
    perMileFuel.value = (double.tryParse(perMileFuelController.text) ?? 0.0) *
        totalDispatchedMiles.value;

    print('perMileFuel : ${perMileFuel.value}');
    perMileDef.value = (double.tryParse(perMileDefController.text) ?? 0.0) *
        totalDispatchedMiles.value;
    print('perMileDef : ${perMileDef.value}');
    perMileDriverPay.value =
        (double.tryParse(perMileDriverPayController.text) ?? 0.0) *
            totalDispatchedMiles.value;
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
        totalEstimatedTollsCost.value;
    print('totalProfit : ${totalProfit.value}');
    totalFrightChargesAndTolls.value =
        totalFreightCharges.value + totalEstimatedTollsCost.value;
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

// Stored Data In firebase
  void storeCalculatedValues() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        // Get a reference to the user's document
        DocumentReference userDocRef =
            _firestore.collection('users').doc(user.uid);

        // Generate a new document ID with a timestamp
        newDocumentId = DateTime.now().millisecondsSinceEpoch.toString();

        // Create a reference to the new document inside the 'calculatedValues' subcollection
        DocumentReference newValuesDocRef =
            userDocRef.collection('calculatedValues').doc(newDocumentId);

        // Set the data for the new document
        await newValuesDocRef.set({
          'totalfactoringFee': totalFactoringFee.value,
          'truckPayment': weeklyTruckPayment.value,
          'truckInsurance': weeklyInsurance.value,
          'trailerLease': weeklyTrailerLease.value,
          'EldService': weeklyEldService.value,
          'overheadCost': weeklyoverHeadAmount.value,
          'tOtherCost': weeklyOtherCost.value,
          'weeklyFixedCost': weeklyFixedCost.value,
          'totalFreightCharges': totalFreightCharges.value,
          'totalDispatchedMiles': totalDispatchedMiles.value,
          'totalMilageCost': totalMilageCost.value,
          'totalProfit': totalProfit.value,
          'timestamp': FieldValue.serverTimestamp(),
          'loads': List.generate(freightChargeControllers.length, (index) {
            return {
              'freightCharge':
                  double.tryParse(freightChargeControllers[index].text) ?? 0.0,
              'dispatchedMiles':
                  double.tryParse(dispatchedMilesControllers[index].text) ??
                      0.0,
              'estimatedTolls':
                  double.tryParse(estimatedTollsControllers[index].text) ?? 0.0,
              'otherCosts':
                  double.tryParse(otherCostsControllers[index].text) ?? 0.0,
            };
          }),
        });

        print('Values stored successfully in Firestore');
      } catch (e) {
        print('Error storing values in Firestore: $e');
      }
    } else {
      print('No user signed in');
    }
  }

  void fetchHistoryData() async {
    User? user = auth.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await _firestore
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
    User? user = auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('calculatedValues')
            .get();

        return querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Include the document ID
          docId = data['id'];
          print(docId);
          return data;
        }).toList();
      } catch (e) {
        print('Error fetching entries for editing: $e');
      }
    }
    return [];
  }

  void updateEntry(Map<String, dynamic> newData) async {
    User? user = auth.currentUser;
    newDocumentId = docId;
    if (user != null) {
      if (newDocumentId == null || newDocumentId!.isEmpty) {
        print('Error: newDocumentId is null or empty.');
        return;
      }

      try {
        DocumentReference docRef = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('calculatedValues')
            .doc(newDocumentId);
        print('Document ID: $newDocumentId');

        // Check if the document exists before updating
        bool docExists = await docRef.get().then((doc) => doc.exists);
        if (docExists) {
          await docRef.update(newData);
          print('Data to be updated: $newData');
          fetchHistoryData(); // Refresh history data
          print('Entry updated successfully');
        } else {
          print('Document with ID $newDocumentId does not exist.');
        }
      } catch (e) {
        print('Error updating entry: $e');
      }
    } else {
      print('Error: No user is currently logged in.');
    }
  }

  Future<Map<String, dynamic>?> fetchEntryForEditing(String documentId) async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await _firestore
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
      User? user = auth.currentUser;
      if (user != null) {
        print('Fetching data for user: ${user.uid}'); // Debug print
        QuerySnapshot querySnapshot = await _firestore
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
