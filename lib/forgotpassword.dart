import 'package:ecommerce_app/Controllers/forgotPasswordController.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/OtherWidgets/ElevatedButton.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(title: 'Forgot Password',color: Colors.white,),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                  Elevated_button(
                    text: 'Reset Password',
                    path: controller.resetPassword,
                    padding: 13,
                    width: 200,
                    height: 40,
                    radius: 10,
                    color: Colors.white,
                    backcolor: Colors.purple,
                    fontsize: 18,
                  ),
                    SizedBox(height: 16),
                    Obx(() => Text(
                      controller.message.value,
                      style: TextStyle(color: Colors.red),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
