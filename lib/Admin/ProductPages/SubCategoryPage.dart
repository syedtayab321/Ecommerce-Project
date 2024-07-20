import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Admin/ProductPages/ProductDetailCard.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryAddition.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ListTileWidget.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextFormField.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoriesPage extends StatefulWidget {
  final String Productname;
  final String? userName;
  final String? address;
  final String? userid;
  SubCategoriesPage({required this.Productname,this.userName, this.address,this.userid});

  @override
  State<SubCategoriesPage> createState() => _SubCategoriesPageState();
}

class _SubCategoriesPageState extends State<SubCategoriesPage> {
  TextEditingController _productnameController = new TextEditingController();
  final RxBool isLoading = false.obs;

  final SearchController searchController = Get.put(SearchController());

  @override
  void initState() {
    super.initState();
    // Reset the search query when the page is initialized
    searchController.clearQuery();
  }

  void SubCategoryAdd() async {
    isLoading.value = true;
    try {
      await addSubCategory(widget.Productname, _productnameController.text);
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

  void showSubDocuments(BuildContext context, String subCategory) async {
    QuerySnapshot subDocumentsSnapshot = await FirebaseFirestore.instance
        .collection('MainCategories')
        .doc(widget.Productname)
        .collection('subcategories')
        .doc(subCategory)
        .collection('Products')
        .get();

    if (subDocumentsSnapshot.docs.isNotEmpty) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Text(
            'Sub Documents',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            width: Get.width * 2,
            height: double.maxFinite,
            child: ListView.builder(
              itemCount: subDocumentsSnapshot.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot subDocument = subDocumentsSnapshot.docs[index];
                String productName = subDocument.id;
                String imageUrl = subDocument['Image Url'];
                String price = subDocument['Price'];

                return Card(
                  elevation: 5,
                  color: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                      radius: 30,
                    ),
                    title: TextWidget(
                      title: productName,
                      size: 16,
                      color: Colors.white,
                    ),
                    trailing: TextWidget(
                      title: '£$price',
                      size: 16,
                      color: Colors.green,
                      weight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        barrierDismissible: true,
      );
    } else {
      showErrorSnackbar('No Product found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          title: '${this.widget.Productname}',
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
                  .doc(this.widget.Productname)
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
                          DocumentSnapshot category = filteredSubCategories[index];
                          return InkWell(
                            onTap: (){
                              Get.to(
                                ProductDetailsCard(
                                  MainCategory: this.widget.Productname,
                                  SubCategory: category.id,
                                  userName: widget.userName,
                                  userid: widget.userid,
                                  address: widget.address,
                                ),
                              );
                            },
                            child: ListTileWidget(
                              title: category.id,
                              leadicon: Icons.cookie,
                              icon:IconButton(
                                  onPressed: (){
                                    showSubDocuments(context, category.id);
                                  },
                                  icon: Icon(Icons.expand_circle_down,color: Colors.white,)
                              ) ,
                              MainCategory: this.widget.Productname,
                              onIconPressed: () {
                              },
                            ),
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

  void clearQuery() {
    query.value = '';
  }
}

