import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_classes/app_class.dart';
import '../../constants/colors.dart';
import '../../constants/fonts_strings.dart';
import '../../controllers/bar_chart_controller.dart';

class BarChartScreen extends StatelessWidget {
  final BarChartController controller = Get.put(BarChartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () => AppClass().selectDateRange(context),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => controller.setSelectedDateRange(null),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.barData.isEmpty) {
          return Center(child: Text('No Data'));
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .4,
                    width: MediaQuery.of(context).size.width * 1,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: controller.barData
                                .map((data) => data.value)
                                .reduce((a, b) => a > b ? a : b) +
                            10,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '',
                                const TextStyle(
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: rod.toY.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: rod.toY > 0
                                          ? Colors.white
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                String label = controller.barData
                                    .firstWhere((element) =>
                                        element.label.hashCode == value.toInt())
                                    .label;
                                return SideTitleWidget(
                                  fitInside: const SideTitleFitInsideData(
                                      axisPosition: 0,
                                      distanceFromEdge: 10.0,
                                      enabled: true,
                                      parentAxisSize: 10.0),
                                  axisSide: AxisSide.left,
                                  space: 8.0,
                                  child: Text(label,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontFamily: robotoRegular)),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            drawBelowEverything: true,
                            sideTitles: SideTitles(
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toStringAsFixed(0),
                                    style: TextStyle(fontFamily: robotoRegular),
                                  );
                                },
                                showTitles: true,
                                interval: 2000,
                                reservedSize: 40),
                          ),
                        ),
                        borderData: FlBorderData(
                            show: true,
                            border:
                                Border.all(color: AppColor().primaryAppColor)),
                        barGroups: controller.barData.map((data) {
                          return BarChartGroupData(
                            x: data.label.hashCode,
                            barRods: [
                              BarChartRodData(
                                color: data.value > 0
                                    ? AppColor().secondaryAppColor
                                    : Colors.red,
                                toY: data.value,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
