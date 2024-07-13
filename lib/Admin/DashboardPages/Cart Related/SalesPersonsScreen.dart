import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Admin/DashboardPages/Cart%20Related/InvoiceScreen.dart';
import 'package:ecommerce_app/Controllers/SeaarchControllers.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryDelete.dart';
import 'package:ecommerce_app/widgets/DialogBoxes/DialogBox.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonGridView extends StatelessWidget {
  final SalesSearchController controller = Get.put(SalesSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextWidget(
          title: 'Sales',
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter CNIC to search',
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
        ),
      ),
      body: Obx(() {
        if (controller.orders.isEmpty) {
          return Center(child: CircularProgressIndicator());
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
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(InvoiceScreen(userCnic: category.id));
                  },
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
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
                          'User CNIC: ${category.id}',
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
                      Get.dialog(ConfirmDialog(
                          title: 'Delete',
                          content: 'Are you sure you want to delete ',
                          confirmText: 'Delete',
                          cancelText: 'Cancel',
                          confirmColor: Colors.red,
                          cancelColor: Colors.black87,
                          onConfirm: (){
                            deletePersonData(category.id);
                          },
                          onCancel: (){
                            Get.back();
                          },
                      ),
                      );
                    }, icon: Icon(Icons.delete_forever),color: Colors.red,),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
