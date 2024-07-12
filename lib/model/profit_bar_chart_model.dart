import '../app_classes/app_class.dart';

class BarData {
  final String label;
  final double? value;
  final double? value2;

  BarData(
     { required this.value2,
    required this.label,
    required this.value,
  });

  factory BarData.fromMap(Map<String, dynamic> map) {
    return BarData(
     value2:  map['totalDispatchedMiles'].toDouble(),
      label: AppClass().formatDateSpecific(map['transferTimestamp'].toDate()),
      value: map['totalProfit'].toDouble(),
    );
  }
}
