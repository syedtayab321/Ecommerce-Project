import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Admin/ProductPages/ProductDetailCard.dart';
import 'package:ecommerce_app/Controllers/ImageController.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryAddition.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ListTileWidget.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextFormField.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoriesPage extends StatelessWidget {
  final String Productname;
  TextEditingController _productnameController = new TextEditingController();
  ImagePickerController _imageController=Get.put(ImagePickerController());
  SubCategoriesPage({required this.Productname});

  void SubCategoryAdd() async {
    TaskSnapshot uploadTask=  await FirebaseStorage.instance.ref().child('Sub Category Images').child(_productnameController.text).putFile(_imageController.imagedata.value!);
    String ImageUrl=await uploadTask.ref.getDownloadURL();

    await addSubCategory(Productname, _productnameController.text,ImageUrl);
    showSuccessSnackbar("Data saved sucessfully");
    Get.back();
    _productnameController.clear();
  }

  void DialogBox() {
    Get.defaultDialog(
      title: 'Add SubCategory Name',
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
                TextWidget(title: 'Pick SubCategory Image',size: 15,),
              ],
            ),
          ),
          ResuableTextField(
            type: TextInputType.text,
            label: 'Category Name',
            controller: _productnameController,
          ),
          SizedBox(height: 20),
          Row(
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
                  SubCategoryAdd();
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
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          title: '${this.Productname} Categories',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 13.0),
            child: Elevated_button(
              path: () => {
                DialogBox(),
              },
              color: Colors.white,
              text: 'Add',
              radius: 10,
              padding: 10,
              width: 100,
              height: 20,
              backcolor: Colors.green,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
         stream: FirebaseFirestore.instance.collection('MainCategories').doc(this.Productname).collection('subcategories').snapshots(),
         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return Center(child: CircularProgressIndicator());
           } else if (snapshot.hasError) {
             return Center(child: Text('Error: ${snapshot.error}'));
           } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
             return Center(child: Text('No data found'));
           } else {
             return Padding(
               padding: const EdgeInsets.all(8.0),
               child: ListView.builder(
                 itemCount: snapshot.data!.docs.length,
                 itemBuilder: (context, index) {
                   DocumentSnapshot category = snapshot.data!.docs[index];
                   var ProductData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                   return ListTileWidget(
                     title: category.id,
                     imageUrl: ProductData['Image Url']==''?"no image":ProductData['Image Url'],
                     icon: Icons.arrow_forward_ios_sharp,
                     MainCategory: this.Productname,
                     onIconPressed: () {
                       Get.to(
                         ProductDetailsCard(
                             imageUrl: 'assets/images/logo.png',
                             MainCategory: this.Productname,
                             SubCategory: category.id,
                             price: 65,
                             stock: 100
                         ),
                       );
                     },
                   );
                 },
               ),
             );
           }
         }
      ),
    );
  }
}
