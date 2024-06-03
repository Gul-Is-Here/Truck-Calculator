import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custome_textFormField.dart';

Widget buildRowWithLabel({
  required String label,
  required String hint,
  required TextEditingController controller,
  required RxDouble value,
  String? Function(String?)? validator,
}) {
  return Row(
    children: [
      Expanded(
        flex: 3,
        child: buildTextFormField(
          controller: controller,
          label: label,
          hint: hint,
          validator: validator,
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Obx(() => Text(
                    '\$${value.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  )),
            ),
          ),
        ),
      ),
    ],
  );
}
