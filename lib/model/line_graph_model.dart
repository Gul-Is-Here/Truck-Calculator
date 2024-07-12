import '../app_classes/app_class.dart'; // Assuming this contains formatDateSpecific method

class LineData {
  final String label2;
  final double value2;

  LineData({required this.label2, required this.value2});

  factory LineData.fromMap(Map<String, dynamic> map) {
    return LineData(
      label2: AppClass().formatDateSpecific(map['transferTimestamp'].toDate()),
      value2: map['totalDispatchedMiles'].toDouble(),
    );
  }
}
