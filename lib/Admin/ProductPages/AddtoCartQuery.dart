import 'package:ecommerce_app/Admin/DashboardPages/Cart%20Related/CartScreen.dart';
import 'package:ecommerce_app/Controllers/AddToCartController.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryAddition.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuantitySelector extends StatelessWidget {
  double priceperitem;
  int stock;
  var totalprice, quantity_buy, remainingquantity, discountedPrice;
  String categoryName, MainCategory, ProductName;
  final String? userName;
  final String? address;
  final String? userid;
  QuantitySelector({
    required this.priceperitem,
    required this.categoryName,
    required this.stock,
    required this.MainCategory,
    required this.ProductName,
    this.userName, this.address,this.userid,
  });

  final CounterController _counterController = Get.put(CounterController());
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextWidget(
        title: 'Select Quantity',
        size: 16,
        weight: FontWeight.bold,
      ),
      content: Obx(() {
        _textEditingController.text = _counterController.quantity.value.toString();
        return _counterController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Quantity & User',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: _counterController.decrementQuantity,
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _textEditingController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          int? quantity = int.tryParse(value);
                          if (quantity != null) {
                            _counterController.setQuantity(quantity);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _counterController.incrementQuantity,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Obx(() {
                  totalprice = _counterController.quantity.value * priceperitem;
                  int selected_quantity = _counterController.quantity.value;
                  quantity_buy = selected_quantity;
                  remainingquantity = stock - selected_quantity;

                  return Column(
                    children: [
                      Text(
                        'Total Price: \£${totalprice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      }),
      actions: <Widget>[
        TextButton(
          child: TextWidget(title: 'Cancel'),
          onPressed: () {
            Get.back();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
        Elevated_button(
          text: 'Add to CART',
          color: Colors.white,
          path: () async {
            if(userName==null || userid==null || address==null){
              if (_counterController.quantity.value > stock) {
                showErrorSnackbar('Quantity exceeds available stock.');
                return;
              }
              _counterController.setLoading(true);
              await addtoCart(
                this.categoryName,
                this.totalprice,
                this.quantity_buy,
                this.remainingquantity,
                this.MainCategory,
                this.ProductName,
                this.priceperitem,
              ).then((value) {
                showSuccessSnackbar('Product added to cart successfully');
              }).catchError((error) {
                showErrorSnackbar('Failed to add product to cart: $error');
              }).whenComplete(() {
                _counterController.setLoading(false);
              });
            }
            else{
              if (_counterController.quantity.value > stock) {
                showErrorSnackbar('Quantity exceeds available stock.');
                return;
              }
              _counterController.setLoading(true);
              await addtoCart(
                this.categoryName,
                this.totalprice,
                this.quantity_buy,
                this.remainingquantity,
                this.MainCategory,
                this.ProductName,
                this.priceperitem,
              ).then((value) {
                showSuccessSnackbar('Product added to cart for this person');
              }).catchError((error) {
                showErrorSnackbar('Failed to add product to cart: $error');
              }).whenComplete(() {
                Get.to(CartScreen(userName: userName,userid: userid,address: address,));
                _counterController.setLoading(false);
              });
            }
          },
          radius: 10,
          width: 130,
          height: 20,
          backcolor: Colors.black,
          padding: 10,
        ),
      ],
    );
  }
}
