import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> deleteCartItem(String docId) async {
    try {
      FirebaseFirestore.instance.collection('Cart Data').doc(docId).delete();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> get cartItemsStream =>
      _firestore.collection('Cart Data').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
}
