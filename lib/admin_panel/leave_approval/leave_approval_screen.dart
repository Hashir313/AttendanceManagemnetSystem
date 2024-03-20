import 'package:attendance_management_system/utils/colors.dart';
import 'package:attendance_management_system/widgets/custom_toast_message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../utils/responsive_text.dart';

class LeaveApprovalScreen extends StatefulWidget {
  const LeaveApprovalScreen({super.key});

  @override
  State<LeaveApprovalScreen> createState() => _LeaveApprovalScreenState();
}

class _LeaveApprovalScreenState extends State<LeaveApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Leave Approval'),
        titleTextStyle: GoogleFonts.poppins(
          color: whiteColor,
          fontSize:
              const ResponsiveText().getadaptiveTextSize(context, 18.0.sp),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 10.0.h,
              left: 20.0.w,
              right: 20.0.w,
            ),
            child: Text(
              'Applied Leave:', // Replace with actual count
              style: GoogleFonts.poppins(
                  fontSize: const ResponsiveText()
                      .getadaptiveTextSize(context, 18.0.sp),
                  fontWeight: FontWeight.w600,
                  color: textColor),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('leave_applications')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final leaveRequests = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: leaveRequests.length,
                  itemBuilder: (context, index) {
                    final leaveRequestData =
                        leaveRequests[index].data() as Map<String, dynamic>;
                    final userName = leaveRequestData['username'] ?? '';
                    final leaveTime = leaveRequestData['timestamp'] ?? '';
                    final leaveStatus = leaveRequestData['status'] ?? 'Pending';
                    final leaveDescription =
                        leaveRequestData['description'] ?? '';
                    final appliedDate = DateFormat('EEE, dd MMM, yyyy')
                        .format(leaveTime.toDate());
                    return Padding(
                      padding: EdgeInsets.only(
                        top: 10.0.h,
                        left: 20.0.w,
                        right: 20.0.w,
                      ),
                      child: Card(
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
                                          .getadaptiveTextSize(
                                              context, 14.0.sp),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 10.0.w),
                                  Text(
                                    userName,
                                    style: GoogleFonts.poppins(
                                      fontSize: const ResponsiveText()
                                          .getadaptiveTextSize(
                                              context, 14.0.sp),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0.h),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Applied Date: ',
                                    style: GoogleFonts.poppins(
                                      fontSize: const ResponsiveText()
                                          .getadaptiveTextSize(
                                              context, 14.0.sp),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 10.0.w),
                                  Text(
                                    appliedDate,
                                    style: GoogleFonts.poppins(
                                      fontSize: const ResponsiveText()
                                          .getadaptiveTextSize(
                                              context, 14.0.sp),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0.h),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Application Status: ',
                                    style: GoogleFonts.poppins(
                                      fontSize: const ResponsiveText()
                                          .getadaptiveTextSize(
                                              context, 14.0.sp),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 10.0.w),
                                  Text(
                                    leaveStatus,
                                    style: GoogleFonts.poppins(
                                      fontSize: const ResponsiveText()
                                          .getadaptiveTextSize(
                                              context, 14.0.sp),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0.h),
                              Text(
                                'Application Description: $leaveDescription',
                                style: GoogleFonts.poppins(
                                  fontSize: const ResponsiveText()
                                      .getadaptiveTextSize(context, 12.0.sp),
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _updateLeaveStatus(
                                          leaveRequests[index].reference,
                                          'Approved',
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                          Colors.green.shade600,
                                        ),
                                      ),
                                      child: Text(
                                        'Approve',
                                        style: GoogleFonts.poppins(
                                            color: whiteColor),
                                      ),
                                    ),
                                    SizedBox(width: 20.0.w),
                                    ElevatedButton(
                                      onPressed: () {
                                        _updateLeaveStatus(
                                          leaveRequests[index].reference,
                                          'Rejected',
                                        );
                                      },
                                      style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                          Colors.red,
                                        ),
                                      ),
                                      child: Text(
                                        'Reject',
                                        style: GoogleFonts.poppins(
                                            color: whiteColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.0.h),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateLeaveStatus(
      DocumentReference reference, String status) async {
    try {
      await reference.update({'status': status});
    } catch (e) {
      toastMessage(context, 'Error updating leave status: $e');
      // Handle error
    }
  }
}
