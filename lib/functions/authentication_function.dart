// ignore_for_file: use_build_context_synchronously

import 'package:attendance_management_system/user_pannel/bottom_bar/bottom_bar.dart';
import 'package:attendance_management_system/widgets/custom_toast_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../admin_panel/home/admin_home_screen.dart';
import '../get_started/get_started_screen.dart';

//! Creating a function to sign in the user
Future<void> signInUser(
    BuildContext context, String email, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      String currentRole = prefs.getString('CurrentRole') ?? '';
      toastMessage(context, 'Sign in successfully!');
      if (currentRole == 'Admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminHomeScreen(),
          ),
        ).onError((error, stackTrace) {
          toastMessage(context, error.toString());
        });
      } else if (currentRole == 'Student') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserBottomBar(),
          ),
        );
      }
    }).onError((error, stackTrace) {
      toastMessage(context, error.toString());
    });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      toastMessage(context, 'No user found for that email.');
    } else if (e.code == 'wrong-password') {
      toastMessage(context, 'Wrong password provided for that user.');
    }
  }
}

//! Creating a function to sign up the user
Future<UserCredential?> signupUser(
  BuildContext context,
  TextEditingController emailController,
  TextEditingController passwordController,
) async {
  try {
    if (emailController.text.isNotEmpty || passwordController.text.isNotEmpty) {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      return userCredential;
    } else {
      toastMessage(context, 'Please fill all the fields');
      return null;
    }
  } catch (e) {
    toastMessage(context, e.toString());
  }
  return null;
}

//! Creating a function to sign out the user
Future<void> signOutUser(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    await FirebaseAuth.instance.signOut().then((value) {
      prefs.remove('CurrentRole');
      toastMessage(context, 'Sign out successfully!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GetStartedScreen(),
        ),
      ).onError((error, stackTrace) {
        toastMessage(context, error.toString());
      });
    });
  } catch (e) {
    toastMessage(context, e.toString());
  }
}
