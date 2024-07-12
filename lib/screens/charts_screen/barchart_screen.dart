// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dispatched_calculator_app/app_classes/app_class.dart';
// import 'package:dispatched_calculator_app/services/firebase_services.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// Future<List<BarData>> fetchBarData(
//     {DateTime? startDate, DateTime? endDate}) async {
//   User? user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     throw Exception('User not logged in');
//   }

//   List<BarData> data = [];
//   QuerySnapshot snapshot;

//   try {
//     if (startDate != null && endDate != null) {
//       print("Fetching data between $startDate and $endDate");
//       snapshot = await FirebaseServices()
//           .firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('history')
//           .where('transferTimestamp', isGreaterThanOrEqualTo: startDate)
//           .where('transferTimestamp', isLessThanOrEqualTo: endDate)
//           .get();
//     } else {
//       print("Fetching most recent 4 data points");
//       snapshot = await FirebaseServices()
//           .firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('history')
//           .orderBy('transferTimestamp', descending: true)
//           .limit(4)
//           .get();
//     }

//     for (var doc in snapshot.docs) {
//       List<dynamic> calculatedValues = doc['calculatedValues'];
//       for (var dataItem in calculatedValues) {
//         BarData barData = BarData.fromMap(dataItem);
//         print("Fetched data: ${barData.label}, ${barData.value}");
//         data.add(barData);
//       }
//     }
//   } catch (e) {
//     print("Error fetching data: $e");
//     throw e;
//   }

//   return data;
// }


