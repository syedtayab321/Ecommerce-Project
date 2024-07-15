import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Controllers/AddToCartController.dart';
import 'package:ecommerce_app/FirebaseCruds/BuyNowAddition.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/Admin/DashboardPages/Cart%20Related/CartDetailsCard.dart';

class CartScreen extends StatelessWidget {
  TextEditingController NameController = new TextEditingController();
  TextEditingController AddressController = new TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  CounterController _counterController = Get.put(CounterController());
  double Totalprice = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Cart Data').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.docs.length == 0) {
            return Center(child: Text('No Data Available'));
          } else {
            final docs = snapshot.data!.docs;
            Totalprice = docs.fold(0, (sum, doc) {
              final data = doc.data() as Map<String, dynamic>;
              return sum + (data['Total Price'] ?? 0.0);
            });
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      for (int i = 0; i == docs.length; i++) {
                        Totalprice += data['Total Price'];
                      }
                      return CartItemCard(
                        totalprice: data['Total Price'],
                        itemName: data['Product Name'],
                        selectedQuantity: data['Selected quantity'],
                        MainCategory: data['Main Category'],
                        Subcategory: data['Sub Category'],
                        remainingquanitity: data['Remaining Quantity'],
                        priceperitem: data['Price Per Item'],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Elevated_button(
                    path: () {
                      UserDetils();
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
          }
        },
      ),
    );
  }

  void UserDetils() {

    Get.dialog(AlertDialog(
      title: Text('Enter User Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: NameController,
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: 'Enter Name',
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: AddressController,
            decoration: InputDecoration(
              labelText: 'Address',
              hintText: 'Enter address',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _discountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter Discount (%)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              _counterController.updateDiscount(value,Totalprice);
            },
          ),
          SizedBox(height: 20,),
          Obx(() {
            return _counterController.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(title:'Price Before Discount   ',size: 17,),
                      TextWidget(title: Totalprice.toStringAsFixed(2),size: 17,color: Colors.red,),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      TextWidget(title:'Price After Discount ',size: 17,),
                      TextWidget(title:_counterController.discountedPrice.value.toStringAsFixed(2),size: 17,color: Colors.red),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Elevated_button(
                        path: () {
                          Get.back();
                          NameController.clear();
                          AddressController.clear();
                          _discountController.clear();
                          _counterController.discountedPrice.value=Totalprice;
                        },
                        text: 'Cancel',
                        padding: 10,
                        width: 100,
                        height: 40,
                        radius: 12,
                        color: Colors.white,
                        backcolor: Colors.black87,
                      ),
                      Elevated_button(
                        path: () {
                          if(NameController.text.isNotEmpty && AddressController.text.isNotEmpty)
                          {
                            var discountprice=_discountController.text.isNotEmpty?_counterController.discountedPrice.value:Totalprice;
                               addBuyNow(
                                   NameController.text, AddressController.text,
                                   discountprice,_discountController.text,
                                 Totalprice,
                               );
                               NameController.clear();
                               AddressController.clear();
                               _discountController.clear();
                               _counterController.discountedPrice.value=Totalprice;
                               Get.back();
                          }
                          else{
                            showErrorSnackbar('Name and address both are required');
                          }
                        },
                        text: 'Confirm',
                        padding: 10,
                        width: 100,
                        height: 40,
                        radius: 12,
                        color: Colors.white,
                        backcolor: Colors.green,
                      ),
                    ],
                  ),
                ],
            );
          }),
        ],
      ),
    ));
  }
}
