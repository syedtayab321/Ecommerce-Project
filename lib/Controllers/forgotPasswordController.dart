import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  var message = ''.obs;

  void resetPassword() async {
    if (emailController.text.isEmpty) {
      message.value = "Please enter your email.";
      return;
    }

    // Show loading dialog
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      message.value = "Password reset email sent!";
    } catch (e) {
      message.value = "Error: ${e.toString()}";
    } finally {
      Get.back(); // Close loading dialog
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
