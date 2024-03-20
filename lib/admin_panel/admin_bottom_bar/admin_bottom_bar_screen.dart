import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:attendance_management_system/admin_panel/home/admin_home_screen.dart';
import 'package:attendance_management_system/admin_panel/leave_approval/leave_approval_screen.dart';
import 'package:attendance_management_system/user_pannel/screens/profile/user_profile_screen.dart';
import 'package:attendance_management_system/utils/colors.dart';
import 'package:attendance_management_system/utils/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../attendance_report_screen/attendance_report_screen.dart';

class AdminBottomBar extends StatefulWidget {
  const AdminBottomBar({super.key});

  @override
  State<AdminBottomBar> createState() => _AdminBottomBarState();
}

class _AdminBottomBarState extends State<AdminBottomBar> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const AdminHomeScreen(),
    const AttendanceReportScreen(),
    const LeaveApprovalScreen(),
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
                      Icons.list,
                      color: whiteColor,
                    ),
                    activeItem: Icon(
                      Icons.list,
                      color: secondaryColor,
                    ),
                    itemLabel: 'List',
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.airline_seat_flat_angled_sharp,
                      color: whiteColor,
                    ),
                    activeItem: Icon(
                      Icons.airline_seat_flat_angled_sharp,
                      color: secondaryColor,
                    ),
                    itemLabel: 'Leave',
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
