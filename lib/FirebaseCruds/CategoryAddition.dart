import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
Future<void> addMainCategory(String mainCategoryName,String ImageUrl) async {
   try{
     await FirebaseFirestore.instance.collection('MainCategories').doc(mainCategoryName).set({
       'Image Url':ImageUrl,
     });
   }
    on FirebaseAuthException catch(e){
       showErrorSnackbar(e.code.toString());
    }
}

Future<void> addSubCategory(String mainCategoryName, String subCategoryName,String ImageUrl) async {
   try{
     await FirebaseFirestore.instance
         .collection('MainCategories')
         .doc(mainCategoryName)
         .collection('subcategories')
         .doc(subCategoryName)
         .set({
         'Image Url':ImageUrl,
     });
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
   }
   on FirebaseException catch (e) {
     showErrorSnackbar(e.code.toString());
     print('FirebaseException: ${e.message}');
   } catch (e) {
     showErrorSnackbar(e.toString());
     print('Exception: ${e.toString()}');
   }
}
