import 'package:attendance_management_system/admin_panel/admin_bottom_bar/admin_bottom_bar_screen.dart';
import 'package:attendance_management_system/get_started/get_started_screen.dart';
import 'package:attendance_management_system/user_pannel/bottom_bar/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashServices {
  void isLogin(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentRole = prefs.getString('CurrentRole') ?? '';
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (user != null) {
          print('If user is not equal to null: $currentRole');
          if (currentRole == 'Admin') {
            print('If current role is admin: $currentRole');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminBottomBar(),
              ),
            );
          } else if (currentRole == 'Student') {
            print('If current role is student: $currentRole');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const UserBottomBar(),
              ),
            );
          }
        } else {
          print('If user is equal to null: $currentRole');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const GetStartedScreen(),
            ),
          );
        }
      },
    );
  }
}
