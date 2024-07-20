import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';


Future<void> addBuyNow(String UserId,String userName, String address, double discountedPrice, String discount, double oldprice, double pricepaid, double Priceremains) async {
  bool isSuccess = false;
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Cart Data').get();
  List<QueryDocumentSnapshot> docs = snapshot.docs;

  try {
    await FirebaseFirestore.instance.collection('Orders').doc(userName).set({
      'username':userName,
      'userid':UserId,
    });
    String productId = Uuid().v4();

    // Define the fields you want to keep
    List<String> fieldsToKeep = ['Date', 'Product Name', 'Selected quantity', 'Total Price'];

    // Calculate total remaining prices for all documents
    double totalRemainingPrices = 0;
    QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance.collection('Orders').doc(userName).collection('Buyed Products').get();

    if(ordersSnapshot.docs.isEmpty){
      totalRemainingPrices = Priceremains;
    }else{
      for (var orderDoc in ordersSnapshot.docs) {
        Map<String, dynamic> orderData = orderDoc.data() as Map<String, dynamic>;
        if (orderData['Price Remaining'] != null && orderData['Price Remaining'] > 0) {
          totalRemainingPrices =orderData['Total Remaining Prices']+ Priceremains;
          orderData['Total Remaining Prices']=totalRemainingPrices;
        }
      }
    }

    for (var doc in docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> filteredData = {};

      // Keep only the specified fields
      fieldsToKeep.forEach((field) {
        if (data.containsKey(field)) {
          filteredData[field] = data[field];
        }
      });
      // Add additional fields
      filteredData['Product id'] = productId;
      filteredData['User Name'] = userName;
      filteredData['User ID'] = UserId;
      filteredData['Address'] = address;
      filteredData['Discount'] = discount;
      filteredData['Price Before Discount'] = oldprice;
      filteredData['Price After Discount'] = discountedPrice;
      filteredData['Price Paid'] = pricepaid;
      filteredData['Price Remaining'] = Priceremains;
      filteredData['Total Remaining Prices'] = totalRemainingPrices; // Add the total remaining prices

      await FirebaseFirestore.instance.collection('Orders').doc(userName).collection('Buyed Products').add(filteredData);
    }

    showSuccessSnackbar("Data stored successfully");
    isSuccess = true;
  } catch (e) {
    print('Error fetching or storing data: $e');
    isSuccess = false;
  }

  if (isSuccess) {
    for (var doc in docs) {
      await FirebaseFirestore.instance.collection('Cart Data').doc(doc.id).delete();
    }
    Get.back();
  } else {
    Get.back();
  }
}
