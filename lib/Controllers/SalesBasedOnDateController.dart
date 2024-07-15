import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SalesOnDateController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var sales = <DocumentSnapshot>[].obs;
  var totalCost = 0.0.obs;

  void onDateSelected(DateTime date, DateTime? _) {
    selectedDate.value = date;
    fetchSalesByDate();
  }

  Future<void> fetchSalesByDate() async {
    double sum = 0.0;
    sales.clear();

    try {
      QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .get();
      for (var orderDoc in ordersSnapshot.docs) {
        QuerySnapshot buyedProductsSnapshot = await FirebaseFirestore.instance
            .collection('Orders')
            .doc(orderDoc.id)
            .collection('Buyed Products')
            .where('Date', isEqualTo: DateFormat('dd-MM-yyyy').format(selectedDate.value))
            .get();
        for (var productDoc in buyedProductsSnapshot.docs) {
          sales.add(productDoc);
          sum += productDoc['Total Price'];
        }
      }

      totalCost.value = sum;
    } catch (e) {
      print("Error: $e");
    }
  }
}
