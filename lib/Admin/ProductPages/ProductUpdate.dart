import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

void showUpdateProductSheet(BuildContext context, String mainCategory, String subCategory, Map<String, dynamic> productData) {
  final TextEditingController priceController = TextEditingController(text: productData['Price'].toString());
  final TextEditingController stockController = TextEditingController(text: productData['Stock'].toString());
  final TextEditingController expiryDateController = TextEditingController(text: productData['ExpiryDate']);

  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Update Product',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 16.0),
          _buildTextField(priceController, 'Price', TextInputType.number),
          SizedBox(height: 10.0),
          _buildTextField(stockController, 'Stock', TextInputType.number),
          SizedBox(height: 10.0),
          _buildDateField(expiryDateController),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Elevated_button(
                path: () {
                  Get.back();
                },
                color: Colors.red,
                text: 'Cancel',
                radius: 7,
                padding: 10,
                width: 100,
                height: 40,
                backcolor: Colors.white,
              ),
              Elevated_button(
                path: () {
                  _updateProduct(mainCategory, subCategory, productData['name'], priceController.text, stockController.text, expiryDateController.text);
                },
                color: Colors.white,
                text: 'Update',
                radius: 7,
                padding: 10,
                width: 100,
                height: 40,
                backcolor: Colors.black87,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildTextField(TextEditingController controller, String label, TextInputType inputType) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.green, width: 2),
      ),
      fillColor: Colors.grey[100],
      filled: true,
    ),
    keyboardType: inputType,
  );
}

Widget _buildDateField(TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: 'Expiry Date',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.green, width: 2),
      ),
      fillColor: Colors.grey[100],
      filled: true,
      suffixIcon: IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: () async {
          DateTime? selectedDate = await showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2101),
          );
          if (selectedDate != null) {
            controller.text = "${selectedDate.toLocal()}".split(' ')[0];
          }
        },
      ),
    ),
    readOnly: true,
  );
}

void _updateProduct(String mainCategory, String subCategory, String productName, String price, String stock, String expiryDate) {
  FirebaseFirestore.instance
      .collection('MainCategories')
      .doc(mainCategory)
      .collection('subcategories')
      .doc(subCategory)
      .collection('Products')
      .doc(productName)
      .update({
    'Price': price,
    'Stock': stock,
    'ExpiryDate': expiryDate,
  }).then((_) {
    Get.back();
    Get.snackbar('Success', 'Product updated successfully', snackPosition: SnackPosition.BOTTOM);
  }).catchError((error) {
    Get.snackbar('Error', 'Failed to update product: $error', snackPosition: SnackPosition.BOTTOM);
  });
}
