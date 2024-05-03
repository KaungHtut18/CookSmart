// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:cookbook/auth/firebaseFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try{
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in with the credential
      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Save user information to Firestore
      await FirestoreServices.saveUser(
        userCredential.user!.displayName ?? "",
        userCredential.user!.email ?? "",
        userCredential.user!.uid,
      );

      // Once signed in, return the UserCredential
      return userCredential;
    }
    catch (e){
      // Handle other types of exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    }
    return null;
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password, String name, BuildContext context) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //save to firebase
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      // ignore: deprecated_member_use
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      //save user information
      await FirestoreServices.saveUser(name, email, cred.user!.uid);

      return cred.user;
    } on FirebaseAuthException catch (e) {
      //if email is aldy registered
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'This email is already registered! Try again with another email.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found with this email.')),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect password. Please try again.')),
        );
      }
      // rethrow the exception if it's not one of the handled cases
      throw e;
    } catch (e) {
      // Handle other types of exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    }
    return null;
  }

  Future<void> signout() async {
    try {
      //logout
      await _auth.signOut();
    } catch (e) {
      log('Something went wrong!');
    }
  }
}
