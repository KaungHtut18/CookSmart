import 'package:cookbook/auth/togglePages.dart';
import 'package:cookbook/screens/bottomNav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        //for persistance logic to handle that users to keep log in
        //this return User nullable whether user is log in or signout if signout -> it'll retrun null
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if data is not fetched or some other connection error
          //we will show circularprogressindicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
            //if something went wrong, we will show error message
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error!'),
            );
            //if everything is working well we will check, user is signout or not
          } else {
            //this is null so user is already sign out
            //we will navigate to login screen
            if (snapshot.data == null) {
              return const TogglePages();
            }
            //not null that means user already log in so
            //we'll let user to keep log in
            else {
              return const BottomNav();
            }
          }
        },
      ),
    );
  }
}
