import 'package:flutter/material.dart';
import 'package:cookbook/constant/image.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Image.asset(onBoardingImage2),
          ),
          const Padding(
            padding:EdgeInsets.only(bottom: 24),
            child: Text(
              'Choose your favorite dishes',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20
              ),
            ),
          ),
          const Text('Satisfy your appetite with the food you want and and savor every delicious bite with a hearty homemade meal.',
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