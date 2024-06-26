import 'package:cookbook/screens/login.dart';
import 'package:cookbook/screens/signup.dart';
import 'package:flutter/material.dart';

class TogglePages extends StatefulWidget {
  const TogglePages({super.key});

  @override
  State<TogglePages> createState() => _TogglePagesState();
}

class _TogglePagesState extends State<TogglePages> {
  //initially set to true  -> login page
  bool showLoginPage = true;

  //Method to toggle between login and signup pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LogIn(showSignUpPage: togglePages);
    } else {
      return Register(showLoginPage: togglePages);
    }
  }
}
