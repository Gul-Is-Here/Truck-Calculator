import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CardWidget extends StatelessWidget {
  final String butonText;
  final String cardText;
  final void Function() onTap;
  const CardWidget(
      {super.key,
      required this.butonText,
      required this.cardText,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .18,
        width: MediaQuery.of(context).size.width * .8,
        child: Column(
          children: [
            10.heightBox,
            TextButton(
              onPressed: onTap,
              child: Text(
                butonText,
                style: TextStyle(fontSize: 24, fontFamily: robotoRegular),
              ),
            ),
            10.heightBox,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.center,
                cardText,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
