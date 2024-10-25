import 'package:dispatched_calculator_app/constants/colors.dart';
import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:dispatched_calculator_app/constants/image_strings.dart';
import 'package:dispatched_calculator_app/controllers/auth_controller.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:dispatched_calculator_app/screens/history_screen/history_screen.dart';
import 'package:dispatched_calculator_app/screens/history_screen/tutorial_screen.dart';
import 'package:dispatched_calculator_app/screens/home_screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../screens/charts_screen/analytics_screen.dart';

class MyDrawerWidget extends StatelessWidget {
  MyDrawerWidget({super.key});
  final homeController = HomeController();
  final authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * .6,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                35.heightBox,
                Image.asset(
                  appLogo1,
                  width: 200,
                ),
                10.heightBox,
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.dashboard_customize_outlined,
                    color: AppColor().secondaryAppColor,
                    size: 30,
                  ),
                  title: Text('Dashboard',
                      style: TextStyle(
                          fontFamily: robotoRegular,
                          color: AppColor().primaryAppColor,
                          fontSize: 18)),
                  onTap: () {
                    Get.off(() => const HomeScreen(),
                        transition: Transition.cupertino);
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    historyIcon,
                    height: 25,
                    color: AppColor().secondaryAppColor,
                  ),
                  title: Text('History',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: robotoRegular,
                          color: AppColor().primaryAppColor)),
                  onTap: () {
                    Get.off(() => const HistoryScreen());
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.play_circle_outline_outlined,
                    color: AppColor().secondaryAppColor,
                    size: 25,
                  ),
                  title: Text('Tutorial',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: robotoRegular,
                          color: AppColor().primaryAppColor)),
                  onTap: () {
                    Get.off(() => const TutorialScreen());
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    chartIcon,
                    height: 25,
                    color: AppColor().secondaryAppColor,
                  ),
                  title: Text('Chart',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: robotoRegular,
                          color: AppColor().primaryAppColor)),
                  onTap: () {
                    Get.off(() => CombinedAnalyticsScreen());
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout_outlined,
                    color: AppColor().secondaryAppColor,
                    size: 25,
                  ),
                  title: Text('LogOut',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: robotoRegular,
                          color: AppColor().primaryAppColor)),
                  onTap: authController.signOut,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
