import 'package:dispatched_calculator_app/constants/colors.dart';
import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custome_textFormField.dart';

Widget buildRowWithLabel({
   bool? isEnable,
  required String label,
  required String hint,
  required TextEditingController controller,
  required RxDouble value,
  String? Function(String?)? validator,
}) {
  return Row(
    crossAxisAlignment:
        CrossAxisAlignment.start, // Align start to keep consistent height
    children: [
      Expanded(
        flex: 3,
        child: buildTextFormField(
          controller: controller,
          label: label,
          hint: hint,
          validator: validator,
          isEnable: isEnable
        ),
      ),
      const SizedBox(
          width: 10), // Adjust spacing between TextFormField and Container
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Container(
            width: 70,
            height: 50, // Ensure the height matches the TextFormField's height
            decoration: BoxDecoration(
              color: AppColor().secondaryAppColor.withOpacity(.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Obx(() => Text(
                    '\$${value.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: robotoRegular,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ),
        ),
      ),
    ],
  );
}
