import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String docId = '';


 

  Future<void> storeTruckMonthlyPayments({
    required double weeklyTruckPayment,
    required double weeklyInsurance,
    required double weeklyTrailerLease,
    required double weeklyEldService,
    required double weeklyOverheadAmount,
    required double weeklyOtherCost,
    required double weeklyFixedCost,
  }) async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        CollectionReference truckPaymentCollection = firestore
            .collection('users')
            .doc(user.uid)
            .collection('truckPaymentCollection');

        QuerySnapshot snapshot = await truckPaymentCollection.limit(1).get();

        DocumentReference docRef;
        if (snapshot.docs.isNotEmpty) {
          // If a document exists, get the reference to the existing document
          docRef = snapshot.docs.first.reference;
        } else {
          // If no document exists, create a new one with a generated ID
        String truckMonthlyPaymentsID =
              DateTime.now().millisecondsSinceEpoch.toString();
          docRef = truckPaymentCollection.doc(truckMonthlyPaymentsID);
        }

        await docRef.set({
          'truckPayment': weeklyTruckPayment,
          'truckInsurance': weeklyInsurance,
          'trailerLease': weeklyTrailerLease,
          'eldService': weeklyEldService,
          'overheadCost': weeklyOverheadAmount,
          'weeklyFixedCost': weeklyFixedCost,
          'otherCost': weeklyOtherCost,
        });

        print('Truck Payment values stored successfully in Firestore');
      } catch (e) {
        print('Error storing values in Firestore: $e');
      }
    } else {
      print('No user signed in');
    }
  }

  Future<void> storePerMileageAmount({
    required double perMileFee,
    required double perMileFuel,
    required double perMileDef,
    required double perMileDriverPay,
  }) async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        // Check if there is an existing document
        QuerySnapshot existingDocs = await firestore
            .collection('users')
            .doc(user.uid)
            .collection('perMileageCost')
            .limit(1) // Limit to 1 document
            .get();

        // Use existing document if found, otherwise create a new one
        if (existingDocs.docs.isNotEmpty) {
          // Update existing document
          DocumentReference existingDocRef = existingDocs.docs.first.reference;
          await existingDocRef.update({
            'milageFeePerMile': perMileFee,
            'fuelFeePerMile': perMileFuel,
            'defFeePerMile': perMileDef,
            'driverPayFeePerMile': perMileDriverPay,
          });
          print('Per Mileage Cost updated successfully in Firestore');
        } else {
          // Create new document
          String perMileageId =
              DateTime.now().millisecondsSinceEpoch.toString();
          DocumentReference newValuesDocRef = firestore
              .collection('users')
              .doc(user.uid)
              .collection('perMileageCost')
              .doc(perMileageId);

          await newValuesDocRef.set({
            'milageFeePerMile': perMileFee,
            'fuelFeePerMile': perMileFuel,
            'defFeePerMile': perMileDef,
            'driverPayFeePerMile': perMileDriverPay,
          });

          print('Per Mileage Cost stored successfully in Firestore');
        }
      } catch (e) {
        print('Error storing/updating values in Firestore: $e');
      }
    } else {
      print('No user signed in');
    }
  }

