import 'package:dispatched_calculator_app/controllers/line_chart_cotroller.dart';
import 'package:dispatched_calculator_app/model/line_graph_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../app_classes/app_class.dart';
import '../../constants/colors.dart';
import '../../constants/fonts_strings.dart';
import '../../controllers/bar_chart_controller.dart';
import '../../model/profit_bar_chart_model.dart';

class CombinedAnalyticsScreen extends StatelessWidget {
  final BarChartController barChartController = Get.put(BarChartController());
  final LineCartController lineChartController = Get.put(LineCartController());
  CombinedAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => AppClass().selectDateRange(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              barChartController.setSelectedDateRange(null);
              lineChartController.setSelectedDateRange(null);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.heightBox,
            _buildCharts(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCharts(BuildContext context) {
    return Obx(() {
      if (barChartController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (barChartController.barData.isEmpty ||
          lineChartController.myLineChart.isEmpty) {
        return const Center(child: Text('No Data'));
      } else {
        return Column(
          children: [
            _buildBarChart(context),
            20.heightBox,
            _buildLineChart(context),
          ],
        );
      }
    });
  }

  Widget _buildBarChart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: barChartController.barData
                    .map((data) => data.value)
                    .reduce((a, b) => a! > b! ? a : b)! +
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
                          color: rod.toY > 0 ? Colors.white : Colors.red,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (barChartController.barData.isEmpty) {
                      return const Text('No Data');
                    }
                    String label = barChartController.barData
                        .firstWhere(
                            (element) =>
                                element.label.hashCode == value.toInt(),
                            orElse: () => BarData(
                                  label: 'Unknown',
                                  value: 0,
                                  value2: 0,
                                ))
                        .label;
                    return SideTitleWidget(
                      axisSide: AxisSide.bottom,
                      space: 10,
                      child: Text(label,
                          style: const TextStyle(
                              fontSize: 10, fontFamily: robotoRegular)),
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
                      style: const TextStyle(fontFamily: robotoRegular),
                    );
                  },
                  showTitles: true,
                  interval: 2000,
                  reservedSize: 40,
                ),
              ),
            ),
            borderData: FlBorderData(
                show: true,
                border: Border.all(color: AppColor().primaryAppColor)),
            barGroups: barChartController.barData.map((data) {
              return BarChartGroupData(
                x: data.label.hashCode,
                barRods: [
                  BarChartRodData(
                    color: data.value! > 0
                        ? AppColor().secondaryAppColor
                        : Colors.red,
                    toY: data.value!,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart(BuildContext context) {
    Set<int> printedIndices = {}; // To keep track of printed indices
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (lineChartController.myLineChart.isEmpty) {
                      return const Text('No Data');
                    }
                    int index = value.toInt();
                    if (index >= 0 &&
                        index < lineChartController.myLineChart.length) {
                      String label =
                          lineChartController.myLineChart[index].label2;
                      // Ensure label is only printed once for each unique x value
                      if (printedIndices.contains(index)) {
                        return SideTitleWidget(
                          axisSide: AxisSide.bottom,
                          space: 10,
                          child: Text(
                            label.toString(),
                            style: const TextStyle(
                                fontSize: 10,
                                fontFamily: robotoRegular,
                                color: Colors.black),
                          ),
                        );
                      } else {
                        printedIndices.add(index);
                        // Debug print for labels and values
                        print(
                            'Label: $label, Value: ${lineChartController.myLineChart[index].value2}');
                        return SideTitleWidget(
                          axisSide: AxisSide.bottom,
                          space: 10,
                          child: Text(
                            label.toString(),
                            style: const TextStyle(
                                fontSize: 10,
                                fontFamily: robotoRegular,
                                color: Colors.black),
                          ),
                        );
                      }
                    } else {
                      return const Text('Unknown');
                    }
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                top: BorderSide.none,
                bottom: BorderSide(
                  color: AppColor().primaryAppColor,
                  width: 1,
                ),
                left: BorderSide.none,
                right: BorderSide.none,
              ),
            ),
            minX: 0,
            maxX: (lineChartController.myLineChart.length - 1).toDouble(),
            minY: 0,
            maxY: lineChartController.myLineChart
                    .map((data) => data.value2)
                    .reduce((a, b) => a! > b! ? a : b)! +
                10,
            lineBarsData: [
              LineChartBarData(
                spots: lineChartController.myLineChart
                    .asMap()
                    .entries
                    .map((entry) {
                  int index = entry.key;
                  MyLineChart data = entry.value;
                  return FlSpot(index.toDouble(), data.value2!);
                }).toList(),
                isCurved: true,
                color: AppColor().secondaryAppColor,
                barWidth: 4,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColor().primaryAppColor.withOpacity(0.3),
                      AppColor().secondaryAppColor.withOpacity(0.3),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                    radius: 4,
                    color: AppColor().secondaryAppColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
