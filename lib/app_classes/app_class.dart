import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class AppClass {
  final GlobalKey mileageButtonKey = GlobalKey();
  final GlobalKey truckPaymentButtonKey = GlobalKey();
  final GlobalKey calculatorCardKey = GlobalKey();
  // Greeting Method
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

 String formatDateTimeFriendly(DateTime dateTime) {
    final DateFormat formatter = DateFormat('EEEE, MMM d, yyyy h:mm a');
    return formatter.format(dateTime);
  }



}
