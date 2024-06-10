import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {
  final String title;
  final String value;
   ResultWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: robotoRegular),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 18, fontFamily: robotoRegular),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
