import 'package:ecommerce_app/Models/SharedPreferencesQuery.dart';
import 'package:ecommerce_app/widgets/DialogBoxes/DialogBox.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final AuthService _authService = AuthService();

  void logout(BuildContext context) async {
    await Get.dialog(
      ConfirmDialog(
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        confirmText: 'Confirm',
        cancelText: 'Cancel',
        onConfirm: () {
          _authService.signOut();
        },
        onCancel: () {
          Get.back();
        },
      ),
    );
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
            Text(
              'John Doe',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'john.doe@example.com',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 30),
            Divider(height: 20, thickness: 2),
            Text(
              'Company Information',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.store, color: Colors.blueAccent),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'UPR Bus Hub is an e-commerce store providing a variety of products ranging from electronics to home decor. Our mission is to offer high-quality products at competitive prices.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.local_shipping, color: Colors.blueAccent),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'We offer reliable and fast shipping services to ensure your products reach you on time.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.support, color: Colors.blueAccent),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Our customer support is available 24/7 to assist you with any queries or issues.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
            Divider(height: 20, thickness: 2),
            Spacer(),
            Elevated_button(
              text: 'Logout',
              color: Colors.white,
              path: () {
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
