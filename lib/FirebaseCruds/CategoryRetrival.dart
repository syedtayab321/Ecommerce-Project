import 'package:cloud_firestore/cloud_firestore.dart';

fetchProductsStream(String mainCategoryName, String subCategoryName) {
  return FirebaseFirestore.instance
      .collection('MainCategories')
      .doc(mainCategoryName)
      .collection('subcategories')
      .doc(subCategoryName)
      .get();
}
