import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateProduct(String mainCategoryName, String subCategoryName, String productId, Map<String, dynamic> updatedData) async {
  await FirebaseFirestore.instance
      .collection('mainCategories')
      .doc(mainCategoryName)
      .collection('subcategories')
      .doc(subCategoryName)
      .collection('products')
      .doc(productId)
      .update(updatedData);
}
