// ignore_for_file: use_build_context_synchronously

import 'package:attendance_management_system/functions/upload_user_data.dart';
import 'package:attendance_management_system/riverpod_providers/custom_providers.dart';
import 'package:attendance_management_system/user_pannel/models/user_model.dart';
import 'package:attendance_management_system/utils/colors.dart';
import 'package:attendance_management_system/utils/responsive_text.dart';
import 'package:attendance_management_system/widgets/custom_button.dart';
import 'package:attendance_management_system/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class UpdateUserProfile extends StatefulWidget {
  final String username;
  final String email;
  final String course;
  final void Function(UserProfile) onUpdate;

  const UpdateUserProfile({
    super.key,
    required this.username,
    required this.email,
    required this.course,
    required this.onUpdate,
  });

  @override
  State<UpdateUserProfile> createState() => _UpdatUsereProfileState();
}

class _UpdatUsereProfileState extends State<UpdateUserProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: secondaryColor,
          title: const Text('Update Profile'),
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            color: secondaryColor,
            fontSize: const ResponsiveText().getadaptiveTextSize(
              context,
              20.0.sp,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top: 30.0.h,
            left: 10.0.h,
            right: 10.0.h,
            bottom: 10.0.h,
          ),
          child: Column(
            children: [
              Text(
                "Update your details and let your brilliance shine brighter than ever.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: primaryColor,
                  fontSize: const ResponsiveText().getadaptiveTextSize(
                    context,
                    14.0.sp,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Username',
                  style: GoogleFonts.poppins(
                    fontSize: const ResponsiveText()
                        .getadaptiveTextSize(context, 12.0.sp),
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 6.0.h,
              ),
              CustomTextField(
                textEditingController: nameController,
                hintText: widget.username,
                validatorText: 'username',
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 10.0.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email Address',
                  style: GoogleFonts.poppins(
                    fontSize: const ResponsiveText()
                        .getadaptiveTextSize(context, 12.0.sp),
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 6.0.h,
              ),
              CustomTextField(
                textEditingController: emailController,
                hintText: widget.email,
                validatorText: 'email',
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 10.0.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Course',
                  style: GoogleFonts.poppins(
                    fontSize: const ResponsiveText()
                        .getadaptiveTextSize(context, 12.0.sp),
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 6.0.h,
              ),
              CustomTextField(
                textEditingController: courseController,
                hintText: widget.course,
                validatorText: 'course',
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 50.0.h,
              ),
              SizedBox(
                height: 40.0.h,
                child: CustomButton(
                  buttonText: 'Update',
                  onTap: () async {
                    UserModel userModel = UserModel(
                      uid: FirebaseAuth.instance.currentUser!.uid,
                      username: nameController.text,
                      email: emailController.text,
                      profileImageUrl: '',
                      // course: '',
                    );

                    await updateUserDataToFirestore(
                      context,
                      userModel,
                      FirebaseAuth.instance.currentUser!.uid,
                    );
                    widget.onUpdate(UserProfile(nameController.text,
                        emailController.text, courseController.text));
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
