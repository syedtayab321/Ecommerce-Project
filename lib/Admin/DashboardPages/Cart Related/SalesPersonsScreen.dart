import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Admin/DashboardPages/Cart%20Related/InvoiceScreen.dart';
import 'package:ecommerce_app/Controllers/SeaarchControllers.dart';
import 'package:ecommerce_app/Controllers/totalcostController.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryDelete.dart';
import 'package:ecommerce_app/widgets/DialogBoxes/DialogBox.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonGridView extends StatelessWidget {
  final SalesSearchController controller = Get.put(SalesSearchController());
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black87,
        title: TextWidget(
          title: 'Sales', color: Colors.white,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Obx(() {
                  return TextWidget(
                    title: 'Total sales cost: \£${orderController.totalCost.value.toStringAsFixed(2)}',
                    size: 24, color: Colors.white,
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Name or ID to search',
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
      body: Obx(() {
        if (controller.orders.isEmpty) {
          return Center(child: Text('No documents found'));
        }

        if (controller.filteredOrders.isEmpty) {
          return Center(child: Text('No documents found'));
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 3 / 2,
          ),
          itemCount: controller.filteredOrders.length,
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) {
            DocumentSnapshot category = controller.filteredOrders[index];
            final data = category.data() as Map<String, dynamic>;
            final userId = data['userid'] ?? 'Unknown';
            final userName = category.id;
            orderController.fetchAndCalculateTotalCost();
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(InvoiceScreen(userName: userName));
                  },
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 50.0,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'UserName:  $userName\nUser Id:  $userId',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      Get.dialog(
                        ConfirmDialog(
                          title: 'Delete',
                          content: 'Are you sure you want to delete?',
                          confirmText: 'Delete',
                          cancelText: 'Cancel',
                          confirmColor: Colors.red,
                          cancelColor: Colors.black87,
                          onConfirm: () {
                            deletePersonData(userName);
                            Get.back();
                          },
                          onCancel: () {
                            Get.back();
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.delete_forever),
                    color: Colors.red,
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
