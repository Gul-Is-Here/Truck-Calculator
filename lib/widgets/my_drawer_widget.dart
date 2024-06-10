import 'package:dispatched_calculator_app/controllers/auth_controller.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:dispatched_calculator_app/screens/history_screen/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawerWidget extends StatelessWidget {
  MyDrawerWidget({super.key});
  final homeController = HomeController();
  final authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Get.to(
                          () => HistoryScreen(homeController: homeController));
                    },
                    child: Text('History Screen')),
                ElevatedButton(
                    onPressed: authController.signOut, child: Text('LogOut')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
