import 'package:attendance_management_system/functions/authentication_function.dart';
import 'package:attendance_management_system/get_started/get_started_screen.dart';
import 'package:attendance_management_system/auth/signup_screen/signup_screen.dart';
import 'package:attendance_management_system/utils/colors.dart';
import 'package:attendance_management_system/utils/responsive_text.dart';
import 'package:attendance_management_system/widgets/custom_button.dart';
import 'package:attendance_management_system/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../riverpod_providers/custom_providers.dart';
import '../forgot_password_screen/forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends ConsumerState<LoginScreen> {
  //!controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isObscure = true; // for showing and hiding the password

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

  //!form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
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
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 20.0.w,
                    left: 30.0.w,
                    right: 30.0.w,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.0.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Hi, $sharedPrefData',
                          style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: const ResponsiveText()
                                .getadaptiveTextSize(context, 18.sp),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'Welcome, let\'s continue where we left',
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: const ResponsiveText()
                              .getadaptiveTextSize(context, 11.sp),
                        ),
                      ),
                      SizedBox(
                        height: 70.0.h,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email Address',
                                style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontSize: const ResponsiveText()
                                      .getadaptiveTextSize(context, 12.sp),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),
                            CustomTextField(
                              textEditingController: emailController,
                              hintText: 'Enter your email',
                              validatorText: 'email',
                              textInputType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 20.0.h,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Password',
                                style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontSize: const ResponsiveText()
                                      .getadaptiveTextSize(context, 12.sp),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),
                            CustomTextField(
                              textEditingController: passwordController,
                              hintText: 'Enter your password',
                              validatorText: 'password',
                              isObscure: isObscure,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                              ),
                              textInputType: TextInputType.visiblePassword,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.0.h,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: const ResponsiveText()
                                  .getadaptiveTextSize(context, 10.sp),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.0.h,
                      ),
                      SizedBox(
                        width: 250.0.w,
                        height: 40.0.h,
                        child: CustomButton(
                          buttonText: 'Continue',
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: whiteColor,
                            size: 15.0.r,
                          ),
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              String email = emailController.text;
                              String password = passwordController.text;
                              print('All fields are valid');
                              signInUser(context, email, password);
                            } else {
                              print('All fields are not valid');
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15.0.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: const ResponsiveText()
                                  .getadaptiveTextSize(context, 12.sp),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              ' Sign Up',
                              style: GoogleFonts.poppins(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: const ResponsiveText()
                                    .getadaptiveTextSize(context, 12.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
