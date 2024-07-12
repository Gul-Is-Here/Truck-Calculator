// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../services/firebase_bar_chart_services.dart';
// import '../model/line_graph_model.dart';

// class LineGraphController extends GetxController {
//   var lineData = <LineData>[].obs;
//   var selectedDateRange = Rx<DateTimeRange?>(null);
//   var isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     (); // Ensure this is called appropriately
//   }

//   Future<void> fetchLineData({DateTime? startDate, DateTime? endDate}) async {
//     isLoading.value = true;

//     try {
//       final List<Map<String, dynamic>> rawData =
//           await FirebaseBarChartServices()
//               .fetchBarData(startDate: startDate, endDate: endDate);

//       lineData
//           .assignAll(rawData.map((data) => LineData.fromMap(data)).toList());

//       print('Line data length: ${lineData.length}');
//     } catch (e) {
//       print('Error fetching line data: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void setSelectedDateRange(DateTimeRange? range) {
//     selectedDateRange.value = range;
//     if (range != null) {
//       fetchLineData(startDate: range.start, endDate: range.end);
//     } else {
//       fetchLineData();
//     }
//   }
// }
