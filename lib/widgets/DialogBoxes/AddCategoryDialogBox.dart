import 'dart:io';
import 'package:ecommerce_app/Controllers/ImageController.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryAddition.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextFormField.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Addcategorydialogbox extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final ImagePickerController _imageController = Get.put(ImagePickerController());
  final RxBool isLoading = false.obs;

  void CategoryAdd() async {
    isLoading.value = true;
    try {
      TaskSnapshot uploadTask = await FirebaseStorage.instance
          .ref()
          .child('Main Category Images')
          .child(_nameController.text)
          .putFile(_imageController.imagedata.value!);
      String imageUrl = await uploadTask.ref.getDownloadURL();
      await addMainCategory(_nameController.text, imageUrl);
      showSuccessSnackbar("Category Added Successfully");
      _nameController.clear();
      Get.back(); // Dismiss the dialog box
    } catch (e) {
      showErrorSnackbar("Error adding category");
    } finally {
      isLoading.value = false;
    }
  }

  void DialogBox() {
    Get.defaultDialog(
      title: 'Add Category Name',
      titleStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
      content: Column(
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
                      backgroundImage: _imageController.imagedata.value != null
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
          ResuableTextField(
            type: TextInputType.text,
            label: 'Category Name',
            controller: _nameController,
          ),
          SizedBox(height: 20),
          Obx(() {
            return isLoading.value
                ? CircularProgressIndicator()
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Elevated_button(
                  color: Colors.white,
                  text: 'Cancel',
                  radius: 10,
                  padding: 10,
                  width: 100,
                  height: 40,
                  backcolor: Colors.red.shade800,
                  path: () {
                    Get.back();
                    _nameController.clear();
                  },
                ),
                Elevated_button(
                  color: Colors.white,
                  text: 'Add',
                  radius: 10,
                  padding: 10,
                  width: 100,
                  height: 40,
                  backcolor: Colors.green,
                  path: () {
                    CategoryAdd();
                  },
                ),
              ],
            );
          }),
        ],
      ),
      radius: 15,
      backgroundColor: Colors.white,
      barrierDismissible: true,
      contentPadding: EdgeInsets.all(20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
