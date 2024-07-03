import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/load_screen/load_screen.dart';

class FirebaseServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String docId = '';

  Future<void> storeTruckMonthlyPayments({
    required bool isEditableTruckPayment,
    required double tWeeklyTruckPayment,
    required double tWeeklyInsurance,
    required double tWeeklyTrailerLease,
    required double tWeeklyEldService,
    // required double tWeeklyOverheadAmount,
    // required double tWeeklyOtherCost,
    required double weeklyTruckPayment,
    required double weeklyTrailerLease,
    required double weeklyEldService,
    required double weeklyInsurance,
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
          'isEditableTruckPayment': isEditableTruckPayment,
          'monthlyTruckPayment': tWeeklyTruckPayment,
          'monthlyTruckInsurance': tWeeklyInsurance,
          'monthlyTrailerLease': tWeeklyTrailerLease,
          'monthlyEldService': tWeeklyEldService,
          'monthlyOverheadCost': weeklyOverheadAmount,
          'weeklyFixedCost': weeklyFixedCost,
          'monthlyOtherCost': weeklyOtherCost,
          'weeklyTruckPayment': weeklyTruckPayment,
          'weeklyInsurancePayment': weeklyInsurance,
          'weeklyTrailerLease': weeklyTrailerLease,
          'weeklyEldService': weeklyEldService,
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
    required bool isEditabbleMilage,
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
            'isEditabbleMilage': isEditabbleMilage,
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
            'isEditabbleMilage': isEditabbleMilage,
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

  Future<Map<String, double>> fetchPerMileageAmount() async {
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
            'milageFeePerMile': perMileFee,
            'fuelFeePerMile': perMileFuel,
            'defFeePerMile': perMileDef,
            'driverPayFeePerMile': perMileDriverPay,
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
      'milageFeePerMile': 0.0,
      'fuelFeePerMile': 0.0,
      'defFeePerMile': 0.0,
      'driverPayFeePerMile': 0.0,
    };
  }

  Future<void> toggleIsEditabbleMilage() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await firestore
            .collection('users')
            .doc(user.uid)
            .collection('perMileageCost')
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot doc = querySnapshot.docs.first;
          bool currentIsEditableMileage = doc['isEditabbleMilage'];

          await doc.reference.update({
            'isEditabbleMilage': !currentIsEditableMileage,
          });
         
          print(
              'isEditableMileage updated successfully: ${!currentIsEditableMileage}');
        } else {
          print('No document found for perMileageCost');
        }
      } catch (e) {
        print('Error toggling isEditableMileage: $e');
      }
    } else {
      print('No user signed in');
    }
  }

  Future<bool> fetchIsEditabbleMilage() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await firestore
            .collection('users')
            .doc(user.uid)
            .collection('perMileageCost')
            .limit(1)
            .get();

        if (querySnapshot.docs.isEmpty) {
          await firestore
              .collection('users')
              .doc(user.uid)
              .collection('perMileageCost')
              .doc()
              .set({'isEditabbleMilage': false});

          print(
              'No document found, created new document with default isEditableMileage: false');
          return false;
        }

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot doc = querySnapshot.docs.first;
          bool isEditableMileage = doc['isEditabbleMilage'];

          print('Fetched isEditableMileage: $isEditableMileage');
          return isEditableMileage;
        } else {
          print('No document found for perMileageCost');
          return false;
        }
      } catch (e) {
        print('Error fetching isEditableMileage: $e');
        return false;
      }
    } else {
      print('No user signed in');
      return false;
    }
  }

  //------------------------ Truck is Edit able

  Future<void> toggleIsEditabbleTruckPayment() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        // Fetch current value of isEditabbleMilage
        QuerySnapshot querySnapshot = await firestore
            .collection('users')
            .doc(user.uid)
            .collection('truckPaymentCollection')
            .limit(1) // Limit to 1 document
            .get();

        // Check if there is an existing document
        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot doc = querySnapshot.docs.first;
          bool currentIsEditableTruckPayment = doc['isEditableTruckPayment'];

          // Toggle the value
          bool updateisEditableTruckPayment = !currentIsEditableTruckPayment;

          // Update Firestore with the new value
          await doc.reference.update({
            'isEditableTruckPayment': updateisEditableTruckPayment,
          });

          print(
              'isEditabbleMilage updated successfully: $updateisEditableTruckPayment');
        } else {
          print('No document found for truckPaymentCollection');
        }
      } catch (e) {
        print('Error toggling isEditabbleMilage: $e');
      }
    } else {
      print('No user signed in');
    }
  }

  Future<bool> fetchIsEditabbleTruckPayment() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        // Fetch the document containing perMileageCost
        QuerySnapshot querySnapshot = await firestore
            .collection('users')
            .doc(user.uid)
            .collection('truckPaymentCollection')
            .limit(1) // Limit to 1 document
            .get();
        if (querySnapshot.docs.isEmpty) {
          await firestore
              .collection('users')
              .doc(user.uid)
              .collection('truckPaymentCollection')
              .doc()
              .set({'isEditableTruckPayment': false});

          print(
              'No document found, created new document with default isEditableMileage: false');
          return false;
        }
        // Check if there is an existing document
        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot doc = querySnapshot.docs.first;
          bool isEditableTruckPayment = doc['isEditableTruckPayment'];

          print('Fetched isEditableTruckPayment: $isEditableTruckPayment');
          return isEditableTruckPayment;
        } else {
          print('No document found for TruckPayment');
          return false; // Default to false if document doesn't exist
        }
      } catch (e) {
        print('Error fetching isEditableTruckPayment: $e');
        return false; // Default to false on error
      }
    } else {
      print('No user signed in');
      return false; // Default to false if no user is signed in
    }
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

          double truckPayment = data['monthlyTruckPayment'] ?? 0.0;
          double truckInsurance = data['monthlyTruckInsurance'] ?? 0.0;
          double trailerLease = data['monthlyTrailerLease'] ?? 0.0;
          double eldService = data['monthlyEldService'] ?? 0.0;
          double overheadCost = data['monthlyOverheadCost'] ?? 0.0;
          double otherCost = data['monthlyOtherCost'] ?? 0.0;
          double weeklyFixedCost = data['weeklyFixedCost'] ?? 0.0;
          double weeklyTruckPayment = data['weeklyTruckPayment'] ?? 0.0;
          double weeklyTrailerLease = data['weeklyTrailerLease'] ?? 0.0;
          double weeklyInsurancePayment = data['weeklyInsurancePayment'] ?? 0.0;
          double weeklyEldService = data['weeklyEldService'] ?? 0.0;

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
            'monthlyTruckPayment': truckPayment,
            'monthlyTruckInsurance': truckInsurance,
            'monthlyTrailerLease': trailerLease,
            'monthlyEldService': eldService,
            'monthlyOverheadCost': overheadCost,
            'monthlyOtherCost': otherCost,
            'weeklyFixedCost': weeklyFixedCost,
            'weeklyTruckPayment': weeklyTruckPayment,
            'weeklyTrailerLease': weeklyTrailerLease,
            'weeklyInsurancePayment': weeklyInsurancePayment,
            'weeklyEldService': weeklyEldService,
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
      'monthlyTruckPayment': 0.0,
      'monthlyTruckInsurance': 0.0,
      'monthlyTrailerLease': 0.0,
      'monthlyEldService': 0.0,
      'monthlyOverheadCost': 0.0,
      'monthlyOtherCost': 0.0,
      'weeklyFixedCost': 0.0,
      'weeklyTruckPayment': 0.0,
      'weeklyTrailerLease': 0.0,
      'weeklyInsurancePayment': 0.0,
      'weeklyEldService': 0.0
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
    required BuildContext context, // Add context for navigation
    required HomeController homeController, // Add controller for navigation
  }) async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        bool documentExists = await checkIfCalculatedValuesDocumentExists();

        if (documentExists) {
          // Document exists, navigate to the update screen
          QuerySnapshot existingDocsSnapshot = await firestore
              .collection('users')
              .doc(user.uid)
              .collection('calculatedValues')
              .limit(1)
              .get();
          String existingDocId = existingDocsSnapshot.docs.first.id;
          var loadData =
              await FirebaseServices().fetchEntryForEditing(existingDocId);

          Get.to(
            () => LoadScreen(
              isUpdate: true,
              documentId: existingDocId,
              homeController: homeController,
              loadData: loadData,
            ),
          );
        } else {
          // No document exists, create a new one
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
        }
      } catch (e) {
        print('Error storing values in Firestore: $e');
      }
    } else {
      print('No user signed in');
    }
  }

  Future<bool> checkIfCalculatedValuesDocumentExists() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        // Check if a document already exists
        QuerySnapshot existingDocsSnapshot = await firestore
            .collection('users')
            .doc(user.uid)
            .collection('calculatedValues')
            .limit(1) // Limit to 1 for efficiency
            .get();

        return existingDocsSnapshot.docs.isNotEmpty;
      } catch (e) {
        print('Error checking if document exists: $e');
        return false;
      }
    } else {
      print('No user signed in');
      return false;
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
          const SnackBar(content: Text('Load deleted successfully')),
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

  // Future<void> transferAndDeleteWeeklyData() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;

  //   if (user != null) {
  //     try {
  //       // Get a reference to the user's document
  //       DocumentReference userDocRef =
  //           firestore.collection('users').doc(user.uid);

  //       // Calculate the start and end dates of the current week
  //       DateTime now = DateTime.now();
  //       DateTime startOfWeek =
  //           DateTime(now.year, now.month, now.day - now.weekday);
  //       DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
  //       print('Current date time : $now');
  //       print('Start of the week : $startOfWeek');
  //       print('End of the week : $endOfWeek');

  //       // Query documents in the calculatedValues subcollection within the current week
  //       QuerySnapshot querySnapshot = await userDocRef
  //           .collection('calculatedValues')
  //           .where('timestamp',
  //               isGreaterThanOrEqualTo: startOfWeek,
  //               isLessThanOrEqualTo: endOfWeek)
  //           .get();

  //       // Transfer each document to the history subcollection and delete from calculatedValues
  //       for (QueryDocumentSnapshot doc in querySnapshot.docs) {
  //         try {
  //           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  //           // Set a new document in the history collection with a unique ID
  //           await userDocRef.collection('history').doc(doc.id).set(data);

  //           // Delete the document from the calculatedValues collection
  //           await userDocRef
  //               .collection('calculatedValues')
  //               .doc(doc.id)
  //               .delete();

  //           print(
  //               'Document transferred to history and original document deleted successfully.');
  //         } catch (e) {
  //           print('Error processing document with ID ${doc.id}: $e');
  //         }
  //       }

  //       print('Weekly data transfer and deletion completed.');
  //     } catch (e) {
  //       print(
  //           'Error transferring data to history and deleting original documents: $e');
  //     }
  //   } else {
  //     print('No user signed in');
  //   }
  // }

  Future<void> transferAndDeleteWeeklyData() async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (user != null) {
      try {
        // Get a reference to the user's document
        DocumentReference userDocRef =
            firestore.collection('users').doc(user.uid);

        // Calculate the start and end dates of the current week
        DateTime now = DateTime.now();
        DateTime startOfWeek =
            DateTime(now.year, now.month, now.day - now.weekday);
        DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
        print('Current date time : $now');
        print('Start of the week : $startOfWeek');
        print('End of the week : $endOfWeek');

        // Query documents in the calculatedValues subcollection within the current week
        QuerySnapshot calculatedValuesSnapshot = await userDocRef
            .collection('calculatedValues')
            .where('timestamp',
                isGreaterThanOrEqualTo: startOfWeek,
                isLessThanOrEqualTo: endOfWeek)
            .get();

        // Query the mileage fee collection
        QuerySnapshot mileageFeeSnapshot =
            await userDocRef.collection('perMileageCost').get();

        // Query the truck payment collection
        QuerySnapshot truckPaymentSnapshot =
            await userDocRef.collection('truckPaymentCollection').get();

        // Prepare data to be transferred
        Map<String, dynamic> combinedData = {
          'calculatedValues': [],
          'mileageFee': [],
          'truckPayment': []
        };

        // Add calculated values data
        for (QueryDocumentSnapshot doc in calculatedValuesSnapshot.docs) {
          combinedData['calculatedValues'].add(doc.data());
          // Delete the document from the calculatedValues collection
          await doc.reference.delete();
        }

        // Add mileage fee data without deleting
        for (QueryDocumentSnapshot doc in mileageFeeSnapshot.docs) {
          combinedData['mileageFee'].add(doc.data());
        }

        // Add truck payment data without deleting
        for (QueryDocumentSnapshot doc in truckPaymentSnapshot.docs) {
          combinedData['truckPayment'].add(doc.data());
        }

        // Set a new document in the history collection with a unique ID
        String historyDocId =
            firestore.collection('users').doc().id; // Generate a unique ID
        DocumentReference newHistoryDoc =
            userDocRef.collection('history').doc(historyDocId);
        await newHistoryDoc.set(combinedData);

        print('Weekly data transfer completed.');
      } catch (e) {
        print('Error transferring data to history: $e');
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
