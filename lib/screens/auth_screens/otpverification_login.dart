import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class OTPVerificationLoginScreen extends StatelessWidget {
  final String verificationId;
  final String phone;

  OTPVerificationLoginScreen({
    required this.verificationId,
    required this.phone,
  });

  final AuthController authController = Get.find();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  void verifyOTP() {
    String otp =
        _otpControllers.map((controller) => controller.text.trim()).join();
    authController.verifyOTP(otp, isLogin: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'OTP Verification',
                style: TextStyle(
                  fontFamily: robotoRegular,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Enter the OTP sent to your phone number',
                style: TextStyle(
                  fontFamily: robotoRegular,
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  // ignore: sized_box_for_whitespace
                  return Container(
                    width: MediaQuery.of(context).size.width * .14,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 20),
                        onChanged: (value) {
                          if (value.length == 1 && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          } else if (value.length == 1 && index == 5) {
                            _focusNodes[index].unfocus();
                          } else if (value.length == 0 && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 40),
              Obx(() => authController.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: verifyOTP,
                      child: Text('Verify OTP'),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
