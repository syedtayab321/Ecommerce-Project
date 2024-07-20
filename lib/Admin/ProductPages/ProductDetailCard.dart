import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Admin/DashboardPages/Cart%20Related/CartScreen.dart';
import 'package:ecommerce_app/Admin/ProductPages/AddtoCartQuery.dart';
import 'package:ecommerce_app/Admin/ProductPages/ProductUpdate.dart';
import 'package:ecommerce_app/Controllers/ImageController.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryDelete.dart';
import 'package:ecommerce_app/widgets/DialogBoxes/DialogBox.dart';
import 'package:ecommerce_app/widgets/DialogBoxes/ProductDialog.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsCard extends StatelessWidget {
  final String MainCategory, SubCategory;
  final String? userName;
  final String? address;
  final String? userid;

  ProductDetailsCard({
    Key? key,
    required this.MainCategory,
    required this.SubCategory,
    this.userName,
    this.address,
    this.userid,
  }) : super(key: key);
  final ImagePickerController imageController = Get.put(ImagePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          title: SubCategory,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(userName == null
                  ? CartScreen(userName: userName, userid: userid, address: address)
                  : CartScreen());
            },
            icon: Icon(Icons.add_shopping_cart),
          ),
          SizedBox(width: 20),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Elevated_button(
              path: () {
                Get.dialog(ProductDialog(
                  MainCategory: this.MainCategory,
                  SubCategory: this.SubCategory,
                ));
              },
              color: Colors.white,
              text: 'Add',
              radius: 7,
              padding: 10,
              width: 100,
              height: 40,
              backcolor: Colors.black87,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('MainCategories')
            .doc(MainCategory)
            .collection('subcategories')
            .doc(SubCategory)
            .collection('Products')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No products available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var ProductData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                int stock = int.parse(ProductData['Stock'].toString());
                double price = double.parse(ProductData['Price']);
                return Card(
                  color: Colors.lightBlue,
                  elevation: 8.0,
                  margin: EdgeInsets.all(12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            ProductData['Image Url'],
                            fit: BoxFit.cover,
                            height: 550,
                            width: double.infinity,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          ProductData['name'],
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              stock <= 0 ? 'Out of Stock' : 'Stock:  $stock',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: stock > 0 ? Colors.white : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Price:  £${price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.0),
                        TextWidget(
                          title: 'Expiry Date: ${ProductData['ExpiryDate']}',
                          color: Colors.white,
                          size: 17,
                        ),
                        SizedBox(height: 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Elevated_button(
                              path: () {
                                imageController.imagedata.value = null;
                                showUpdateProductSheet(context, MainCategory, SubCategory, ProductData);
                              },
                              color: Colors.green,
                              text: 'Update',
                              radius: 7,
                              padding: 10,
                              width: 100,
                              height: 40,
                              backcolor: Colors.white,
                            ),
                            Elevated_button(
                              path: () {
                                stock <= 0
                                    ? showErrorSnackbar('Product is out of stock')
                                    : Get.dialog(QuantitySelector(
                                  priceperitem: price,
                                  categoryName: SubCategory,
                                  stock: stock,
                                  MainCategory: MainCategory,
                                  ProductName: ProductData['name'],
                                  userName: this.userName,
                                  userid: this.userid,
                                  address: this.address,
                                ));
                              },
                              color: Colors.white,
                              text: 'Add to cart',
                              radius: 10,
                              padding: 10,
                              width: 110,
                              height: 40,
                              backcolor: Colors.green,
                            ),
                            Elevated_button(
                              path: () {
                                Get.dialog(ConfirmDialog(
                                  title: 'Delete',
                                  content: 'Are You Sure You want to Delete',
                                  confirmText: 'Confirm',
                                  cancelText: 'Cancel',
                                  confirmColor: Colors.red,
                                  cancelColor: Colors.green,
                                  onConfirm: () {
                                    deleteProduct(MainCategory, SubCategory, ProductData['name']);
                                    Get.back();
                                  },
                                  onCancel: () {
                                    Get.back();
                                  },
                                ));
                              },
                              color: Colors.white,
                              text: 'Delete',
                              radius: 7,
                              padding: 10,
                              width: 100,
                              height: 40,
                              backcolor: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
