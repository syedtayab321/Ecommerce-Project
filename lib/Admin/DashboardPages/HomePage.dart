import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Admin/ProductPages/SubCategoryPage.dart';
import 'package:ecommerce_app/widgets/AddCategoryDialogBox.dart';
import 'package:ecommerce_app/widgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/Icon_Button.dart';
import 'package:ecommerce_app/widgets/TextFormField.dart';
import 'package:ecommerce_app/widgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Addcategorydialogbox _Dialog=Addcategorydialogbox();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Image(image: AssetImage('assets/images/logo.png'),width: 200,height: 100,),
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
              padding: const EdgeInsets.only(top: 6.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 12.0),
                            child: ResuableTextField(
                              type: TextInputType.text,
                              radius: 12,
                              label: 'search',
                              fillcolor: Colors.transparent,
                              suffixicon: Icon_Button(
                                icon: Icon(Icons.search),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                               _Dialog.DialogBox(),
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
                          var ImageData=snapshot.data!.docs[index].data() as Map<String,dynamic>;
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