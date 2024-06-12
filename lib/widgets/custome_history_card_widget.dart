import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/fonts_strings.dart';

class CustomeHistoryCardWidget extends StatelessWidget {
  final String textHeading;
  final String values;
  const CustomeHistoryCardWidget(
      {super.key, required this.textHeading, required this.values});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            textHeading,
            style: TextStyle(
              fontFamily: robotoRegular,
              fontSize: 14,
            ),
          ),
          10.widthBox,
          Text(
            '\$$values',
            style: TextStyle(
              fontFamily: robotoRegular,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
