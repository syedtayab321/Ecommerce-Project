import 'dart:async';
import 'package:ecommerce_app/Admin/Dashboard.dart';
import 'package:ecommerce_app/Models/Authentication.dart';
import 'package:ecommerce_app/Models/AuthenticationModel.dart';
import 'package:ecommerce_app/User/UserDashboard.dart';
import 'package:ecommerce_app/welcome.dart';
import 'package:ecommerce_app/widgets/Snakbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? uid = await _authService.getUserFromPreferences();
    if (uid != null) {
      UserModel? userModel = await _authService.getUserRole(uid);
      if (userModel != null) {
        if (userModel.role == 'Admin') {
          Timer(Duration(seconds: 5), () {
            Get.off(() => AdminDashboard(),
                transition: Transition.fadeIn, duration: Duration(seconds: 2));
          });
        } else if(userModel.role == 'User') {
          Timer(Duration(seconds: 5), () {
            Get.off(() => Userdashboard(),
                transition: Transition.fadeIn, duration: Duration(seconds: 2));
          });
        }
      }
      else
        {
          showErrorSnackbar(uid);
        }
    } else {
      Timer(Duration(seconds: 5), () {
        Get.off(() => Welcome(),
            transition: Transition.fadeIn, duration: Duration(seconds: 2));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(
                      0.64), // Adjust the opacity value to change brightness
                  BlendMode.multiply,
                ),
                child: Image.asset(
                  "assets/images/wellcome.jpg",
                  fit: BoxFit.cover,
                  height: Get.height,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    color: Color.fromARGB(255, 209, 207, 207),
                    width: 200,
                  ),
                ),
                Spacer(
                  flex: 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
