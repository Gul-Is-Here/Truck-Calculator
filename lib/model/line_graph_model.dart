import '../app_classes/app_class.dart';

class MyLineChart {
  late final String label2;
  final double? value2;

  MyLineChart({
    required this.value2,
    required this.label2,
  });

  factory MyLineChart.fromMap(Map<String, dynamic> map) {
    return MyLineChart(
      value2: map['totalDispatchedMiles'].toDouble(),
      label2: AppClass().formatDateSpecific(map['transferTimestamp'].toDate()),
    );
  }
}
