import 'package:ecommerce_app/Models/SharedPreferencesQuery.dart';
import 'package:ecommerce_app/widgets/DialogBox.dart';
import 'package:ecommerce_app/widgets/ElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final AuthService _authService = AuthService();

  void logout(BuildContext context) async {
     await Get.dialog(ConfirmDialog(
         title: 'Logout',
         content: 'Are you sure You want to Logout',
         confirmText: 'Confirm',
         cancelText: 'Cancel',
         onConfirm: (){
           _authService.signOut();
         },
        onCancel: (){
           Get.back();
        },
     ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/user_avatar.png'),
            ),
            SizedBox(height: 20),
            Text(
              'John Doe',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'john.doe@example.com',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Divider(height: 20, thickness: 1),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Account Settings'),
                    onTap: () {
                      // Handle account settings navigation
                      // Example: Get.toNamed('/account_settings');
                    },
                  ),
                  Divider(height: 20, thickness: 1),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text('Order History'),
                    onTap: () {
                      // Handle order history navigation
                      // Example: Get.toNamed('/order_history');
                    },
                  ),
                  Divider(height: 20, thickness: 1),
                  ListTile(
                    leading: Icon(Icons.policy),
                    title: Text('Privacy Policy'),
                    onTap: () {
                      // Handle privacy policy navigation
                      // Example: Get.toNamed('/privacy_policy');
                    },
                  ),
                  Divider(height: 20, thickness: 1),
                ],
              ),
            ),
            Elevated_button(
                text: 'Logout',
                color: Colors.white,
                path: (){
                  logout(context);
                },
              padding: 12,
              radius: 10,
              width: Get.width,
              height: 50,
              backcolor: Colors.red,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
