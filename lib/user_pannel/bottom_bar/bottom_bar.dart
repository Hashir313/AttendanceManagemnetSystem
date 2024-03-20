import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:attendance_management_system/user_pannel/screens/home/user_home_screen.dart';
import 'package:attendance_management_system/user_pannel/screens/profile/user_profile_screen.dart';
import 'package:attendance_management_system/utils/colors.dart';
import 'package:attendance_management_system/utils/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../add_attendance/add_attendance.dart';

class UserBottomBar extends StatefulWidget {
  const UserBottomBar({super.key});

  @override
  State<UserBottomBar> createState() => _UserBottomBarState();
}

class _UserBottomBarState extends State<UserBottomBar> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const UserHomeScreen(),
    const MarkAttendance(),
    const UserProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
              bottomBarPages.length, (index) => bottomBarPages[index]),
        ),
        extendBody: true,
        bottomNavigationBar: (bottomBarPages.length <= maxCount)
            ? AnimatedNotchBottomBar(
                notchBottomBarController: _controller,
                color: primaryColor,
                notchColor: primaryColor,
                itemLabelStyle: GoogleFonts.poppins(
                  fontSize: const ResponsiveText()
                      .getadaptiveTextSize(context, 8.0.sp),
                  color: whiteColor,
                ),
                kBottomRadius: 28.0,
                bottomBarItems: const [
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.home_filled,
                      color: whiteColor,
                    ),
                    activeItem: Icon(
                      Icons.home_filled,
                      color: secondaryColor,
                    ),
                    itemLabel: 'Dashboard',
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.add_task,
                      color: whiteColor,
                    ),
                    activeItem: Icon(
                      Icons.add_task,
                      color: secondaryColor,
                    ),
                    itemLabel: 'Mark',
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.account_circle,
                      color: whiteColor,
                    ),
                    activeItem: Icon(
                      Icons.account_circle,
                      color: secondaryColor,
                    ),
                    itemLabel: 'My Profile',
                  ),
                ],
                onTap: (index) {
                  /// perform action on tab change and to update pages you can update pages without pages
                  // log('current selected index $index');
                  _pageController.jumpToPage(index);
                },
                kIconSize: 24.0,
              )
            : null,
      ),
    );
  }
}
