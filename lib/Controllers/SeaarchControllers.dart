import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SalesSearchController extends GetxController {
  var searchQuery = "".obs;
  var orders = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    FirebaseFirestore.instance.collection('Orders').snapshots().listen((snapshot) {
      orders.value = snapshot.docs;
    });
  }

  List<QueryDocumentSnapshot> get filteredOrders {
    if (searchQuery.isEmpty) {
      return orders;
    } else {
      return orders.where((doc) => doc.id.contains(searchQuery.value)).toList();
    }
  }
}
// home bar search
class HomePageController extends GetxController {
  var searchQuery = ''.obs;
  var categories = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() {
    FirebaseFirestore.instance
        .collection('MainCategories')
        .snapshots()
        .listen((snapshot) {
      categories.value = snapshot.docs;
    });
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<QueryDocumentSnapshot> get filteredCategories {
    if (searchQuery.isEmpty) {
      return categories;
    } else {
      return categories
          .where((doc) =>
          doc.id.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }
}