import 'package:attendance_management_system/firebase_options.dart';
import 'package:attendance_management_system/splash_screen/splash_screen.dart';
import 'package:attendance_management_system/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Attendance Management System',
          theme: ThemeData(
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: secondaryColor,
              headerBackgroundColor: primaryColor,
              headerHeadlineStyle: GoogleFonts.poppins(
                color: primaryColor,
              ),
              headerHelpStyle: GoogleFonts.poppins(
                color: primaryColor,
              ),
              headerForegroundColor: whiteColor,
              dayStyle: GoogleFonts.poppins(
                color: primaryColor,
              ),
              yearStyle: GoogleFonts.poppins(
                color: primaryColor,
              ),
              weekdayStyle: GoogleFonts.poppins(
                color: primaryColor,
              ),
              
              confirmButtonStyle: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll(primaryColor),
                foregroundColor: const MaterialStatePropertyAll(whiteColor),
                textStyle: MaterialStatePropertyAll(
                  GoogleFonts.poppins(),
                ),
              ),
              todayBackgroundColor:
                  const MaterialStatePropertyAll(primaryColor),
              cancelButtonStyle: ButtonStyle(
                foregroundColor: const MaterialStatePropertyAll(textColor),
                textStyle: MaterialStatePropertyAll(
                  GoogleFonts.poppins(),
                ),
              ),
            ),
          ),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}
