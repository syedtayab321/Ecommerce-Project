import 'package:ecommerce_app/Admin/Dashboard.dart';
import 'package:ecommerce_app/widgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/Icon_Button.dart';
import 'package:ecommerce_app/widgets/Snakbar.dart';
import 'package:ecommerce_app/widgets/TextFormField.dart';
import 'package:ecommerce_app/widgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Userlogin extends StatefulWidget {
  const Userlogin({super.key});

  @override
  State<Userlogin> createState() => _UserloginState();
}

class _UserloginState extends State<Userlogin> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordControlller = TextEditingController();
  final _fixedemail = "admin321@gmail.com";
  final _fixedpassword = "123456";

  void login() {
    try {
        String email = _emailController.text;
        String password = _passwordControlller.text;

        if (email == _fixedemail && password == _fixedpassword) {
          showSuccessSnackbar("Login sucessfull! Congragulations");
          Get.off(AdminDashboard());
        } else if (email == _fixedemail && password != _fixedpassword) {
          showErrorSnackbar("Password not correct try agian");
        } else if (email != _fixedemail && password == _fixedpassword) {
          showErrorSnackbar("Email id not correct try agian");
        } else if (email != _fixedemail && password != _fixedpassword) {
          showErrorSnackbar("Both cridentials are Wrong");
        }
    } catch (e) {
      showErrorSnackbar("unexpected error occur");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Image(
          image: AssetImage('assets/images/back.jpg'),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 8.0,
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      title: "Let's sign you in",
                      size: 24,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(height: 8),
                    TextWidget(
                      title: "Welcome back,\nYou've been missed!",
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    SizedBox(height: 32),
                    ResuableTextField(
                      type: TextInputType.text,
                      label: "Email",
                      prefixicon: Icon(
                        Icons.email,
                        color: Colors.black38,
                      ),
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ResuableTextField(
                      type: TextInputType.text,
                      label: "Password",
                      prefixicon: Icon(Icons.password),
                      suffixicon: Icon_Button(
                        onPressed: () {},
                        icon: Icon(Icons.remove_red_eye),
                      ),
                      controller: _passwordControlller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Handle "Forgot Password?"
                        },
                        child: TextWidget(
                          title: "Forgot Password",
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Elevated_button(
                        text: "log In",
                        color: Colors.white,
                        padding: 8.0,
                        fontsize: 16,
                        radius: 12,
                        backcolor: Colors.black,
                        path: login,
                        width: double.infinity,
                        height: 60,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextWidget(
                      title: "Welcome to Our App",
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
