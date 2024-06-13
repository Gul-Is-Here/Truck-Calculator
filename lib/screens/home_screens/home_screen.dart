import 'package:dispatched_calculator_app/app_classes/app_class.dart';
import 'package:dispatched_calculator_app/constants/colors.dart';
import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:dispatched_calculator_app/screens/calculator_screen/calculator_screen.dart';
import 'package:dispatched_calculator_app/screens/history_screen/history_details_screen.dart';
import 'package:dispatched_calculator_app/screens/history_screen/update_screen.dart';
import 'package:dispatched_calculator_app/screens/load_screen/load_screen.dart';
import 'package:dispatched_calculator_app/widgets/card_widget.dart';
import 'package:dispatched_calculator_app/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../history_screen/history_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  var homeController = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            20.heightBox,
            Center(
                child: Text(
              AppClass().getGreeting(),
              style: TextStyle(
                  fontFamily: robotoRegular,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            )),
            20.heightBox,
            CardWidget(
              onTap: () {
                Get.to(() => UpdateScreen(
                      homeController: homeController,
                      isUpdate: true,
                    ));
              },
              butonText: 'Update',
              cardText:
                  'This is a calculator where you can calculate your expanses',
              cardColor: AppColor().primaryAppColor,
            ),
            10.heightBox,
            CardWidget(
              onTap: () {
                Get.to(() => LoadScreen(
                      homeController: homeController,
                      isUpdate: false,
                    ));
              },
              butonText: 'Calculator',
              cardText:
                  'This is a calculator where you can calculate your expanses',
              cardColor: AppColor().secondaryAppColor,
            ),
            10.heightBox,
            CardWidget(
              onTap: () {
                // print(homeController.newDocumentId);

                Get.to(() => HistoryScreen(), transition: Transition.fadeIn);
              },
              butonText: 'History',
              cardText:
                  'This is a calculator where you can calculate your expanses',
              cardColor: AppColor().primaryAppColor,
            ),
          ],
        ),
      ),
    );
  }
}
