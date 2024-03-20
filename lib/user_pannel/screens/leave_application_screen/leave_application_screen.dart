// ignore_for_file: use_build_context_synchronously

import 'package:attendance_management_system/utils/colors.dart';
import 'package:attendance_management_system/widgets/custom_button.dart';
import 'package:attendance_management_system/widgets/custom_text_field.dart';
import 'package:attendance_management_system/widgets/custom_toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/responsive_text.dart';
import '../../models/leave_application.dart';
import '../../models/user_model.dart';

class LeaveApplicationScreen extends StatefulWidget {
  const LeaveApplicationScreen({super.key});

  @override
  State<LeaveApplicationScreen> createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
  late TextEditingController _descriptionController;
  late DateTime _fromDate;
  late DateTime _toDate;
  bool _isLoading = false;
  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _fromDate = DateTime.now();
    _toDate = DateTime.now();
    _fetchUserData();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      _user = UserModel.fromJson(userData.data()!);
    });
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? _fromDate : _toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(),
          child: child!,
        );
      },
    );
    if (picked != null && picked != (isFromDate ? _fromDate : _toDate)) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  void _applyLeave() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter leave description.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final leaveId =
          FirebaseFirestore.instance.collection('leave_applications').doc().id;
      final leaveApplication = LeaveApplication(
        username: _user.username,
        email: _user.email,
        timestamp: DateTime.now(),
        fromDate: _fromDate,
        toDate: _toDate,
        description: _descriptionController.text,
        status: 'pending',
        leaveId: leaveId,
      );
      await FirebaseFirestore.instance
          .collection('leave_applications')
          .doc(leaveId)
          .set(leaveApplication.toJson());

      toastMessage(context, 'Leave application submitted successfully.');
      _descriptionController.clear();
    } catch (error) {
      toastMessage(context,
          'Failed to submit leave application. Please try again later.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          foregroundColor: secondaryColor,
          backgroundColor: primaryColor,
          title: const Text('Leave Application'),
          titleTextStyle: GoogleFonts.poppins(
            color: secondaryColor,
            fontSize: const ResponsiveText().getadaptiveTextSize(
              context,
              18.0.sp,
            ),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 50.0.h),
                    Text(
                      'Leave Reason:',
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: const ResponsiveText()
                              .getadaptiveTextSize(context, 14.0.sp)),
                    ),
                    SizedBox(height: 20.0.h),
                    CustomTextField(
                      textEditingController: _descriptionController,
                      hintText: 'Leave Reason.',
                      validatorText: 'leave',
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(height: 16.0.h),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'From',
                              style: GoogleFonts.poppins(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: const ResponsiveText()
                                    .getadaptiveTextSize(context, 12.0.sp),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _selectDate(context, true),
                              child: SizedBox(
                                width: 150.0.w,
                                child: TextField(
                                  enabled: false,
                                  style: GoogleFonts.poppins(color: hintColor),
                                  decoration: const InputDecoration(),
                                  controller: TextEditingController(
                                      text: DateFormat('yyyy-MM-dd')
                                          .format(_fromDate)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20.0.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'To',
                              style: GoogleFonts.poppins(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: const ResponsiveText()
                                    .getadaptiveTextSize(context, 12.0.sp),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _selectDate(context, false),
                              child: SizedBox(
                                width: 150.0.w,
                                child: TextField(
                                  enabled: false,
                                  style: GoogleFonts.poppins(color: hintColor),
                                  decoration: const InputDecoration(),
                                  controller: TextEditingController(
                                      text: DateFormat('yyyy-MM-dd')
                                          .format(_toDate)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0.h),
                    SizedBox(
                      height: 40.0.h,
                      child: CustomButton(
                        buttonText: 'Apply Leave',
                        onTap: _applyLeave,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
