import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cookbook/constant/color.dart';

class StickyTextWidget extends StatelessWidget {
  final String header;
  const StickyTextWidget({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 20),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Divider(
                    indent: 24,
                    endIndent: 10,
                    thickness: 3,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
            Text(
              header,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontSize: 17
                ),
              ),
            ),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Divider(
                    indent: 10,
                    endIndent: 24,
                    thickness: 3,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
