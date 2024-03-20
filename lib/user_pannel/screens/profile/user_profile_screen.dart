import 'dart:io';

import 'package:attendance_management_system/functions/authentication_function.dart';
import 'package:attendance_management_system/widgets/custom_button.dart';
import 'package:attendance_management_system/widgets/custom_profile_image.dart';
import 'package:attendance_management_system/widgets/custom_toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/colors.dart';
import '../../../utils/responsive_text.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController courseController = TextEditingController();

  //? getting the selected role from firebase firestore
  String? role;

  String? profileImageUrl;

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;

      // Fetch the user document
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          usernameController.text = documentSnapshot['username'];
          emailController.text = documentSnapshot['email'];
          // courseController.text = documentSnapshot['course'];
          profileImageUrl = documentSnapshot['profileImageUrl'];
          role = documentSnapshot['currentRole'];
          print(profileImageUrl);
        });
      }

      // Check if there's a new profile image to upload
      if (profileImage != null) {
        // Delete the existing profile image from Firebase Storage if it exists
        final oldImageUrl = documentSnapshot['profileImageUrl'] as String?;
        if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
          try {
            await FirebaseStorage.instance.refFromURL(oldImageUrl).delete();
            print('Old profile image deleted');
          } catch (e) {
            print('Error deleting old profile image: $e');
          }
        }

        // Upload the new profile image to Firebase Storage
        final imageFileName = 'profile_images/$userId';
        final UploadTask uploadTask =
            FirebaseStorage.instance.ref(imageFileName).putFile(profileImage!);

        // Get the download URL once the upload is complete
        final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        String? newImageUrl;

        if (snapshot.state == TaskState.success) {
          newImageUrl = await snapshot.ref.getDownloadURL();
          print('Image uploaded');
        }

        // Update the profileImageUrl field in Firestore with the new image URL
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'profileImageUrl': newImageUrl,
          'username': usernameController.text,
          'email': emailController.text,
        }).then((value) {
          toastMessage(context, 'Profile  updated successfully');
        }).catchError((error) {
          toastMessage(context, 'Error updating profile : $error');
        });

        // Update the profileImageUrl variable in the state
        setState(() {
          profileImageUrl = newImageUrl;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  File? profileImage;
//? method for image picker from the given source
  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        profileImage = File(pickedImage.path);
      });
    }
  }

  //? Method for updating the profile image to firebase storage and user data
  Future<void> updateProfileImageAndUserData() async {
    String username = usernameController.text;
    String email = emailController.text;
    if (profileImage != null && username.isNotEmpty && email.isNotEmpty) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
      await ref.putFile(profileImage!);
      final imageUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'profileImageUrl': imageUrl,
        'username': username,
        'email': email,
      }).then((value) {
        toastMessage(context, 'Profile updated successfully');
      }).catchError((error) {
        toastMessage(context, 'Error updating profile: $error');
      });
    } else {
      toastMessage(context, 'Please fill all fields and select an image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('Your Profile'),
          titleTextStyle: GoogleFonts.poppins(
            color: secondaryColor,
            fontSize: const ResponsiveText().getadaptiveTextSize(
              context,
              18.0.sp,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                signOutUser(context);
              },
              icon: const Icon(
                Icons.logout,
                color: whiteColor,
              ),
            ),
          ],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 15.0.sp, vertical: 50.0.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Discover the beauty within you, reflected in every pixel of your profile.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: primaryColor,
                      fontSize: const ResponsiveText().getadaptiveTextSize(
                        context,
                        14.0.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0.h),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60.0.w,
                        backgroundColor: primaryColor,
                        child: profileImage == null
                            ? profileImageUrl != null &&
                                    profileImageUrl!.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(60.0.w),
                                    child: Image.network(
                                      profileImageUrl!,
                                      width: 150.0.w,
                                      height: 150.0.w,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 50.0.w,
                                    color: whiteColor,
                                  )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(60.0.w),
                                child: Image.file(
                                  profileImage!,
                                  width: 150.0.w,
                                  height: 150.0.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                      ),
                      CustomProfileImage(
                        pickImage: pickImage,
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 10.0.w),
                      Text(
                        'Username:',
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 16.0.sp,
                        ),
                      ),
                      SizedBox(
                        width: 180.0.w,
                        child: TextField(
                          style: GoogleFonts.poppins(
                            color: hintColor,
                            fontSize: const ResponsiveText()
                                .getadaptiveTextSize(context, 12.0.sp),
                          ),
                          controller: usernameController,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            focusColor: primaryColor,
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColor,
                              ),
                            ),
                            hintText: 'Jhon Doe',
                            hintStyle: GoogleFonts.poppins(
                              color: hintColor,
                              fontSize: const ResponsiveText()
                                  .getadaptiveTextSize(context, 12.0.sp),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20.0.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 10.0.w),
                      Expanded(
                        child: Align(
                          child: Text(
                            'Email:',
                            style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 16.0.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 30.0.h),
                      SizedBox(
                        width: 180.0.w,
                        child: TextField(
                          style: GoogleFonts.poppins(
                            color: hintColor,
                            fontSize: const ResponsiveText()
                                .getadaptiveTextSize(context, 12.0.sp),
                          ),
                          controller: emailController,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            focusColor: primaryColor,
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColor,
                              ),
                            ),
                            hintText: 'JhonDoe@gmail.com',
                            hintStyle: GoogleFonts.poppins(
                              color: hintColor,
                              fontSize: const ResponsiveText()
                                  .getadaptiveTextSize(context, 12.0.sp),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20.0.h),
                  role == 'student'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(height: 10.0.w),
                            Expanded(
                              child: Align(
                                child: Text(
                                  'Course:',
                                  style: GoogleFonts.poppins(
                                    color: textColor,
                                    fontSize: 16.0.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 30.0.h),
                            SizedBox(
                              width: 180.0.w,
                              child: TextField(
                                style: GoogleFonts.poppins(
                                  color: hintColor,
                                  fontSize: const ResponsiveText()
                                      .getadaptiveTextSize(context, 12.0.sp),
                                ),
                                controller: courseController,
                                cursorColor: primaryColor,
                                decoration: InputDecoration(
                                  focusColor: primaryColor,
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  hintText: 'Software Engineering',
                                  hintStyle: GoogleFonts.poppins(
                                    color: hintColor,
                                    fontSize: const ResponsiveText()
                                        .getadaptiveTextSize(context, 12.0.sp),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : const SizedBox(),
                  SizedBox(height: 50.0.h),
                  SizedBox(
                    height: 40.0.h,
                    child: CustomButton(
                      buttonText: 'Update Profile',
                      onTap: () {
                        updateProfileImageAndUserData();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
