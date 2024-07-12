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
      if(imageUrl!=''){
        await addMainCategory(_nameController.text, imageUrl);
      }
      else{
        showErrorSnackbar('please select an image');
      }
      showSuccessSnackbar("Category Added Successfully");
      _nameController.clear();
      imageUrl=='';
      Get.back();
    } catch (e) {
      showErrorSnackbar("Error adding category");
    } finally {
      isLoading.value = false;
      _imageController.imagedata.value==null;
      Get.back();
    }
  }

  void DialogBox() {
    Get.defaultDialog(
      title: 'Add Category Name',
      titleStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
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
                    onTap: () {
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
                  color: Colors.black,
                  text: 'Cancel',
                  radius: 10,
                  padding: 10,
                  width: 100,
                  height: 40,
                  backcolor: Colors.white,
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
                  backcolor: Colors.black,
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
