import 'package:ecommerce_app/Controllers/AdminController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class AdminDashboard extends StatelessWidget {
  final AdminController _controller = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return _controller.pages[_controller.selectedIndex.value];
      }),
      bottomNavigationBar: Obx(() {
        return ConvexAppBar(
          backgroundColor: Colors.white,
          color: Colors.grey,
          activeColor: Colors.orange,
          style: TabStyle.reactCircle,
          items: [
            TabItem(icon: Icons.store, title: 'Shop'),
            TabItem(icon: Icons.category, title: 'Category'),
            TabItem(icon: Icons.shopping_cart, title: 'Cart'),
            TabItem(icon: Icons.person, title: 'Profile'),
          ],
          initialActiveIndex: _controller.selectedIndex.value,
          onTap: _controller.onItemTapped,
        );
      }),
    );
  }
}
