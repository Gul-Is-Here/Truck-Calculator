import 'package:intl/intl.dart';
class AppClass {
  // Greeting Method
  String getGreeting() {
    final hour = DateTime.now().hour;
    print(hour);
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
