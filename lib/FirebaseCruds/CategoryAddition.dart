import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/widgets/Snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
Future<void> addMainCategory(String mainCategoryName) async {
   try{
     await FirebaseFirestore.instance.collection('MainCategories').doc(mainCategoryName).set({});
     showSuccessSnackbar("Data saved sucessfully");
     Get.back();
   }
    on FirebaseAuthException catch(e){
       showErrorSnackbar(e.code.toString());
    }
}

Future<void> addSubCategory(String mainCategoryName, String subCategoryName) async {
   try{
     await FirebaseFirestore.instance
         .collection('MainCategories')
         .doc(mainCategoryName)
         .collection('subcategories')
         .doc(subCategoryName)
         .set({});
     showSuccessSnackbar("Data saved sucessfully");
     Get.back();
   }
   on FirebaseAuthException catch(e){
     showErrorSnackbar(e.code.toString());
   }
}

Future<void> addProduct( String prodcutname,String mainCategoryName, String subCategoryName, Map<String, dynamic> productData) async {
   try{
       await FirebaseFirestore.instance
         .collection('MainCategories')
         .doc(mainCategoryName)
         .collection('subcategories')
         .doc(subCategoryName)
         .collection('Products')
          .doc(prodcutname)
       .set(productData);
     showSuccessSnackbar("Data saved sucessfully");
     Get.back();
   }
   on FirebaseException catch (e) {
     showErrorSnackbar(e.code.toString());
     print('FirebaseException: ${e.message}');
   } catch (e) {
     showErrorSnackbar(e.toString());
     print('Exception: ${e.toString()}');
   }
}
