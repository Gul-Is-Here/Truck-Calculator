import 'package:dispatched_calculator_app/constants/colors.dart';
import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:dispatched_calculator_app/constants/image_strings.dart';
import 'package:dispatched_calculator_app/controllers/auth_controller.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:dispatched_calculator_app/screens/history_screen/history_screen.dart';
import 'package:dispatched_calculator_app/screens/history_screen/update_screen.dart';
import 'package:dispatched_calculator_app/screens/home_screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

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
                    Icons.home,
                    color: AppColor().secondaryAppColor,
                    size: 30,
                  ),
                  title: Text('Home Screen',
                      style: TextStyle(
                          fontFamily: robotoRegular,
                          color: AppColor().primaryAppColor,
                          fontSize: 18)),
                  onTap: () {
                    Get.offAll(() => HomeScreen(),
                        transition: Transition.cupertino);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.history,
                    color: AppColor().secondaryAppColor,
                    size: 30,
                  ),
                  title: Text('History',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: robotoRegular,
                          color: AppColor().primaryAppColor)),
                  onTap: () {
                    Get.to(() => HistoryScreen());
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: AppColor().secondaryAppColor,
                    size: 30,
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
