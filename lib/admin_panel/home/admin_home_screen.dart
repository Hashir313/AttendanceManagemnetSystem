// ignore_for_file: use_build_context_synchronously

import 'package:attendance_management_system/utils/responsive_text.dart';
import 'package:attendance_management_system/widgets/custom_toast_message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  Future<void> _deleteAttendanceRecord(
      BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('attendance_records')
          .doc(documentId)
          .delete();
      toastMessage(context, 'Attendance record deleted successfully');
    } catch (e) {
      toastMessage(context, 'Error deleting attendance record: $e');
    }
  }

  Future<void> _editAttendanceDialog(BuildContext context, String documentId) {
    // Implement your edit attendance dialog here
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Attendance'),
          content: const Text('This is a placeholder for editing attendance.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addAttendanceRecord(BuildContext context) async {
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController statusController = TextEditingController();
    final DateTime selectedDate = DateTime.now();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Attendance Record'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userNameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 10),
              Text('Date: ${DateFormat.yMMMd().format(selectedDate)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final String userName = userNameController.text;
                final String email = emailController.text;
                final String status = statusController.text;

                if (userName.isNotEmpty &&
                    email.isNotEmpty &&
                    status.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('attendance_records')
                        .add({
                      'username': userName,
                      'email': email,
                      'status': status,
                      'dateTime': selectedDate,
                      'uploadedBy': 'admin', // Store the uploader's ID here
                    });
                    toastMessage(
                        context, 'Attendance record added successfully');
                    Navigator.of(context).pop(); // Close the dialog
                  } catch (e) {
                    toastMessage(context, 'Error: ${e.toString()}');
                  }
                } else {
                  toastMessage(context, 'Please fill al the fields');
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
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
            color: whiteColor,
            fontSize:
                const ResponsiveText().getadaptiveTextSize(context, 18.0.sp),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondaryColor,
          foregroundColor: primaryColor,
          onPressed: () {
            _addAttendanceRecord(context);
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 20.0.h),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('attendance_records')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

              return Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: Text(
                        'List of students attendacne status:',
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: const ResponsiveText()
                              .getadaptiveTextSize(context, 16.0.sp),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        final attendanceData =
                            documents[index].data() as Map<String, dynamic>;
                        final userName = attendanceData['username'] ?? '';
                        final attendanceStatus = attendanceData['status'] ?? '';
                        final attendanceDate =
                            attendanceData['dateTime']?.toDate() ??
                                DateTime.now();
                        final documentId = documents[index].id;

                        return Padding(
                          padding: EdgeInsets.only(
                              top: 10.0.h, left: 20.0.w, right: 20.0.w),
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
                                        'Attendance Date: ',
                                        style: GoogleFonts.poppins(
                                          fontSize: const ResponsiveText()
                                              .getadaptiveTextSize(
                                                  context, 14.0.sp),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 10.0.w),
                                      Text(
                                        DateFormat.yMMMd()
                                            .format(attendanceDate),
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
                                        'Attendance Status: ',
                                        style: GoogleFonts.poppins(
                                          fontSize: const ResponsiveText()
                                              .getadaptiveTextSize(
                                                  context, 14.0.sp),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 10.0.w),
                                      Text(
                                        attendanceStatus,
                                        style: GoogleFonts.poppins(
                                          fontSize: const ResponsiveText()
                                              .getadaptiveTextSize(
                                                  context, 14.0.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            _editAttendanceDialog(
                                              context,
                                              documentId,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: primaryColor,
                                          ),
                                          label: Text(
                                            'Edit',
                                            style: GoogleFonts.poppins(
                                              fontSize: const ResponsiveText()
                                                  .getadaptiveTextSize(
                                                      context, 12.0.sp),
                                              color: primaryColor,
                                            ),
                                          ),
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                              secondaryColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 30.0.sp),
                                        TextButton.icon(
                                          onPressed: () {
                                            _deleteAttendanceRecord(
                                              context,
                                              documentId,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: whiteColor,
                                          ),
                                          label: Text(
                                            'Delete',
                                            style: GoogleFonts.poppins(
                                              fontSize: const ResponsiveText()
                                                  .getadaptiveTextSize(
                                                      context, 12.0.sp),
                                              color: whiteColor,
                                            ),
                                          ),
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.red),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
