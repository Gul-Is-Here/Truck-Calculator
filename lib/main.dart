import 'package:dispatched_calculator_app/firebase_options.dart';
import 'package:dispatched_calculator_app/screens/auth_screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Dispatched Calculator',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontFamily: 'Raleway'),
            bodyMedium: TextStyle(fontFamily: 'Raleway-Bold'),
            // bodySmall: TextStyle(fontFamily: 'Raleway'),
          ),
        ),
        home: const SplashScreen());
  }
}
