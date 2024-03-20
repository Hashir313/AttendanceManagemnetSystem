// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:attendance_management_system/functions/authentication_function.dart';
import 'package:attendance_management_system/utils/colors.dart';
import 'package:attendance_management_system/utils/responsive_text.dart';
import 'package:attendance_management_system/widgets/custom_button.dart';
import 'package:attendance_management_system/widgets/custom_profile_image.dart';
import 'package:attendance_management_system/widgets/custom_text_field.dart';
import 'package:attendance_management_system/widgets/custom_toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../functions/upload_user_data.dart';
import '../../get_started/get_started_screen.dart';
import '../../riverpod_providers/custom_providers.dart';
import '../../user_pannel/models/user_model.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends ConsumerState<SignUpScreen> {
  File? profileImage;

  //!controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  bool isObscurePassword = true; // for showing and hiding the password
  bool isObscureConfirmPassword = true; // for showing and hiding the password

  String passwordValidator = 'password';
  String confirmPasswordValidator = 'confirm password';

  //! form key
  final _formKey = GlobalKey<FormState>();

  //? method for image picker from the given source
  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        profileImage = File(pickedImage.path);
      });
    }
  }

  //? Creating a function to get the current role of user
  Future<String> getCurrentRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentRole = prefs.getString('CurrentRole') ?? '';
    return currentRole;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      String role = await getCurrentRole();
      ref.read(stringProvider.notifier).state = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final sharedPrefData = ref.watch(stringProvider);
          return Scaffold(
            backgroundColor: secondaryColor,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: primaryColor,
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('CurrentRole');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GetStartedScreen(),
                    ),
                  );
                },
              ),
              backgroundColor: secondaryColor,
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 50.0.h,
                    left: 30.0.w,
                    right: 30.0.w,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Hi, $sharedPrefData',
                          style: GoogleFonts.poppins(
                            fontSize:
                                const ResponsiveText().getadaptiveTextSize(
                              context,
                              18.0.sp,
                            ),
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0.h,
                      ),
                      Text(
                        'Enroll effortlessly, embrace efficiency: Begin your attendance journey with ease.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: const ResponsiveText().getadaptiveTextSize(
                            context,
                            12.0.sp,
                          ),
                          fontWeight: FontWeight.w400,
                          color: textColor,
                        ),
                      ),
                      SizedBox(
                        height: 40.0.h,
                      ),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 60.0.w,
                            backgroundColor: primaryColor,
                            child: profileImage == null
                                ? Icon(
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
                      SizedBox(
                        height: 20.0.h,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
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
                              hintText: 'Jhon Doe',
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
                              hintText: 'jhonedoe@gmail.com',
                              validatorText: 'email',
                              textInputType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Password',
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
                              textEditingController: passwordController,
                              hintText: 'JhoneDoe@54fgd',
                              validatorText: passwordValidator,
                              textInputType: TextInputType.visiblePassword,
                              isObscure: isObscurePassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscurePassword = !isObscurePassword;
                                  });
                                },
                                icon: Icon(
                                  isObscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Confirm Password',
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
                              textEditingController: confirmPasswordController,
                              hintText: 'JhoneDoe@54fgd',
                              validatorText: confirmPasswordValidator,
                              textInputType: TextInputType.visiblePassword,
                              isObscure: isObscureConfirmPassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscureConfirmPassword =
                                        !isObscureConfirmPassword;
                                  });
                                },
                                icon: Icon(
                                  isObscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.0.h,
                      ),
                      SizedBox(
                        height: 40.0.h,
                        width: 250.0.w,
                        child: CustomButton(
                          buttonText: 'Continue',
                          onTap: () async {
                            String password = passwordController.text;
                            String name = nameController.text;
                            String email = emailController.text;
                            String imageUrl;
                            if (_formKey.currentState!.validate() &&
                                profileImage != null) {
                              if (passwordController.text.length >= 6) {
                                if (passwordController.text ==
                                    confirmPasswordController.text) {
                                  UserCredential? credential = await signupUser(
                                      context,
                                      emailController,
                                      passwordController);
                                  if (credential != null) {
                                    imageUrl =
                                        await uploadImageToFirebaseStorage(
                                      context,
                                      profileImage!,
                                      credential.user?.uid ?? "",
                                    );
                                    UserModel user = UserModel(
                                      uid: credential.user?.uid ?? "",
                                      username: name,
                                      email: email,
                                      // course: password,
                                      profileImageUrl: imageUrl,
                                    );
                                    await uploadUserDataToFirestore(
                                            user, credential.user?.uid ?? "")
                                        .then(
                                          (value) => toastMessage(
                                            context,
                                            'Signed up successfully!',
                                          ),
                                        )
                                        .onError(
                                          (error, stackTrace) => toastMessage(
                                            context,
                                            error.toString(),
                                          ),
                                        );
                                  }
                                } else {
                                  toastMessage(
                                    context,
                                    'Passwords are not same',
                                  );
                                }
                              } else {
                                toastMessage(
                                  context,
                                  'Password must be at least 6 characters',
                                );
                              }
                            } else {
                              toastMessage(
                                context,
                                'Please pick the profile image',
                              );
                            }
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: whiteColor,
                            size: 15.0.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
