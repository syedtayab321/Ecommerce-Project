import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Admin/ProductPages/ProductDetailCard.dart';
import 'package:ecommerce_app/Controllers/ImageController.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryAddition.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ListTileWidget.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextFormField.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoriesPage extends StatelessWidget {
  final String Productname;
  TextEditingController _productnameController = new TextEditingController();
  ImagePickerController _imageController = Get.put(ImagePickerController());
  SubCategoriesPage({required this.Productname});
  final RxBool isLoading = false.obs;

  final SearchController searchController = Get.put(SearchController());

  void SubCategoryAdd() async {
    isLoading.value = true;
    try {
      await addSubCategory(Productname, _productnameController.text);
      showSuccessSnackbar("Data saved successfully");
      Get.back();
      _productnameController.clear();
    } catch (e) {
      showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void DialogBox() {
    Get.defaultDialog(
      title: 'Add SubCategory Name',
      titleStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      content: Column(
        children: [
          ResuableTextField(
            type: TextInputType.text,
            label: 'Category Name',
            controller: _productnameController,
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
                          SubCategoryAdd();
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
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          title: '${this.Productname}',
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
              backcolor: Colors.black,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter Name to Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              onChanged: (value) {
                searchController.updateQuery(value);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('MainCategories')
                  .doc(this.Productname)
                  .collection('subcategories')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No data found'));
                } else {
                  final allSubCategories = snapshot.data!.docs;
                  return Obx(() {
                    final filteredSubCategories =
                        allSubCategories.where((category) {
                      final categoryName = category.id.toLowerCase();
                      final query = searchController.query.value.toLowerCase();
                      return categoryName.contains(query);
                    }).toList();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: filteredSubCategories.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot category =
                              filteredSubCategories[index];
                          return ListTileWidget(
                            title: category.id,
                            leadicon: Icons.person,
                            icon: Icons.arrow_forward_ios_sharp,
                            MainCategory: this.Productname,
                            onIconPressed: () {
                              Get.to(
                                ProductDetailsCard(
                                  MainCategory: this.Productname,
                                  SubCategory: category.id,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchController extends GetxController {
  var query = ''.obs;

  void updateQuery(String newQuery) {
    query.value = newQuery;
  }
}
