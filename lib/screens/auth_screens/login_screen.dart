import 'package:dispatched_calculator_app/app_classes/app_class.dart';
import 'package:dispatched_calculator_app/constants/image_strings.dart';
import 'package:dispatched_calculator_app/controllers/auth_controller.dart';
import 'package:dispatched_calculator_app/screens/auth_screens/otp_verification_screen.dart';
import 'package:dispatched_calculator_app/screens/auth_screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80),
                  Image.asset(
                    appLogo,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 30),
                  Text(
                    AppClass().getGreeting(),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please login with your phone number',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: controller.phoneController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(height: 30),
                  Obx(() => controller.isLoading.value
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => controller.loginWithPhoneNumber(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: EdgeInsets.symmetric(
                                horizontal: 100, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => RegisterScreen());
                    },
                    child: Text(
                      'Don\'t have an account? Register',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
