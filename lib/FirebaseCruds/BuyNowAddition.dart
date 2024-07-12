import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'dart:async';

Future<void> addBuyNow(String username, String userCnic) async {
  bool isSuccess = false;
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Cart Data').get();
  List<QueryDocumentSnapshot> docs = snapshot.docs;

  try {
    await FirebaseFirestore.instance.collection('Orders').doc(userCnic).set({});
    Map<String,dynamic> storingdata={};
    for (var doc in docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      await  FirebaseFirestore.instance.collection('Orders').doc(userCnic).collection('Buyed Products').doc().set(data);
    }
    showSuccessSnackbar("Data stored sucessfully");
    isSuccess = true;
  } catch (e) {
    print('Error fetching or storing data: $e');
    isSuccess = false;
  }

  if (isSuccess) {
    for (var doc in docs) {
      await FirebaseFirestore.instance.collection('Cart Data').doc(doc.id).delete();
    }
  } else {
    Get.back();
  }
  Get.back();
}

