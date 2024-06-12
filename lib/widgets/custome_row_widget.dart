import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/fonts_strings.dart';

class CustomeRowWidget extends StatelessWidget {
  final String textHeading;
  final String values;
  const CustomeRowWidget(
      {super.key, required this.textHeading, required this.values});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          textHeading,
          style: TextStyle(
            fontFamily: robotoRegular,
            fontSize: 16,
          ),
        ),
        10.widthBox,
        Text(
          '\$$values',
          style: TextStyle(
            fontFamily: robotoRegular,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
