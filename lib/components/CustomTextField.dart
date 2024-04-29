import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hint,
      required this.label,
      this.controller,
      this.isPassword = false,
      this.validate,
      this.onSaved});
  final String hint;
  final String label;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextFormField(
        onSaved: onSaved,
        validator: validate,
        cursorColor: Colors.grey[600],
        obscureText: isPassword,
        controller: controller,
        decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            label: Text(label),
            labelStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white,)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Color.fromARGB(255, 193, 192, 192))
            ),
          ),
      ),
    );
  }
}