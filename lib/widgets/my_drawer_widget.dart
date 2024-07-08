import 'package:dispatched_calculator_app/constants/colors.dart';
import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:dispatched_calculator_app/constants/image_strings.dart';
import 'package:dispatched_calculator_app/controllers/auth_controller.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:dispatched_calculator_app/screens/history_screen/history_screen.dart';
import 'package:dispatched_calculator_app/screens/history_screen/youtube_vedio_screen.dart';
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
                  title: Text('Dashboard',
                      style: TextStyle(
                          fontFamily: robotoRegular,
                          color: AppColor().primaryAppColor,
                          fontSize: 18)),
                  onTap: () {
                    Get.offAll(() => HomeScreen(),
                        transition: Transition.cupertino);
                  },
                ),

                // ListTile(
                //   leading: Icon(
                //     Icons.travel_explore,
                //     color: AppColor().secondaryAppColor,
                //     size: 30,
                //   ),
                //   title: Text('Mileage',
                //       style: TextStyle(
                //           fontSize: 18,
                //           fontFamily: robotoRegular,
                //           color: AppColor().primaryAppColor)),
                //   onTap: () {
                //     Get.to(() => MileageFeSection(
                //         homeController: homeController, isUpdate: true));
                //   },
                // ),
                ListTile(
                  leading: Icon(
                    Icons.calculate,
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
                    Icons.play_circle,
                    color: AppColor().secondaryAppColor,
                    size: 30,
                  ),
                  title: Text('Tutorial',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: robotoRegular,
                          color: AppColor().primaryAppColor)),
                  onTap: () {
                    Get.to(() => TutorialScreen());
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
