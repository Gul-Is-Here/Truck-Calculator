// import 'package:get/get.dart';

// import '../services/firebase_bar_chart_services.dart';

// class FreightController extends GetxController {
//   final FirebaseBarChartServices _firebaseBarChartServices = FirebaseBarChartServices();

//   // Existing methods like fetchBarData() and setSelectedDateRange() can remain as they are.

//   Future<void> fetchLineChartData({DateTime? startDate, DateTime? endDate}) async {
//     try {
//       final List<Map<String, dynamic>> rawData = await _firebaseBarChartServices.fetchLineChartData(
//         startDate: startDate,
//         endDate: endDate,
//       );

//       // Process rawData as needed for your line chart data handling
//       // Example:
//       lineChart.clear();
//       for (var data in rawData) {
//         lineChart.add(BarData.fromMap(data));
//       }

//       // Update your line chart data state
//     } catch (e) {
//       print('Error fetching line chart data: $e');
//     }
//   }
// }
