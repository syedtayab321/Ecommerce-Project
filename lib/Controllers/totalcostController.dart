import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  var totalCost = 0.0.obs;

  Future<void> fetchAndCalculateTotalCost() async {
    double sum = 0.0;

    try {
      QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .get();

      for (var orderDoc in ordersSnapshot.docs) {
        QuerySnapshot buyedProductsSnapshot = await FirebaseFirestore.instance
            .collection('Orders')
            .doc(orderDoc.id)
            .collection('Buyed Products')
            .get();

        for (var productDoc in buyedProductsSnapshot.docs) {
          sum += productDoc['Price After Discount'];
        }
      }

      totalCost.value = sum;
    } catch (e) {
      print("Error: $e");
      showErrorSnackbar("Error fetching total cost: $e");
    }
  }
}
