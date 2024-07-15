import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
  }

  void updateCartItemQuantity(String itemName, int newQuantity,String MainCategory,String subCategory,int remainingquantity,double totalprice,double priceperitem) async {
      bool sucessfull=true;
      double price=newQuantity*priceperitem;
    try {
      await FirebaseFirestore.instance
          .collection('Cart Data')
          .doc(itemName)
          .update({
          'Selected quantity': newQuantity,
          'Total Price':price,
          'Remaining Quantity':remainingquantity,
          });
      Get.snackbar('Success', 'Quantity updated successfully');
      sucessfull=false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      Get.back();
      sucessfull=true;
    }finally{
      Get.back();
    }

    if(sucessfull==false){
      await  FirebaseFirestore.instance
          .collection('MainCategories')
          .doc(MainCategory)
          .collection('subcategories')
          .doc(subCategory)
          .collection('Products')
          .doc(itemName)
          .update({
        'Stock':remainingquantity,
      });
      Get.back();
    }
  }

  Future<void> deleteCartItem(String docId,String MainCategory,String subCategory,int selectedquantity,int remainingquantity) async {
    bool sucessfull=true;

    try {
      FirebaseFirestore.instance.collection('Cart Data').doc(docId).delete();
      sucessfull=false;
    } catch (e) {
      print('Error deleting item: $e');
    }
    if(sucessfull==false){
      await  FirebaseFirestore.instance
          .collection('MainCategories')
          .doc(MainCategory)
          .collection('subcategories')
          .doc(subCategory)
          .collection('Products')
          .doc(docId)
          .update({
        'Stock':selectedquantity+remainingquantity,
      });
      Get.back();
    }
  }

  Stream<List<Map<String, dynamic>>> get cartItemsStream =>
      _firestore.collection('Cart Data').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
}
