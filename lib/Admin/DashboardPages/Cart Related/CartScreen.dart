import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/FirebaseCruds/BuyNowAddition.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/Admin/DashboardPages/Cart%20Related/CartDetailsCard.dart';

class CartScreen extends StatelessWidget {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _cnicController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Cart Data')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No Data Available'));
          }
          final docs = snapshot.data!.docs;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return CartItemCard(
                      itemName: data['Product Name'],
                      itemPrice: data['Total Price'] / data['Selected quantity'],
                      selectedQuantity: data['Selected quantity'],
                      totalPrice: data['Total Price'],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Elevated_button(
                  path: () {
                    Get.dialog(AlertDialog(
                      title: Text('Enter User Details'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              hintText: 'Enter your username',
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _cnicController,
                            decoration: InputDecoration(
                              labelText: 'CNIC',
                              hintText: 'Enter your CNIC',
                            ),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        Elevated_button(
                            text: 'Cancel',
                            color: Colors.black87,
                            backcolor: Colors.white,
                            padding: 10,
                            width: 120,
                            height: 30,
                            radius: 10,
                            path: () {
                              Get.back();
                            }),
                        Elevated_button(
                            text: 'Buy Now',
                            color: Colors.white,
                            backcolor: Colors.black87,
                            padding: 10,
                            width: 120,
                            height: 30,
                            radius: 10,
                            path: () {
                              if (_usernameController.text.isNotEmpty && _cnicController.text.isNotEmpty) {
                                addBuyNow(_usernameController.text, _cnicController.text);
                              } else {
                                showErrorSnackbar('Please fill all the fields');
                              }
                            }),
                      ],
                    ));
                  },
                  text: 'Buy Now',
                  padding: 10,
                  width: 350,
                  height: 50,
                  radius: 12,
                  color: Colors.white,
                  backcolor: Colors.green,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
