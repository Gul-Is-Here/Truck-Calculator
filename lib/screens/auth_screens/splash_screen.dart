import 'package:dispatched_calculator_app/constants/image_strings.dart';
import 'package:dispatched_calculator_app/screens/home_screens/home_screen.dart';
import 'package:dispatched_calculator_app/screens/home_screens/smaple.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {
      Get.to(() => HomeScreen());
    }); // Adjust the duration as needed
    // Adjust the route name as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      body: Center(
        child: Image.asset(
          appLogo,
          width: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
