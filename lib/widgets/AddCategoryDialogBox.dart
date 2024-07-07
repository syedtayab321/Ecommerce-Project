import 'dart:io';
import 'package:ecommerce_app/Controllers/ImageController.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryAddition.dart';
import 'package:ecommerce_app/widgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/Snakbar.dart';
import 'package:ecommerce_app/widgets/TextFormField.dart';
import 'package:ecommerce_app/widgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Addcategorydialogbox extends StatelessWidget {
  TextEditingController _nameController=new TextEditingController();
  ImagePickerController _imageController=Get.put(ImagePickerController());
  void CategoryAdd() async{
   TaskSnapshot uploadTask=  await FirebaseStorage.instance.ref().child('Main Category Images').child(_nameController.text).putFile(_imageController.imagedata.value!);
    String ImageUrl=await uploadTask.ref.getDownloadURL();
    addMainCategory(_nameController.text,ImageUrl);
    showSuccessSnackbar("Category Added Sucessfully");
    Get.back();
    _nameController.clear();
  }

  void DialogBox(){
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
            padding: const EdgeInsets.only(top: 20.0,bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 Obx((){
                    return  InkWell(
                      onTap: ()async{
                         _imageController.pickImage();
                      },
                      child: CircleAvatar(
                        backgroundImage: _imageController.imagedata.value!=null?
                         FileImage(_imageController.imagedata.value!):null,
                        radius: 50,
                      ),
                    );
                 }),
                TextWidget(title: 'Pick Category Image',size: 15,),
              ],
            ),
          ),
          ResuableTextField(
            type: TextInputType.text,
            label: 'Category Name',
            controller: _nameController,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Elevated_button(
                color: Colors.white, text: 'Cancel', radius: 10, padding: 10, width: 100, height: 40,
                backcolor: Colors.red.shade800,
                path: () {
                  Get.back();
                  _nameController.clear();
                },
              ),
              Elevated_button(color: Colors.white,
                text: 'Add', radius: 10, padding: 10, width: 100, height: 40, backcolor: Colors.green,
                path: () {
                  CategoryAdd();
                },
              ),

            ],
          ),
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
