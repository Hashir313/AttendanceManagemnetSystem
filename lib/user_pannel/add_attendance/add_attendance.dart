import 'package:attendance_management_system/user_pannel/models/attendance_model.dart';
import 'package:attendance_management_system/user_pannel/screens/leave_application_screen/leave_application_screen.dart';
import 'package:attendance_management_system/utils/colors.dart';
import 'package:attendance_management_system/widgets/custom_button.dart';
import 'package:attendance_management_system/widgets/custom_toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/responsive_text.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({super.key});

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  // Attendance status variables
  String? markedStatus;

  bool isButtonDisabled = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkButtonStatus();
  }

  void checkButtonStatus() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    FirebaseFirestore.instance
        .collection('attendance_records')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('dateTime', isGreaterThanOrEqualTo: startOfDay)
        .where('dateTime', isLessThanOrEqualTo: endOfDay)
        .get()
        .then((querySnapshot) {
      markedStatus = querySnapshot.docs.isNotEmpty
          ? querySnapshot.docs.first['status']
          : null;
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          isButtonDisabled = true;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void markAttendance(String status) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final attendanceRecord = AttendanceRecord(
      userId: user.uid,
      username: userData['username'],
      email: userData['email'],
      status: status,
      dateTime: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('attendance_records')
        .add(attendanceRecord.toMap());

    setState(() {
      isButtonDisabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Mark Attendance'),
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
        child: isLoading
            ? const CircularProgressIndicator(
                color: primaryColor,
              )
            : isButtonDisabled
                ? SizedBox(
                    height: 40.0.h,
                    width: double.infinity,
                    child: CustomButton(
                      isDisabled: true,
                      buttonText: 'Attendance Marked as $markedStatus',
                      onTap: () {
                        toastMessage(
                          context,
                          'You can only mark your attendance once in a day.',
                        );
                      },
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        SizedBox(
                          height: 40.0.h,
                          width: 200.0.w,
                          child: CustomButton(
                            isDisabled: isButtonDisabled,
                            buttonText: 'Mark Present',
                            onTap: () => markAttendance('Present'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 40.0.h,
                          width: 200.0.w,
                          child: CustomButton(
                            isDisabled: isButtonDisabled,
                            buttonText: 'Mark Absent',
                            onTap: () => markAttendance('Absent'),
                          ),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        SizedBox(height: 20.0.h),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LeaveApplicationScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Apply for a leave?',
                              style: GoogleFonts.poppins(
                                  decoration: TextDecoration.underline,
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: const ResponsiveText()
                                      .getadaptiveTextSize(context, (12.0.sp))),
                            ))
                      ]),
      ),
    );
  }
}
