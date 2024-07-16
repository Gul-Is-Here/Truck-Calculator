import 'package:dispatched_calculator_app/app_classes/app_class.dart';

class MyLineChart2 {
  final String date;
  final double value2;
  MyLineChart2(this.date, this.value2);
  factory MyLineChart2.fromMap(Map<String, dynamic> map) {
    return MyLineChart2(
      AppClass().formatDateSpecific(map['transferTimestamp']),
      map['totalDispatchedMiles'].toDouble(),
    );
  }
}
 