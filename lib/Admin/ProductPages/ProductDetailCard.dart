import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryDelete.dart';
import 'package:ecommerce_app/widgets/DialogBox.dart';
import 'package:ecommerce_app/widgets/ProductDialog.dart';
import 'package:ecommerce_app/widgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsCard extends StatelessWidget {
  final String imageUrl;
  final String MainCategory, SubCategory;
  final double price;
  final int stock;

  const ProductDetailsCard({
    Key? key,
    required this.imageUrl,
    required this.MainCategory,
    required this.SubCategory,
    required this.price,
    required this.stock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          title: 'Categories',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 13.0),
            child: Elevated_button(
              path: () => {
                Get.dialog(ProductDialog(
                  MainCategory: this.MainCategory,
                  SubCategory: this.SubCategory,
                )),
              },
              color: Colors.white,
              text: 'Add',
              radius: 10,
              padding: 10,
              width: 100,
              height: 20,
              backcolor: Colors.green,
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
                var ProductData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15.0)),
                            child: Image.asset(
                              imageUrl,
                              fit: BoxFit.cover,
                              height: 150.0,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  ProductData['name'],
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Price:${ProductData['Price']}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Stock:${ProductData['Stock']}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color:
                                        stock > 0 ? Colors.black : Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0,right: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(title: 'Expiray Date'),
                                TextWidget(title: '${ProductData['ExpiryDate']}',color: Colors.red,)
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Elevated_button(
                                path: () {},
                                color: Colors.green,
                                text: 'Update',
                                radius: 7,
                                padding: 10,
                                width: 100,
                                height: 20,
                                backcolor: Colors.white,
                              ),
                              Elevated_button(
                                path: () {},
                                color: Colors.white,
                                text: 'Add to cart',
                                radius: 10,
                                padding: 10,
                                width: 110,
                                height: 20,
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
                                    onConfirm: (){
                                      deleteProduct(MainCategory, SubCategory, ProductData['name']);
                                      Get.back();
                                    },
                                    onCancel: ()=>Get.back(),
                                  ),
                                  );

                                },
                                color: Colors.white,
                                text: 'Delete',
                                radius: 7,
                                padding: 10,
                                width: 100,
                                height: 20,
                                backcolor: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
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
