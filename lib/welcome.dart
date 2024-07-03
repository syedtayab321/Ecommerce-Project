import 'package:ecommerce_app/User/UserLogin.dart';
import 'package:ecommerce_app/widgets/elevatedbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/back.jpg', // Your background image
            fit: BoxFit.cover,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                      Text("Welcome to Ecommerce Store",style: TextStyle(
                         color: Colors.white,
                         fontSize: 24
                      ),),
                      CustomButton(
                        text: 'User Logged in',
                        onPressed: (){
                          Get.to(Userlogin());
                        },
                      ),
                  CustomButton(
                    text: 'User Logged in',
                    onPressed: (){
                      Get.to(Userlogin());
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
