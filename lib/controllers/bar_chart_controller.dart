import 'package:dispatched_calculator_app/model/line_graph_model.dart';
import 'package:dispatched_calculator_app/services/firebase_bar_chart_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/profit_bar_chart_model.dart';
import '../screens/charts_screen/barchart_screen.dart';

class BarChartController extends GetxController {
  var barData = <BarData>[].obs;

  var selectedDateRange = Rx<DateTimeRange?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBarData();
  }

  Future<void> fetchBarData({DateTime? startDate, DateTime? endDate}) async {
    isLoading.value = true;

    try {
      final List<Map<String, dynamic>> rawData =
          await FirebaseBarChartServices()
              .fetchBarData(startDate: startDate, endDate: endDate);
      barData.clear();

      for (var data in rawData) {
        if (data.containsKey('calculatedValues')) {
          List<dynamic> calculatedValues =
              data['calculatedValues'] as List<dynamic>;

          double totalProfit = 0.0;
          double totalDispatchedMiles = 0.0;
          for (var value in calculatedValues) {
            if (value is Map<String, dynamic> &&
                value.containsKey('totalProfit')) {
              totalProfit += value['totalProfit'];
            } else {
              print('Invalid entry or missing totalProfit in: $value');
            }
          }
          for (var value in calculatedValues) {
            if (value is Map<String, dynamic> &&
                value.containsKey('totalDispatchedMiles')) {
              totalDispatchedMiles += value['totalDispatchedMiles'];
            } else {
              print('Invalid entry or missing totalDispatchedMiles in: $value');
            }
          }

          String timestamp = data.containsKey('transferTimestamp')
              ? data['transferTimestamp']
              : 'Unknown Date';
          String timestamp2 = data.containsKey('transferTimestamp')
              ? data['transferTimestamp']
              : 'Unknown Date';
          timestamp = timestamp2;
          print('timestamp $timestamp');
          barData.add(BarData(
            value2: 0,
            label: timestamp,
            value: totalProfit,
          ));
          print('timestamp2 $timestamp2');
        } else {
          print('Missing calculatedValues in: $data');
          // print(lineChart);
        }
      }

      print('Bar data length: ${barData.length}');
      // print('Bar line length: ${lineChart.length}');
    } catch (e) {
      print('Error fetching history data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedDateRange(DateTimeRange? range) {
    selectedDateRange.value = range;
    if (range != null) {
      fetchBarData(startDate: range.start, endDate: range.end);
    } else {
      fetchBarData();
    }
  }
}
