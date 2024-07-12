import 'package:ecommerce_app/Controllers/CartController.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItemCard extends StatelessWidget {
  final String itemName;
  final double itemPrice;
  final int selectedQuantity;
  final double totalPrice;
  CartItemCard({
    required this.itemName,
    required this.itemPrice,
    required this.selectedQuantity,
    required this.totalPrice,
  });
  final CartController cartController = Get.put(CartController());
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
            _buildDetailRow('Price Per Item:',
                '\$${itemPrice.toStringAsFixed(2)}', Colors.white),
            SizedBox(height: 5),
            _buildDetailRow(
                'Selected Quantity:', '$selectedQuantity', Colors.white),
            SizedBox(height: 5),
            _buildDetailRow('Total Price:',
                '\$${totalPrice.toStringAsFixed(2)}', Colors.white),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Elevated_button(
                path:() {
                 cartController.deleteCartItem(itemName);
                },
                padding: 10,
                backcolor: Colors.white,
                color: Colors.black87,
                height: 20,
                width: 120,
                radius: 10,
                text: 'Remove',
              ),
            ),
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
