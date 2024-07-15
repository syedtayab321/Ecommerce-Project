import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:get/get.dart';

Future<void> deleteProduct(String mainCategoryName, String subCategoryName, String productId) async {
  await FirebaseFirestore.instance
      .collection('MainCategories')
      .doc(mainCategoryName)
      .collection('subcategories')
      .doc(subCategoryName)
      .collection('Products')
      .doc(productId)
      .delete();
  showSuccessSnackbar('Data deleted sucessfully');
  Get.back();
}


Future<void> deleteSubCategory(String mainCategoryName, String subCategoryName) async {
  try {
    final subCategoryRef = FirebaseFirestore.instance
        .collection('MainCategories')
        .doc(mainCategoryName)
        .collection('subcategories')
        .doc(subCategoryName);

    final productsSnapshot = await subCategoryRef.collection('Products').get();

    for (var productDoc in productsSnapshot.docs) {
      await productDoc.reference.delete();
    }

    await subCategoryRef.delete();

    showSuccessSnackbar('Data deleted successfully');
    Get.back();
  } catch (e) {
    showErrorSnackbar(e.toString());
    Get.back();
  }
}


Future<void> deleteCategory(String mainCategoryName) async {
  try {
    final mainCategoryRef = FirebaseFirestore.instance.collection('MainCategories').doc(mainCategoryName);

    final subCategoriesSnapshot = await mainCategoryRef.collection('subcategories').get();

    for (var subCategoryDoc in subCategoriesSnapshot.docs) {
      final subCategoryRef = subCategoryDoc.reference;
      final productsSnapshot = await subCategoryRef.collection('Products').get();
      for (var productDoc in productsSnapshot.docs) {
        await productDoc.reference.delete();
      }
      await subCategoryRef.delete();
    }

    await mainCategoryRef.delete();

    showSuccessSnackbar('Data deleted successfully');
    Get.back();
  } catch (e) {
    // Show error message
    showErrorSnackbar(e.toString());
    Get.back();
  }
}


Future<void> deletePersonData(String id) async {
  try {
    final docRef = FirebaseFirestore.instance.collection('Orders').doc(id);

    final subCollectionSnapshot = await docRef.collection('Buyed Products').get();

    for (var subDoc in subCollectionSnapshot.docs) {
      await subDoc.reference.delete();
    }

    await docRef.delete();

    // Show success message
    showSuccessSnackbar('Data of Person deleted successfully');
    Get.back();
  } catch (e) {
    showErrorSnackbar(e.toString());
    Get.back();
  }
}
