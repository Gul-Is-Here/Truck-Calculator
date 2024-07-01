// import 'package:background_fetch/background_fetch.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:dispatched_calculator_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dispatched_calculator_app/constants/image_strings.dart';
import 'package:dispatched_calculator_app/screens/auth_screens/login_screen.dart';
import 'package:dispatched_calculator_app/screens/home_screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();

    FirebaseServices().transferAndDeleteWeeklyData();
  }

  // void initBackgroundFetch() {
  //   BackgroundFetch.configure(
  //     BackgroundFetchConfig(
  //       minimumFetchInterval: 1440, // Daily fetch interval (1440 minutes)
  //       startOnBoot: true,
  //       stopOnTerminate: false,
  //       enableHeadless: true,
  //     ),
  //     (String taskId) async {
  //       DateTime now = DateTime.now();
  //       // Check if today is Monday
  //       if (now.weekday == DateTime.monday) {
  //         await FirebaseServices().transferAndDeleteWeeklyData();
  //       }
  //       BackgroundFetch.finish(taskId);
  //     },
  //   ).then((int status) {
  //     print('BackgroundFetch configure success: $status');
  //   }).catchError((e) {
  //     print('BackgroundFetch configure error: $e');
  //   });
  // }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    User? user = _auth.currentUser;
    if (user != null) {
      Get.offAll(
          () => HomeScreen()); // User is signed in, navigate to home screen
    } else {
      Get.offAll(() =>
          LoginScreen()); // No user is signed in, navigate to login screen
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Are you sure you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                appLogo,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
