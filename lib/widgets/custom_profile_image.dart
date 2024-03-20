import 'package:attendance_management_system/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/responsive_text.dart';

class CustomProfileImage extends StatelessWidget {
  final void Function(ImageSource source) pickImage;
  const CustomProfileImage({super.key, required this.pickImage});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0.r,
      right: 0.0.r,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                backgroundColor: secondaryColor,
                title: const Text('Choose Profile Image'),
                titleTextStyle: GoogleFonts.poppins(
                  fontSize: const ResponsiveText().getadaptiveTextSize(
                    context,
                    14.0.sp,
                  ),
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('Gallery'),
                      tileColor: primaryColor,
                      leading: const Icon(
                        Icons.image,
                        color: whiteColor,
                      ),
                      titleTextStyle: GoogleFonts.poppins(
                        fontSize: const ResponsiveText().getadaptiveTextSize(
                          context,
                          12.0.sp,
                        ),
                        color: whiteColor,
                      ),
                      onTap: () {
                        pickImage(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          10.0.r,
                        ),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    ListTile(
                      title: const Text('Camera'),
                      tileColor: secondaryColor,
                      leading: const Icon(
                        Icons.camera_alt,
                        color: primaryColor,
                      ),
                      shape: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(
                          10.0.r,
                        ),
                      ),
                      titleTextStyle: GoogleFonts.poppins(
                        fontSize: const ResponsiveText().getadaptiveTextSize(
                          context,
                          12.0.sp,
                        ),
                        color: primaryColor,
                      ),
                      onTap: () {
                        pickImage(ImageSource.camera);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: CircleAvatar(
          backgroundColor: whiteColor,
          radius: 15.0.r,
          child: Icon(
            Icons.add,
            size: 20.0.r,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
