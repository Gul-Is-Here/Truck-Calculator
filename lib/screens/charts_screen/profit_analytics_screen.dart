import 'package:dispatched_calculator_app/model/profit_bar_chart_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../app_classes/app_class.dart';
import '../../constants/colors.dart';
import '../../constants/fonts_strings.dart';
import '../../controllers/bar_chart_controller.dart';

class CombinedAnalyticsScreen extends StatelessWidget {
  final BarChartController barChartController = Get.put(BarChartController());

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
            Obx(() {
              if (barChartController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (barChartController.barData.isEmpty) {
                return const Center(child: Text('No Data'));
              } else {
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
                                            element.label.hashCode ==
                                            value.toInt(),
                                        orElse: () => BarData(
                                            label: 'Unknown',
                                            value: 0,
                                            value2: 0))
                                    .label;
                                return SideTitleWidget(
                                  axisSide: AxisSide.bottom,
                                  space: 10,
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
                                    style: const TextStyle(
                                        fontFamily: robotoRegular),
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
            }),
            20.heightBox,
            Obx(() {
              if (barChartController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (barChartController.lineChart.isEmpty) {
                return const Center(child: Text('No Data'));
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
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
                              getTitlesWidget: (value,meta) {
      final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
      return Text('${date.day}/${date.month}'.toString());
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
                        maxX: (barChartController.lineChart.length - 1)
                            .toDouble(),
                        minY: 0,
                        maxY: barChartController.lineChart
                                .map((data) => data.value2)
                                .reduce((a, b) => a! > b! ? a : b)! +
                            10,
                        lineBarsData: [
                          LineChartBarData(
                            spots: barChartController.lineChart
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              BarData data = entry.value;
                              return FlSpot(index.toDouble(), data.value2!);
                            }).toList(),
                            isCurved: true,
                            gradient: LinearGradient(
                              colors: [
                                AppColor().primaryAppColor,
                                AppColor().secondaryAppColor,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
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
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: AppColor().primaryAppColor,
                                  strokeWidth: 2,
                                  strokeColor: AppColor().secondaryAppColor,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
