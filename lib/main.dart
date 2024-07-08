import 'package:dispatched_calculator_app/constants/colors.dart';
import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:dispatched_calculator_app/firebase_options.dart';
import 'package:dispatched_calculator_app/screens/auth_screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferences.getInstance();
  // RequestConfiguration request = RequestConfiguration(testDeviceIds: '');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dispatched Calculator',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              color: AppColor().primaryAppColor,
              iconTheme: AppColor().appDrawerColor),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                  fontFamily: robotoRegular,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              foregroundColor: AppColor().secondaryAppColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                  fontFamily: robotoRegular,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              foregroundColor: AppColor().secondaryAppColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          cardColor: AppColor().appTextColor,
          useMaterial3: true,
          textTheme: TextTheme(
            bodyLarge: const TextStyle(fontFamily: robotoRegular),
            bodyMedium: TextStyle(
                fontFamily: robotoRegular,
                fontSize: 12,
                color: AppColor().secondaryAppColor),
            // bodySmall: TextStyle(fontFamily: 'Raleway'),
          ),
        ),
        home: const SplashScreen());
  }
}
