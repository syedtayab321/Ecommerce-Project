import 'package:ecommerce_app/Controllers/LoginController.dart';
import 'package:ecommerce_app/Controllers/PasswordController.dart';
import 'package:ecommerce_app/forgotpassword.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Icon_Button.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextFormField.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Userlogin extends StatefulWidget {
  const Userlogin({super.key});

  @override
  State<Userlogin> createState() => _UserloginState();
}

class _UserloginState extends State<Userlogin> {
  final LoginController loginController = Get.put(LoginController());
  final Password_controller _visibilityController=Get.put(Password_controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    TextWidget(
                      title: 'Ecommerce',
                        color: Colors.purple,
                        size: 24,
                        weight: FontWeight.bold,
                        spacing: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    TextWidget(
                      title: 'BrandWay Food Ltd',
                        size: 24,
                        weight: FontWeight.bold,

                    ),
                    SizedBox(height: 8),
                    TextWidget(
                      title: 'Welcome to BrandWay Food Ltd',
                        size: 18,
                    ),
                    SizedBox(height: 8),
                    TextWidget(
                      title: 'Before Continue, Please Sign in First.',
                        size: 16,
                        color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/images/login.png',
                  height: 200,
                ),
              ),
              SizedBox(height: 30),
              ResuableTextField(
                  type: TextInputType.text,
                  label: 'E-mail',
                  controller: loginController.emailController,
              ),
              SizedBox(height: 20),
              Obx((){
                return ResuableTextField(
                    type: TextInputType.text,
                    label: 'Password',
                    controller: loginController.passwordController,
                    value: _visibilityController.show.value,
                    suffixicon: Icon_Button(
                       onPressed: (){
                         _visibilityController.show_password();
                       },
                      icon: _visibilityController.show.value==true?Icon(Icons.remove_red_eye_outlined):Icon(Icons.remove_red_eye),
                    ),
                );
              }),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: false,
                    onChanged: (bool? value) {},
                  ),
                  Text('Remember Me'),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.to(ForgotPasswordPage());
                    },
                    child: Text('Forgot Password?'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Obx((){
                 return loginController.isLoading.value?Center(child: CircularProgressIndicator()):
                 Elevated_button(
                   text: 'LOGIN',
                   path: loginController.login,
                   padding: 13,
                   width: Get.width,
                   height: 40,
                   radius: 5,
                   color: Colors.white,
                   backcolor: Colors.purple,
                   fontsize: 18,
                 );
              }),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Have A Nice Day",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
