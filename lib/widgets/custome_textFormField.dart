import 'package:flutter/material.dart';

Widget buildTextFormField({
  required TextEditingController controller,
  required String label,
  required String hint,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 40,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              hintText: hint,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.deepPurple,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: validator, // Validation added here
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}
