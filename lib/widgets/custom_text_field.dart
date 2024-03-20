import 'package:attendance_management_system/utils/colors.dart';
import 'package:attendance_management_system/utils/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String validatorText;
  final bool? isObscure;
  final IconButton? suffixIcon;
  final TextInputType textInputType;
  const CustomTextField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.validatorText,
    this.isObscure = false,
    this.suffixIcon,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      obscureText: isObscure!,
      cursorColor: primaryColor,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: textInputType,
      style: GoogleFonts.poppins(
        color: textColor,
        fontSize: const ResponsiveText().getadaptiveTextSize(context, 12.sp),
      ),
      decoration: InputDecoration(
        labelStyle: GoogleFonts.poppins(
          color: textColor,
          fontSize: const ResponsiveText().getadaptiveTextSize(context, 12.sp),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          color: hintColor,
          fontSize: const ResponsiveText().getadaptiveTextSize(context, 12.sp),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0.r),
          borderSide: const BorderSide(
            color: primaryColor,
          ),
        ),
        enabled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0.r),
          borderSide: BorderSide(
            color: primaryColor,
            width: 2.0.r,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0.r),
          borderSide: const BorderSide(
            color: primaryColor,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your $validatorText.';
        }
        return null;
      },
    );
  }
}
