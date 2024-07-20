import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Admin/DashboardPages/Cart%20Related/SalesAccordingtoDate.dart';
import 'package:ecommerce_app/Controllers/SeaarchControllers.dart';
import 'package:ecommerce_app/Controllers/totalcostController.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/SharedPreferencesQuery.dart';
import 'InvoiceScreen.dart';

class Userdashboard extends StatelessWidget {
  final AuthService _authService = AuthService();
  final OrderController orderController = Get.put(OrderController());
  void logout() async {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () {
        _authService.signOut();
        Get.offAllNamed('/');
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  final SalesSearchController controller = Get.put(SalesSearchController());
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "BrandWay Foods",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blueGrey,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 13.0),
            child: Elevated_button(
              path: () {
                logout();
              },
              color: Colors.white,
              text: 'Logout',
              radius: 10,
              padding: 10,
              width: 100,
              height: 20,
              backcolor: Colors.red,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(300),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                  ),
                  items: [
                    'assets/images/images1.png',
                    'assets/images/images2.jpg',
                    'assets/images/images3.jpg',
                    'assets/images/images4.jpg',
                    'assets/images/images6.jpg',
                  ].map((String imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Name to search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  onChanged: (value) {
                    controller.searchQuery.value = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Elevated_button(
                text: 'View Sales Per Day',
                path: (){
                  Get.to(SalesBasedOnDate());
                },
                padding: 13,
                width: Get.width,
                height: 40,
                radius: 5,
                color: Colors.white,
                backcolor: Colors.purple,
                fontsize: 18,
              ),
            ),
          ),

          Obx(() {
            if (controller.orders.isEmpty) {
              return Center(child: Text('No Sales Yet'));
            }
            if (controller.filteredOrders.isEmpty) {
              return Center(child: Text('No documents found'));
            }
            return Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: Get.width / (Get.height / 1.8),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.filteredOrders.length,
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  DocumentSnapshot category = controller.filteredOrders[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(InvoiceScreen(userName: category.id));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/images/comp_logo.png', // Logo at the top
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      title: 'User Name:',
                                      size: 16.0,
                                    ),
                                    TextWidget(
                                      title: '${category.id}',
                                      size: 16.0,
                                    ),
                                    SizedBox(height: 8.0),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    ),
    );
  }
}
