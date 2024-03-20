// ignore_for_file: use_build_context_synchronously

import 'package:attendance_management_system/auth/login_screen/login_screen.dart';
import 'package:attendance_management_system/utils/colors.dart';
import 'package:attendance_management_system/utils/responsive_text.dart';
import 'package:attendance_management_system/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/get_started_screen.png',
                  width: 300.w,
                  height: 300.h,
                ),
              ),
              SizedBox(
                height: 10.0.h,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Reduce the workload of the management',
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: const ResponsiveText()
                        .getadaptiveTextSize(context, 15.sp),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Help you to improve efficeincy, accuracy and engagement for students and teachers.',
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: const ResponsiveText()
                        .getadaptiveTextSize(context, 12.sp),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                height: 20.0.h,
              ),
              SizedBox(
                width: 300.w,
                child: CustomButton(
                  buttonText: 'I\'m a student',
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('CurrentRole', 'Student');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 30.0.h,
              ),
              SizedBox(
                  width: 300.w,
                  child: InkWell(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('CurrentRole', 'Admin');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50.h,
                      width: 200.0.w,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10.0.r),
                        border: Border.all(
                          color: primaryColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'I\'.m an admin',
                          style: GoogleFonts.poppins(
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
