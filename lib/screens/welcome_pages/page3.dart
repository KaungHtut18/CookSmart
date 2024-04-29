import 'package:flutter/material.dart';
import 'package:cookbook/constant/image.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Image.asset(onBoardingImage3),
          ),
          const Padding(
            padding:EdgeInsets.only(bottom: 24),
            child: Text(
              'Rise or Shine, it\'s time to dine',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20
              ),
            ),
          ),
          const Text('Regardless of the time of day, mealtime is always a moment of significance and connection.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 16
          ),),
        ],
        ),
    );
  }
}
