import 'package:dispatched_calculator_app/services/firebase_bar_chart_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      final List<Map<String, dynamic>> rawData = await FirebaseBarChartServices().fetchBarData(
          startDate: startDate, endDate: endDate);
      barData.clear();

      for (var data in rawData) {
        if (data.containsKey('calculatedValues')) {
          List<dynamic> calculatedValues = data['calculatedValues'] as List<dynamic>;

          double totalProfit = 0.0;
          for (var value in calculatedValues) {
            if (value is Map<String, dynamic> && value.containsKey('totalProfit')) {
              totalProfit += value['totalProfit'];
            } else {
              print('Invalid entry or missing totalProfit in: $value');
            }
          }

          String timestamp = data.containsKey('transferTimestamp')
              ? data['transferTimestamp']
              : 'Unknown Date';

          barData.add(BarData(label: timestamp, value: totalProfit));
        } else {
          print('Missing calculatedValues in: $data');
        }
      }

      print('Bar data length: ${barData.length}');
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
