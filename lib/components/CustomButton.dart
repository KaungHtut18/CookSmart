import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.label, this.onPressed});
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color.fromRGBO(238, 90, 37, 1),
          ),
          child: Center(
            child: Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Colors.white
            ),),
          ),
        ),
      ),
    );
  }
}
