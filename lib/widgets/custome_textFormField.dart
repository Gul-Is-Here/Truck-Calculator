import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

Widget buildTextFormField({
  required TextEditingController controller,
  required String label,
  required String hint,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        5.heightBox,
        SizedBox(
          height: 40,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              hintText: hint,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.deepPurple,
                  width: 2,
                ),
              ),
            ),
            validator: validator,
          ),
        ),
        20.heightBox,
      ],
    ),
  );
}
