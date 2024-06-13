import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velocity_x/velocity_x.dart';

class FirebaseServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String truckMonthlyPaymentsID = '';
  String perMilageId = '';
  String loadsId = '';
  var docId;
  // Stored Data In firebase Truck Fixed Monthly Payment
  void storeTruckMonthlyPayments({
    required double weeklyTruckPayment,
    required double weeklyInsurance,
    required double weeklyTrailerLease,
    required double weeklyEldService,
    required double weeklyoverHeadAmount,
    required double weeklyOtherCost,
    required double weeklyFixedCost,
  }) async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        // Get a reference to the user's document
        DocumentReference userDocRef =
            firestore.collection('users').doc(user.uid);

        // Generate a new document ID with a timestamp
        truckMonthlyPaymentsID =
            DateTime.now().millisecondsSinceEpoch.toString();

        // Create a reference to the new document inside the 'calculatedValues' subcollection
        DocumentReference newValuesDocRef = userDocRef
            .collection('truckPaymentCollection')
            .doc(truckMonthlyPaymentsID);

        // Set the data for the new document
        await newValuesDocRef.set({
          // 'totalfactoringFee': totalFactoringFee.value,
          'truckPayment': weeklyTruckPayment,
          'truckInsurance': weeklyInsurance,
          'trailerLease': weeklyTrailerLease,
          'EldService': weeklyEldService,
          'overheadCost': weeklyoverHeadAmount,
          'tOtherCost': weeklyOtherCost,
          'weeklyFixedCost': weeklyFixedCost,
        });

        print('Truck Payment values stored successfully in Firestore');
      } catch (e) {
        print('Error storing values in Firestore: $e');
      }
    } else {
      print('No user signed in');
    }
  }

  //stored per milage id
  void storePerMileageAmount({
    required double perMileFeeController,
    required double perMileFuelController,
    required double perMileDefController,
    required double perMileDriverPayController,
  }) async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        // Get a reference to the user's document
        DocumentReference userDocRef =
            firestore.collection('users').doc(user.uid);

        // Generate a new document ID with a timestamp
        perMilageId = DateTime.now().millisecondsSinceEpoch.toString();

        // Create a reference to the new document inside the 'calculatedValues' subcollection
        DocumentReference newValuesDocRef =
            userDocRef.collection('perMilageCost').doc(perMilageId);

        // Set the data for the new document
        await newValuesDocRef.set({
          'MilageFeePerMile': perMileFuelController,
          'fuelFeePerMile': perMileFuelController,
          'defFeePerMile': perMileDefController,
          'driverPayFeePerMile': perMileDriverPayController,
        });

        print('Per Mileage Cost stored successfully in Firestore');
      } catch (e) {
        print('Error storing values in Firestore: $e');
      }
    } else {
      print('No user signed in');
    }
  }

// Store Loads of Truck in Firebase
  void storeCalculatedValues({
  required double totalFactoringFee,
  required double totalFreightCharges,
  required double totalDispatchedMiles,
  required double totalMilageCost,
  required double totalProfit,
  required List<String> freightChargeControllers,
  required List<String> dispatchedMilesControllers,
  required List<String> estimatedTollsControllers,
  required List<String> otherCostsControllers,
}) async {
  User? user = auth.currentUser;
  if (user != null) {
    try {
      DocumentReference userDocRef = firestore.collection('users').doc(user.uid);
      loadsId = DateTime.now().millisecondsSinceEpoch.toString();
      DocumentReference newValuesDocRef = userDocRef.collection('calculatedValues').doc(loadsId);

      await newValuesDocRef.set({
        'totalfactoringFee': totalFactoringFee,
        'totalFreightCharges': totalFreightCharges,
        'totalDispatchedMiles': totalDispatchedMiles,
        'totalMilageCost': totalMilageCost,
        'totalProfit': totalProfit,
        'timestamp': FieldValue.serverTimestamp(),
        'updateTime': DateTime.now(),
        'loads': List.generate(freightChargeControllers.length, (index) {
          return {
            'freightCharge': double.tryParse(freightChargeControllers[index]) ?? 0.0,
            'dispatchedMiles': double.tryParse(dispatchedMilesControllers[index]) ?? 0.0,
            'estimatedTolls': double.tryParse(estimatedTollsControllers[index]) ?? 0.0,
            'otherCosts': double.tryParse(otherCostsControllers[index]) ?? 0.0,
          };
        }),
      });

      print('Loads values Stored successfully in Firestore');
    } catch (e) {
      print('Error storing values in Firestore: $e');
    }
  } else {
    print('No user signed in');
  }
}

}
