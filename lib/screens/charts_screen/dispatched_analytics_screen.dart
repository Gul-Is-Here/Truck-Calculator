// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../app_classes/app_class.dart';
// import '../../constants/colors.dart';
// import '../../constants/fonts_strings.dart';
// import '../../controllers/line_chart_cotroller.dart';
// import '../../model/line_graph_model.dart';

// class LineGraphScreen extends StatelessWidget {
//   final LineGraphController controller = Get.put(LineGraphController());

//   LineGraphScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Line Graph'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.date_range),
//             onPressed: () => AppClass().selectDateRange(context),
//           ),
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () => controller.setSelectedDateRange(null),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         } else if (controller.lineData.isEmpty) {
//           return Center(child: Text('No Data'));
//         } else {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: LineChart(
//                     LineChartData(
//                       gridData: FlGridData(show: true),
//                       titlesData: FlTitlesData(
//                         leftTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             getTitlesWidget: (value, meta) {
//                               return Text(
//                                 value.toStringAsFixed(0),
//                                 style: TextStyle(
//                                   fontFamily: robotoRegular,
//                                 ),
//                               );
//                             },
//                             reservedSize: 40,
//                           ),
//                         ),
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             getTitlesWidget: (value, meta) {
//                               String label = '';
//                               try {
//                                 label = controller.lineData
//                                     .firstWhere((element) =>
//                                         element.label2.hashCode ==
//                                         value.toInt())
//                                     .label2;
//                               } catch (e) {
//                                 label =
//                                     ''; // Provide a default value if not found
//                               }
//                               return Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   label,
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     fontFamily: robotoRegular,
//                                   ),
//                                 ),
//                               );
//                             },
//                             interval: 1,
//                           ),
//                         ),
//                       ),
//                       borderData: FlBorderData(show: true),
//                       minX: 0,
//                       maxX: (controller.lineData.length - 1).toDouble(),
//                       minY: 0,
//                       maxY: controller.lineData
//                               .map((data) => data.value)
//                               .reduce((a, b) => a > b ? a : b) +
//                           10,
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots:
//                               controller.lineData.asMap().entries.map((entry) {
//                             int index = entry.key;
//                             LineData data = entry.value;
//                             return FlSpot(index.toDouble(), data.value);
//                           }).toList(),
//                           isCurved: true,
//                           color: AppColor().secondaryAppColor,
//                           gradient: LinearGradient(
//                             colors: [
//                               AppColor().primaryAppColor,
//                               AppColor().secondaryAppColor,
//                             ],
//                             begin: Alignment.centerLeft,
//                             end: Alignment.centerRight,
//                           ),
//                           barWidth: 4,
//                           belowBarData: BarAreaData(
//                             show: true,
//                             gradient: LinearGradient(
//                               colors: [
//                                 AppColor().primaryAppColor.withOpacity(0.3),
//                                 AppColor().secondaryAppColor.withOpacity(0.3),
//                               ],
//                               begin: Alignment.centerLeft,
//                               end: Alignment.centerRight,
//                             ),
//                           ),
//                           dotData: FlDotData(
//                             show: true,
//                             // dotSize: 6,
//                             // dotColor: AppColor().primaryAppColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//       }),
//     );
//   }
// }
