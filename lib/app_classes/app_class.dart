import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
 void showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    ).then((exit) {
      if (exit == true) {
        // If the user presses 'Yes', close the app
        Navigator.of(context).maybePop();
      }
    });
  }
  
}
