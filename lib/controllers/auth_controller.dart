import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/auth_screens/otp_verification_screen.dart';
import '../screens/home_screens/home_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var verificationId = ''.obs;
  var isLoading = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void registerUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+1$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': name,
            'email': email,
            'phone': phone,
          });
          Get.snackbar('Success', 'Registration successful',
              snackPosition: SnackPosition.BOTTOM);
          Get.offAll(() => HomeScreen());
          isLoading.value = false;
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', 'Verification failed. Please try again.',
              snackPosition: SnackPosition.BOTTOM);
          isLoading.value = false;
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;
          Get.to(() => OTPVerificationScreen(
                verificationId: verificationId,
                email: email,
                name: name,
                password: password,
                phone: phone,
              ));
          isLoading.value = false;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'An error occurred. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
    }
  }
  // OTP Method

  void verifyOTP(String otp, String email, String name, String phone,
      String password) async {
    if (otp.isEmpty) {
      Get.snackbar('Error', 'Please enter the OTP',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
      });

      Get.snackbar('Success', 'Registration successful',
          snackPosition: SnackPosition.BOTTOM);
      Get.offAll(() => HomeScreen());
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
    }
  }

  // Login Method

  void loginWithPhoneNumber() async {
    String phone = phoneController.text.trim();

    if (phone.isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      // Query Firestore to check if the phone number exists
      QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      if (userQuery.docs.isNotEmpty) {
        // Phone number exists, initiate phone verification
        await _auth.verifyPhoneNumber(
          phoneNumber: '+1$phone',
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            Get.offAll(() => HomeScreen()); // Navigate to home screen
          },
          verificationFailed: (FirebaseAuthException e) {
            Get.snackbar('Error', 'Verification failed. Please try again.',
                snackPosition: SnackPosition.BOTTOM);
            isLoading.value = false;
          },
          codeSent: (String verificationId, int? resendToken) {
            this.verificationId.value = verificationId;
            Get.to(() => OTPVerificationScreen(
                verificationId: verificationId,
                email: '',
                name: '',
                password: '',
                phone: phone));
            isLoading.value = false;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            this.verificationId.value = verificationId;
          },
        );
      } else {
        // Phone number does not exist in the database
        Get.snackbar('Error', 'Phone number does not exist',
            snackPosition: SnackPosition.BOTTOM);
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
    }
  }

  void verifyLoginOTP(String otp) async {
    if (otp.isEmpty) {
      Get.snackbar('Error', 'Please enter the OTP',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      Get.offAll(() => HomeScreen()); // Navigate to home screen
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
    }
  }
}
