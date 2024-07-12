import 'package:ecommerce_app/Admin/DashboardPages/Cart%20Related/CartScreen.dart';
import 'package:ecommerce_app/Admin/DashboardPages/Cart%20Related/SalesPersonsScreen.dart';
import 'package:ecommerce_app/Admin/DashboardPages/HomePage.dart';
import 'package:ecommerce_app/Admin/DashboardPages/Profile.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AdminController extends GetxController {
  var selectedIndex = 0.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    HomePage(),
    PersonGridView(),
    CartScreen(),
    ProfilePage(),
  ];
}
