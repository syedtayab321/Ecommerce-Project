import 'package:ecommerce_app/Controllers/AddToCartController.dart';
import 'package:ecommerce_app/Controllers/CartController.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItemCard extends StatelessWidget {
  final String itemName,MainCategory,Subcategory;
  final int selectedQuantity,remainingquanitity;
  final double totalprice,priceperitem;
  CartItemCard({
    required this.MainCategory,
    required this.Subcategory,
    required this.remainingquanitity,
    required this.itemName,
    required this.totalprice,
    required this.selectedQuantity,
    required this.priceperitem,
  });
  final CartController cartController = Get.put(CartController());
  final CounterController _counterController = Get.put(CounterController());

  void showRemoveDialog(BuildContext context) {
    Get.dialog(AlertDialog(
      title: TextWidget(
        title: 'Select Quantity to remove',
        size: 16,
        weight: FontWeight.bold,
      ),
      content: Obx(() {
        return _counterController.isLoading.value
            ? Center(
          child: CircularProgressIndicator(),
        )
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
                  'Quantity You want to remove',
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: _counterController.decrementQuantity,
                      ),
                      Text(
                        '${_counterController.quantity}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _counterController.incrementQuantity,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Elevated_button(
              text: 'Remove',
              color: Colors.white,
              path: () {
                cartController.updateCartItemQuantity(
                    itemName,
                    selectedQuantity-_counterController.quantity.value,
                    this.MainCategory,
                    this.Subcategory,
                    this.remainingquanitity+_counterController.quantity.value,
                    this.totalprice,
                    this.priceperitem
                );
              },
              radius: 10,
              width: 120,
              height: 20,
              backcolor: Colors.black,
              padding: 10,
            ),
            Elevated_button(
              text: 'Add',
              color: Colors.white,
              path: () {
                cartController.updateCartItemQuantity(
                    itemName,
                    selectedQuantity+_counterController.quantity.value,
                    this.MainCategory,
                    this.Subcategory,
                    this.remainingquanitity - _counterController.quantity.value,
                    this.totalprice,
                    this.priceperitem
                );
              },
              radius: 10,
              width: 120,
              height: 20,
              backcolor: Colors.green,
              padding: 10,
            ),
          ],
        )
      ],
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black87,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              title: itemName,
              size: 20,
              weight: FontWeight.bold,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            _buildDetailRow('Price Per item:',
                '\£${priceperitem.toStringAsFixed(2)}', Colors.white),
            SizedBox(height: 5),
            _buildDetailRow(
                'Selected Quantity:', '$selectedQuantity', Colors.white),
            SizedBox(height: 10),
            _buildDetailRow('Total Price:',
                '\£${totalprice.toStringAsFixed(2)}', Colors.white),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Elevated_button(
                    path:() {
                      cartController.deleteCartItem(
                         itemName,
                         this.MainCategory,
                         this.Subcategory,
                         selectedQuantity,
                         remainingquanitity,
                      );
                    },
                    padding: 10,
                    backcolor: Colors.white,
                    color: Colors.black87,
                    height: 20,
                    width: 120,
                    radius: 10,
                    text: 'Remove All',
                  ),
                  Elevated_button(
                    path:() {
                      showRemoveDialog(context);
                    },
                    padding: 10,
                    backcolor: Colors.green,
                    color: Colors.white,
                    height: 20,
                    width: 120,
                    radius: 10,
                    text: 'Update',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
            title: label,
            size: 16,
            weight: FontWeight.w500,
            color: Colors.white),
        TextWidget(
            title: value, size: 16, weight: FontWeight.w500, color: valueColor),
      ],
    );
  }
}
