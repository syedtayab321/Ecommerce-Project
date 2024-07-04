import 'package:ecommerce_app/User/UserLogin.dart';
import 'package:ecommerce_app/widgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/Icon_Button.dart';
import 'package:ecommerce_app/widgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
            'assets/images/back.jpg', // Ensure you have the background image in your assets folder
            fit: BoxFit.cover,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.black38,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(title:'Discover\nthe best lovely\nProducts!' ,
                        color: Colors.white,
                        size: 38,
                        weight: FontWeight.w500,
                      ),
                      SizedBox(height: 10),
                      TextWidget(title:'Let Make it Easy to Business' ,
                          color: Colors.white,
                          size: 18,
                      ),
                      SizedBox(height: 30),
                      Elevated_button(text: 'Click To Logged In', color: Colors.black, radius: 10, padding: 20, fontsize: 18,
                          path:(){
                            Get.to(Userlogin());
                          },
                          width: double.infinity,
                          height: 60,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon_Button(
                              icon: Icon(Icons.facebook),
                              onPressed: (){},
                              color: Colors.white
                          ),
                          SizedBox(width: 20,),
                          Icon_Button(
                              icon: Icon(Icons.g_translate_outlined),
                              onPressed: (){},
                              color: Colors.white
                          ),
                          SizedBox(width: 20,),
                          Icon_Button(
                              icon: Icon(Icons.account_balance_wallet),
                              onPressed: (){},
                              color: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
