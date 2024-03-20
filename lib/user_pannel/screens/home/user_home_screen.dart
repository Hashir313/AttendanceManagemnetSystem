import 'package:attendance_management_system/utils/colors.dart';
import 'package:attendance_management_system/utils/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String? attendanceStatus;
  String? studentAttendance;

  @override
  void initState() {
    super.initState();
    checkAttendanceStatus();
  }

  Future<void> checkAttendanceStatus() async {
    final user = FirebaseAuth.instance.currentUser!;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final querySnapshot = await FirebaseFirestore.instance
        .collection('attendance_records')
        .where('userId', isEqualTo: user.uid)
        .where('dateTime', isGreaterThanOrEqualTo: startOfDay)
        .where('dateTime', isLessThanOrEqualTo: endOfDay)
        .get();

    setState(() {
      final status = querySnapshot.docs.isNotEmpty
          ? querySnapshot.docs.first['status']
          : null;
      if (querySnapshot.docs.isNotEmpty) {
        studentAttendance = status;
        attendanceStatus = 'Marked';
      } else {
        studentAttendance = 'Absent';
        attendanceStatus = 'Not Marked';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('Dashboard'),
          titleTextStyle: GoogleFonts.poppins(
            color: secondaryColor,
            fontSize: const ResponsiveText().getadaptiveTextSize(
              context,
              18.0.sp,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('E, d MMM, yyyy').format(DateTime.now()),
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: const ResponsiveText().getadaptiveTextSize(
                    context,
                    18.0.sp,
                  ),
                ),
              ),
              Text(
                studentAttendance ?? 'Loading...',
                style: GoogleFonts.poppins(
                  color: primaryColor,
                  fontSize: const ResponsiveText().getadaptiveTextSize(
                    context,
                    14.0.sp,
                  ),
                ),
              ),
              SizedBox(height: 30.0.h),
              Text(
                'Attendance Status:',
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: const ResponsiveText().getadaptiveTextSize(
                    context,
                    18.0.sp,
                  ),
                ),
              ),
              SizedBox(height: 10.0.h),
              Text(
                attendanceStatus ?? 'Loading...',
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: const ResponsiveText().getadaptiveTextSize(
                    context,
                    14.0.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
