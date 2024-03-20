// ignore_for_file: use_build_context_synchronously

import 'package:attendance_management_system/widgets/custom_button.dart';
import 'package:attendance_management_system/widgets/custom_toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/colors.dart';
import '../../utils/responsive_text.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  DateTime? fromDate;
  DateTime? toDate;
  List<Map<String, dynamic>> attendanceList = [];

  @override
  void initState() {
    super.initState();
    fromDate = DateTime.now();
    toDate = DateTime.now();
  }

  Future<void> _generateReport(
      BuildContext context, DateTime fromDate, DateTime toDate) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('attendance_records')
          .where('dateTime', isGreaterThanOrEqualTo: fromDate)
          .where('dateTime', isLessThanOrEqualTo: toDate)
          .get();

      setState(() {
        attendanceList = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      toastMessage(context, 'Error generating report: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Specific Attendance Report'),
        titleTextStyle: GoogleFonts.poppins(
          color: whiteColor,
          fontSize:
              const ResponsiveText().getadaptiveTextSize(context, 18.0.sp),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select specific date for attendance list',
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: const ResponsiveText()
                    .getadaptiveTextSize(context, 14.0.sp),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: fromDate ?? DateTime.now(),
                          firstDate: DateTime(2010),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            fromDate = selectedDate;
                          });
                        }
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'From: ',
                              style: GoogleFonts.poppins(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    const ResponsiveText().getadaptiveTextSize(
                                  context,
                                  14.0.sp,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: DateFormat.yMMMd().format(
                                fromDate ?? DateTime.now(),
                              ),
                              style: GoogleFonts.poppins(
                                color: textColor,
                                fontSize:
                                    const ResponsiveText().getadaptiveTextSize(
                                  context,
                                  12.0.sp,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: toDate ?? DateTime.now(),
                          firstDate: DateTime(2010),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            toDate = selectedDate;
                          });
                        }
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'To: ',
                              style: GoogleFonts.poppins(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    const ResponsiveText().getadaptiveTextSize(
                                  context,
                                  14.0.sp,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: DateFormat.yMMMd().format(
                                toDate ?? DateTime.now(),
                              ),
                              style: GoogleFonts.poppins(
                                color: textColor,
                                fontSize:
                                    const ResponsiveText().getadaptiveTextSize(
                                  context,
                                  12.0.sp,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40.0.h,
              child: CustomButton(
                buttonText: 'Generate Report',
                onTap: () {
                  _generateReport(context, fromDate!, toDate!);
                },
              ),
            ),
            SizedBox(height: 50.0.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Specific Studnets List',
                style: GoogleFonts.poppins(
                  fontSize: const ResponsiveText()
                      .getadaptiveTextSize(context, 16.0.sp),
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 10.0.sp),
            Expanded(
              child: ListView.builder(
                itemCount: attendanceList.length,
                itemBuilder: (context, index) {
                  final userData = attendanceList[index];
                  final userName = userData['username'] ?? '';
                  final attendanceStatus = userData['status'] ?? '';
                  final attendanceDate =
                      userData['dateTime']?.toDate() ?? DateTime.now();

                  return Card(
                    color: primaryColor,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10.0.sp,
                        left: 10.0.sp,
                        right: 10.0.sp,
                      ),
                      child: Column(
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Username: ',
                                style: GoogleFonts.poppins(
                                  fontSize: const ResponsiveText()
                                      .getadaptiveTextSize(context, 14.0.sp),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10.0.w),
                              Text(
                                userName,
                                style: GoogleFonts.poppins(
                                  fontSize: const ResponsiveText()
                                      .getadaptiveTextSize(context, 14.0.sp),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0.h),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Attendance Date: ',
                                style: GoogleFonts.poppins(
                                  fontSize: const ResponsiveText()
                                      .getadaptiveTextSize(context, 14.0.sp),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10.0.w),
                              Text(
                                DateFormat.yMMMd().format(attendanceDate),
                                style: GoogleFonts.poppins(
                                  fontSize: const ResponsiveText()
                                      .getadaptiveTextSize(context, 14.0.sp),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0.h),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Attendance Status: ',
                                style: GoogleFonts.poppins(
                                  fontSize: const ResponsiveText()
                                      .getadaptiveTextSize(context, 14.0.sp),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10.0.w),
                              Text(
                                attendanceStatus,
                                style: GoogleFonts.poppins(
                                  fontSize: const ResponsiveText()
                                      .getadaptiveTextSize(context, 14.0.sp),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0.h),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
