// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:cookbook/auth/firebaseFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> loginWithGoogle() async {
    try {
      //interactive sign in process
      final googleUser = await GoogleSignIn().signIn();
      //obtain auth details
      final googleAuth = await googleUser?.authentication;
      //create a new credential for user
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      //sign in
      final userCredential = await _auth.signInWithCredential(cred);

      if (userCredential != null) {
        final user = userCredential.user;
        if (user != null) {
          // Save user data to Firestore
          await FirestoreServices.saveUser(
              user.displayName ?? '', user.email ?? '', user.uid);
        }
      }

      return userCredential;
    } catch (e) {
      print(e.toString());
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
