import '../app_classes/app_class.dart'; // Assuming this contains formatDateSpecific method

class FreightPricePoint {
  final String label3;
  final double value3;
  FreightPricePoint({required this.label3, required this.value3});

  factory FreightPricePoint.fromMap(Map<String, dynamic> map) {
    return FreightPricePoint(
      label3: AppClass().formatDateSpecific(map['transferTimestamp'].toDate()),
      value3: map['totalDispatchedMiles'].toDouble(),
    );
  }
}
