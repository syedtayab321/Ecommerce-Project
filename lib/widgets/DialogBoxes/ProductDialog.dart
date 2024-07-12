import 'package:ecommerce_app/Controllers/DateController.dart';
import 'package:ecommerce_app/Controllers/ImageController.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryAddition.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDialog extends StatefulWidget {
  String MainCategory, SubCategory;
  ProductDialog({
    required this.MainCategory,
    required this.SubCategory,
  });
  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _formkey = GlobalKey<FormState>();
  DateController dateController = Get.put(DateController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final ImagePickerController _imageController =
      Get.put(ImagePickerController());
  final TextEditingController _controller = TextEditingController();
  String? _selectedUnit;
  final RxBool isLoading = false.obs;

  void CategoryAddition() async {
    String name = _nameController.text;
    String price = _priceController.text;
    String stock = _stockController.text;

    if (name != '' &&
        price != '' &&
        stock != '' &&
        dateController.expiryController != '') {
      isLoading.value = true;
      try {
        TaskSnapshot uploadTask = await FirebaseStorage.instance
            .ref()
            .child('Main Category Images')
            .child(_nameController.text)
            .putFile(_imageController.imagedata.value!);
        String imageUrl = await uploadTask.ref.getDownloadURL();
        Map<String, dynamic> Products = {
          'MainCategory': widget.MainCategory,
          'SubCategory': widget.SubCategory,
          'Image Url': imageUrl,
          'name': name,
          'Price': price,
          'Stock': stock,
          'ExpiryDate': dateController.expiryController.text,
        };
        User? user = FirebaseAuth.instance.currentUser;
        if (imageUrl == '') {
          showErrorSnackbar('Image is not selected');
        } else {
          addProduct(
            name,
            widget.MainCategory,
            widget.SubCategory,
            Products,
          );
          _nameController.clear();
          _stockController.clear();
          _priceController.clear();
          dateController.expiryController.clear();
        }
      } catch (e) {
        showErrorSnackbar('Please Upload Image ');
      } finally {
        isLoading.value = false;
        Get.back();
      }
    } else {
      showErrorSnackbar('Please Fill all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Add Product'),
        content: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(() {
                        return InkWell(
                          onTap: () async {
                            _imageController.pickImage();
                          },
                          child: CircleAvatar(
                            backgroundImage: _imageController.imagedata.value !=
                                    null
                                ? FileImage(_imageController.imagedata.value!)
                                : null,
                            radius: 50,
                          ),
                        );
                      }),
                      TextWidget(title: 'Pick Category Image', size: 15),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Category Name'),
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _stockController,
                  decoration: InputDecoration(labelText: 'Total Stock'),
                  keyboardType: TextInputType.number,
                ),
                Obx(() => Text(
                      ' ${dateController.selectedDate.value.toLocal()}'
                          .split(' ')[0],
                    )),
                TextFormField(
                  controller: dateController.expiryController,
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => dateController.selectDate(context),
                    ),
                  ),
                  readOnly: true,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Obx(() {
            return isLoading.value
                ? CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Elevated_button(
                        text: "Cancel",
                        color: Colors.black,
                        path: () {
                          Get.back();
                        },
                        padding: 10,
                        radius: 10,
                        width: 100,
                        height: 20,
                        backcolor: Colors.white,
                      ),
                      Elevated_button(
                        text: "Add",
                        color: Colors.white,
                        path: () {
                          CategoryAddition();
                        },
                        padding: 10,
                        radius: 10,
                        width: 100,
                        height: 20,
                        backcolor: Colors.black,
                      ),
                    ],
                  );
          }),
        ]);
  }
}
