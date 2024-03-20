import 'package:attendance_management_system/splash_screen/splash_services.dart';
import 'package:attendance_management_system/utils/colors.dart';
import 'package:attendance_management_system/utils/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashServices _services = SplashServices();

  @override
  void initState() {
    super.initState();
    _services.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/splash_screen_images.png',
                height: 300.0.h,
                width: 300.0.w,
              ),
            ),
            SizedBox(height: 20.0.h),
            Text('Attendance Management System',
            textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: const ResponsiveText()
                      .getadaptiveTextSize(context, 20.0.sp),
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                  fontStyle: FontStyle.italic,
                ))
          ],
        ),
      ),
    );
  }
}
