import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Admin/ProductPages/SubCategoryPage.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryAddition.dart';
import 'package:ecommerce_app/widgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/Icon_Button.dart';
import 'package:ecommerce_app/widgets/Snakbar.dart';
import 'package:ecommerce_app/widgets/TextFormField.dart';
import 'package:ecommerce_app/widgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   TextEditingController _nameController=new TextEditingController();
   void CategoryAdd(){
      addMainCategory(_nameController.text);
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
           ResuableTextField(
             type: TextInputType.text,
             label: 'Category Name',
             controller: _nameController,
           ),
           SizedBox(height: 20),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               Elevated_button(color: Colors.white,
                 text: 'Add', radius: 10, padding: 10, width: 100, height: 40, backcolor: Colors.green,
                 path: () {
                   CategoryAdd();
                 },
               ),
               Elevated_button(
                 color: Colors.white, text: 'Cancel', radius: 10, padding: 10, width: 100, height: 40,
                 backcolor: Colors.red.shade800,
                 path: () {
                   Get.back();
                   _nameController.clear();
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
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40), // Your logo
            SizedBox(width: 10),
            Expanded(
              child: ResuableTextField(
                type: TextInputType.text,
                radius: 17,
                label: 'search',
                fillcolor: Colors.transparent,
                suffixicon: Icon_Button(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('MainCategories').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage('assets/images/back.jpg'), // Your banner image
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Make Life At Home Better',
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'UP TO 70% OFF',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Categories',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Elevated_button(
                            path: () => {
                              DialogBox(),
                            },
                            color: Colors.white,
                            text: 'Add Category',
                            radius: 10,
                            padding: 10,
                            width: 200,
                            height: 20,
                            backcolor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: Get.width / (Get.height / 1.5),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot category = snapshot.data!.docs[index];
                          return InkWell(
                            onTap: () {
                              Get.to(SubCategoriesPage(Productname: category.id));
                            },
                            child: InteractiveViewer(
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/chocolate.jpg'), // Product image
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextWidget(
                                        title: category.id,
                                        size: 20,
                                        spacing: 3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
