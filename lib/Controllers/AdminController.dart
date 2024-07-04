import 'package:ecommerce_app/Admin/MainPages/AddCart.dart';
import 'package:ecommerce_app/Admin/MainPages/HomePage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AdminController extends GetxController {
  var selectedIndex = 0.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    HomePage(),
    AddtoCart(),
    AddtoCart(),
    AddtoCart(),
  ];
}
