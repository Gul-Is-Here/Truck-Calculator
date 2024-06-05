import 'package:dispatched_calculator_app/constants/image_strings.dart';
import 'package:dispatched_calculator_app/screens/auth_screens/login_screen.dart';
import 'package:dispatched_calculator_app/screens/home_screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    User? user = _auth.currentUser;
    if (user != null) {
      Get.off(() => HomeScreen()); // User is signed in, navigate to home screen
    } else {
      Get.off(() =>
          LoginScreen()); // No user is signed in, navigate to login screen
    }
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
