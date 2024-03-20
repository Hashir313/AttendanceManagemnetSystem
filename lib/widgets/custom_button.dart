import 'package:attendance_management_system/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final bool? isLoading;
  final VoidCallback onTap;
  final Icon? icon;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.isLoading = false,
    this.icon,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonColor = isDisabled ? buttonDisabledColor : primaryColor;
    Color buttonTextColor = isDisabled ? hintColor : whiteColor;
    return Material(
      shadowColor: primaryColor,
      borderRadius: BorderRadius.circular(10.0.r),
      elevation: isDisabled ? 0.r : 5.0.r,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50.h,
          width: 200.0.w,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  buttonText,
                  style: GoogleFonts.poppins(
                    color: buttonTextColor,
                  ),
                ),
                SizedBox(
                  width: 10.0.w,
                ),
                if (icon != null) icon! else Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
