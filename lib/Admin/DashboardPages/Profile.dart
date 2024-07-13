import 'package:ecommerce_app/Models/SharedPreferencesQuery.dart';
import 'package:ecommerce_app/widgets/DialogBoxes/DialogBox.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
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
        automaticallyImplyLeading: false,
        title: Text('Profile'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(
              title: 'BrandWay Food Ltd',
                size: 28,
                weight: FontWeight.bold,
                color: Colors.blueAccent,
            ),
            SizedBox(height: 10),
            TextWidget(
              title: 'admin321@example.com',
              size: 18,
              color: Colors.grey[700],
            ),
            SizedBox(height: 30),
            Divider(height: 20, thickness: 2),
            TextWidget(
              title: 'Company Information',
              size: 22,
                weight: FontWeight.bold,
                color: Colors.blueAccent,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.store, color: Colors.blueAccent),
                SizedBox(width: 10),
                Expanded(
                  child: TextWidget(
                    title: 'Brand Way Food is an e-commerce store providing a variety of products ranging from electronics to home decor. Our mission is to offer high-quality products at competitive prices.',
                    size: 18, color: Colors.grey[800]),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.local_shipping, color: Colors.blueAccent),
                SizedBox(width: 10),
                Expanded(
                  child: TextWidget(
                    title: 'We offer reliable and fast shipping services to ensure your products reach you on time.',
                    size: 18, color: Colors.grey[800]
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
                  child: TextWidget(
                    title: 'Our customer support is available 24/7 to assist you with any queries or issues.',
                    size: 18, color: Colors.grey[800]
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
