import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Admin/DashboardPages/Cart%20Related/CartScreen.dart';
import 'package:ecommerce_app/Admin/ProductPages/SubCategoryPage.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryDelete.dart';
import 'package:ecommerce_app/widgets/DialogBoxes/AddCategoryDialogBox.dart';
import 'package:ecommerce_app/widgets/DialogBoxes/DialogBox.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Icon_Button.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/SliderWidget.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextFormField.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Addcategorydialogbox _Dialog = Addcategorydialogbox();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Icon(Icons.menu),
         backgroundColor: Colors.white,
         title: TextWidget(title: 'Home Page',),
         actions: [
           Icon_Button(icon: Icon(Icons.add_shopping_cart,color: Colors.red,), onPressed: (){Get.to(CartScreen());}),
         ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:AnimatedImageSlider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Categories',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Elevated_button(
                      path: () => {
                        _Dialog.DialogBox(),
                      },
                      color: Colors.white,
                      text: 'Add Category',
                      radius: 10,
                      padding: 10,
                      width: 200,
                      height: 20,
                      backcolor: Colors.black,
                    ),
                  ),
                ],
              ),
              CategoryData(),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryData extends StatelessWidget {
  const CategoryData({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('MainCategories').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          }
          else
          {
             return Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16.0),
               child: GridView.builder(
                 shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 2,
                   childAspectRatio: Get.width / (Get.height / 1.8),
                   crossAxisSpacing: 16,
                   mainAxisSpacing: 16,
                 ),
                 itemCount: snapshot.data!.docs.length,
                 itemBuilder: (context, index) {
                   var ImageData=snapshot.data!.docs[index].data() as Map<String,dynamic>;
                   DocumentSnapshot category = snapshot.data!.docs[index];
                   return InkWell(
                     onTap: () {
                       Get.to(SubCategoriesPage(Productname: category.id));
                     },
                     child: Card(
                       elevation: 4,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Stack(
                             children: [
                               ClipRRect(
                                 borderRadius: BorderRadius.only(
                                   topLeft: Radius.circular(10),
                                   topRight: Radius.circular(10),
                                 ),
                                 child: Image.network(
                                   ImageData['Image Url']!,
                                   fit: BoxFit.cover,
                                   height: 140,
                                   width: double.infinity,
                                 ),
                               ),
                               Positioned(
                                 top: 8,
                                 right: 8,
                                 child: IconButton(
                                   icon: Icon(
                                     Icons.delete,
                                     color: Colors.red,
                                   ),
                                   onPressed: () {
                                     Get.dialog(ConfirmDialog(
                                             title: 'Delete',
                                             content: 'Are You Sure ?',
                                             confirmText:'Delete',
                                             cancelText: 'Cancel',
                                             onConfirm: (){
                                               deleteCategory(category.id);
                                               Get.back();
                                             },
                                             onCancel: (){
                                               Get.back();
                                             },
                                           ),);
                                     },
                                 ),
                               ),
                             ],
                           ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text(
                               category.id,
                               style: TextStyle(
                                 fontSize: 20,
                                 fontWeight: FontWeight.bold,
                                 color: Colors.black87,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   );
                 },
               ),
             );
          };
        });
  }
}
