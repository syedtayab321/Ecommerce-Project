import 'dart:io';
import 'package:ecommerce_app/Controllers/AddToCartController.dart';
import 'package:ecommerce_app/Controllers/ImageController.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

void showUpdateProductSheet(BuildContext context, String mainCategory, String subCategory, Map<String, dynamic> productData) {
  Get.bottomSheet(
    UpdateProductBottomSheet(
      mainCategory: mainCategory,
      subCategory: subCategory,
      productData: productData,
    ),
  );
}

class UpdateProductBottomSheet extends StatefulWidget {
  final String mainCategory, subCategory;
  final Map<String, dynamic> productData;

  UpdateProductBottomSheet({
    required this.mainCategory,
    required this.subCategory,
    required this.productData,
  });

  @override
  _UpdateProductBottomSheetState createState() => _UpdateProductBottomSheetState();
}

class _UpdateProductBottomSheetState extends State<UpdateProductBottomSheet> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final ImagePickerController imageController = Get.put(ImagePickerController());
  final CounterController _counterController=Get.put(CounterController());

  @override
  void initState() {
    super.initState();
    priceController.text = widget.productData['Price'].toString();
    stockController.text = widget.productData['Stock'].toString();
    expiryDateController.text = widget.productData['ExpiryDate'];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Obx((){
          return _counterController.isLoading.value?CircularProgressIndicator():
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Update Product',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () async {
                  await imageController.pickImage();
                },
                child: Obx(() {
                  if (imageController.imagedata.value != null) {
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: FileImage(imageController.imagedata.value!),
                    );
                  } else {
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      child: Image.network(widget.productData['Image Url']),
                    );
                  }
                }),
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
                    path: () async {
                      await _updateProduct(
                        widget.mainCategory,
                        widget.subCategory,
                        widget.productData['name'],
                        priceController.text,
                        stockController.text,
                        expiryDateController.text,
                        imageController.imagedata.value,
                      );
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
          );
        }),
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

  Future<void> _updateProduct(String mainCategory, String subCategory, String productName,
      String price, String stock, String expiryDate, File? pickedImage) async {
    String? imageUrl;
    if (pickedImage != null) {
      TaskSnapshot uploadTask = await FirebaseStorage.instance
          .ref()
          .child('Product Category Images')
          .child(productName)
          .putFile(pickedImage);
      imageUrl = await uploadTask.ref.getDownloadURL();
    }
_counterController.setLoading(true);
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
      'Image Url': imageUrl ?? widget.productData['Image Url'],
    }).then((_) {
      Get.back();
      Get.snackbar('Success', 'Product updated successfully', snackPosition: SnackPosition.BOTTOM);
      _counterController.setLoading(false);
    }).catchError((error) {
      Get.snackbar('Error', 'Failed to update product: $error', snackPosition: SnackPosition.BOTTOM);
    });
  }
}
