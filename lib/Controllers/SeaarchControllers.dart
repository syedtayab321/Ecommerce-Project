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
      return orders.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final name = data['username']?.toLowerCase() ?? '';
        final id = data['userid'].toLowerCase();
        return name.contains(searchQuery.value.toLowerCase()) || id.contains(searchQuery.value.toLowerCase());
      }).toList();
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