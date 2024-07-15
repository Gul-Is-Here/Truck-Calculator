// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:get/get.dart';
// import '../controllers/bar_chart_controller.dart'; // Import your controller
// import '../model/bar_data.dart'; // Import your BarData model

// class LineChartSample2 extends StatelessWidget {
//   final  controller = Get.put(Freig); // Assuming you use GetX for state management

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         } else if (controller.barData.isEmpty) {
//           return Center(child: Text('No Data'));
//         } else {
//           return Stack(
//             children: <Widget>[
//               AspectRatio(
//                 aspectRatio: 1.70,
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     right: 18,
//                     left: 12,
//                     top: 24,
//                     bottom: 12,
//                   ),
//                   child: LineChart(
//                     controller.showAvg ? controller.avgData() : controller.mainData(),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 60,
//                 height: 34,
//                 child: TextButton(
//                   onPressed: () {
//                     controller.toggleShowAvg(); // Toggle average data display
//                   },
//                   child: Text(
//                     'avg',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: controller.showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }
//       }),
//     );
//   }
// }
