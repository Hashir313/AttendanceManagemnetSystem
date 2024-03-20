import 'package:attendance_management_system/utils/colors.dart';
import 'package:attendance_management_system/utils/responsive_text.dart';
import 'package:attendance_management_system/widgets/custom_button.dart';
import 'package:attendance_management_system/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController resetPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        titleTextStyle: GoogleFonts.poppins(
          color: primaryColor,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
            size: 20.0.r,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 20.0.h,
            left: 20.0.w,
            right: 20.0.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/forgot_password_image.png',
                  height: 250.0.h,
                  width: 250.0.w,
                ),
              ),
              Text(
                'Unlock your journey: Reset your password and rediscover boundless possibilities.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: primaryColor,
                  fontSize: const ResponsiveText()
                      .getadaptiveTextSize(context, 12.0.sp),
                ),
              ),
              SizedBox(
                height: 50.0.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter your email to reset your password:',
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: const ResponsiveText()
                        .getadaptiveTextSize(context, 12.0.sp),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0.h,
              ),
              CustomTextField(
                textEditingController: resetPasswordController,
                hintText: 'Enter your email',
                validatorText: 'email',
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 20.0.h,
              ),
              SizedBox(
                height: 40.0.h,
                width: 250.0.w,
                child: CustomButton(
                  buttonText: 'Reset Password',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