// Fetch Per Milage Values from Firebase
  Future<Map<String, double>> perMileageAmountStoreAndFetch() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot snapshot = await firestore
            .collection('users')
            .doc(user.uid)
            .collection('perMileageCost')
            .limit(1) // Limit to 1 document
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Extract values from the document
          var data = snapshot.docs.first.data() as Map<String, dynamic>;

          double perMileFee = data['milageFeePerMile'] ?? 0.0;
          double perMileFuel = data['fuelFeePerMile'] ?? 0.0;
          double perMileDef = data['defFeePerMile'] ?? 0.0;
          double perMileDriverPay = data['driverPayFeePerMile'] ?? 0.0;

          return {
            'perMileFee': perMileFee,
            'perMileFuel': perMileFuel,
            'perMileDef': perMileDef,
            'perMileDriverPay': perMileDriverPay,
          };
        } else {
          print('No document found in Firestore for perMileageCost');
        }
      } catch (e) {
        print('Error fetching values from Firestore: $e');
      }
    } else {
      print('No user signed in');
    }

    return {
      'perMileFee': 0.0,
      'perMileFuel': 0.0,
      'perMileDef': 0.0,
      'perMileDriverPay': 0.0,
    };
  }

  ///----------------> Fetch Total Fixed Weekly Cost From Firebase <---------------------

  Future<Map<String, double>> fetchFixedWeeklyCost() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot snapshot = await firestore
            .collection('users')
            .doc(user.uid)
            .collection('truckPaymentCollection')
            .limit(1) // Limit to 1 document
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Extract values from the document
          var data = snapshot.docs.first.data() as Map<String, dynamic>;

          double truckPayment = data['truckPayment'] ?? 0.0;
          double truckInsurance = data['truckInsurance'] ?? 0.0;
          double trailerLease = data['trailerLease'] ?? 0.0;
          double eldService = data['eldService'] ?? 0.0;
          double overheadCost = data['overheadCost'] ?? 0.0;
          double otherCost = data['otherCost'] ?? 0.0;
          double weeklyFixedCost = data['weeklyFixedCost'] ?? 0.0;

          // Debug prints for verification
          print('Fetching weekly fixed costs:');
          print('truckPayment: $truckPayment');
          print('truckInsurance: $truckInsurance');
          print('trailerLease: $trailerLease');
          print('eldService: $eldService');
          print('overheadCost: $overheadCost');
          print('otherCost: $otherCost');
          print('weeklyFixedCost: $weeklyFixedCost');

          return {
            'truckPayment': truckPayment,
            'truckInsurance': truckInsurance,
            'trailerLease': trailerLease,
            'eldService': eldService,
            'overheadCost': overheadCost,
            'otherCost': otherCost,
            'weeklyFixedCost': weeklyFixedCost,
          };
        } else {
          print('No document found in Firestore for WeeklyFixedCost');
        }
      } catch (e) {
        print('Error fetching values from Firestore: $e');
      }
    } else {
      print('No user signed in');
    }

    // Return an empty map or default values in case of error or no data found
    return {
      'truckPayment': 0.0,
      'truckInsurance': 0.0,
      'trailerLease': 0.0,
      'eldService': 0.0,
      'overheadCost': 0.0,
      'otherCost': 0.0,
      'weeklyFixedCost': 0.0,
    };
  }

  Future<void> storeCalculatedValues({
    required double totalFactoringFee,
    required double totalFreightCharges,
    required double totalDispatchedMiles,
    required double totalMileageCost,
    required double totalProfit,
    required List<String> freightChargeControllers,
    required List<String> dispatchedMilesControllers,
    required List<String> estimatedTollsControllers,
    required List<String> otherCostsControllers,
  }) async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        String loadsId = DateTime.now().millisecondsSinceEpoch.toString();
        DocumentReference newValuesDocRef = firestore
            .collection('users')
            .doc(user.uid)
            .collection('calculatedValues')
            .doc(loadsId);

        await newValuesDocRef.set({
          'totalFactoringFee': totalFactoringFee,
          'totalFreightCharges': totalFreightCharges,
          'totalDispatchedMiles': totalDispatchedMiles,
          'totalMileageCost': totalMileageCost,
          'totalProfit': totalProfit,
          'timestamp': FieldValue.serverTimestamp(),
          'updateTime': DateTime.now(),
          'loads': List.generate(freightChargeControllers.length, (index) {
            return {
              'freightCharge':
                  double.tryParse(freightChargeControllers[index]) ?? 0.0,
              'dispatchedMiles':
                  double.tryParse(dispatchedMilesControllers[index]) ?? 0.0,
              'estimatedTolls':
                  double.tryParse(estimatedTollsControllers[index]) ?? 0.0,
              'otherCosts':
                  double.tryParse(otherCostsControllers[index]) ?? 0.0,
            };
          }),
        });

        print('Loads values stored successfully in Firestore');
      } catch (e) {
        print('Error storing values in Firestore: $e');
      }
    } else {
      print('No user signed in');
    }
  }

//delete the  load method
  Future<void> deleteLoad({
    required String documentId,
    required int loadIndex,
    required BuildContext context,
    required List<TextEditingController> freightChargeControllers,
    required List<TextEditingController> dispatchedMilesControllers,
    required List<TextEditingController> estimatedTollsControllers,
    required List<TextEditingController> otherCostsControllers,
    required String userId,
  }) async {
    try {
      DocumentSnapshot documentSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('calculatedValues')
          .doc(documentId)
          .get();

      if (documentSnapshot.exists) {
        List<dynamic> loads = documentSnapshot['loads'];
        loads.removeAt(loadIndex);

        await firestore
            .collection('users')
            .doc(userId)
            .collection('calculatedValues')
            .doc(documentId)
            .update({'loads': loads});

        freightChargeControllers.removeAt(loadIndex);
        dispatchedMilesControllers.removeAt(loadIndex);
        estimatedTollsControllers.removeAt(loadIndex);
        otherCostsControllers.removeAt(loadIndex);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Load deleted successfully')),
        );
      }
    } catch (e) {
      print('Error deleting load: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting load: $e')),
      );
    }
  }

  Future<void> updateEntry({
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser?.uid)
          .collection('calculatedValues')
          .doc(documentId)
          .update(data);
    } catch (e) {
      print('Error updating entry: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchEntryForEditing(String documentId) async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await firestore
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

// Firebase Method for Fetching all entries from firebase
  Future<List<Map<String, dynamic>>> fetchAllEntriesForEditing() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await firestore
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
    } else {
      print('No user signed in');
    }
    return [];
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
      final QuerySnapshot querySnapshot = await FirebaseServices()
          .firestore
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
}
