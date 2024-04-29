import 'package:flutter/material.dart';
import 'package:cookbook/constant/image.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Image.asset(onBoardingImage1),
          ),
          const Padding(
            padding:EdgeInsets.only(bottom: 24),
            child: Text(
              'Cooking techniques',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20
              ),
            ),
          ),
          const Text('Master basic cooking techniques which can then be used to create an endless variety of dishes.',
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
