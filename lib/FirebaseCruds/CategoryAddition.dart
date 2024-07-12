import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Controllers/AddToCartController.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
Future<void> addMainCategory(String mainCategoryName,String ImageUrl) async {
   try{
     await FirebaseFirestore.instance.collection('MainCategories').doc(mainCategoryName).set({
       'Image Url':ImageUrl,
     });
   }
    on FirebaseAuthException catch(e){
       showErrorSnackbar(e.code.toString());
    }
    finally{
     Get.back();
    }
}
//add to sub category query
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
   finally{
     Get.back();
   }
}
// add to prodcut query
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
// add to cart query
Future<void> addtoCart(String CategoryName,double price,int quantity,int remaningquantity,String MainCategory,String Productname) async {
        bool isSucessful=false;
        CounterController _counterControlle=Get.put(CounterController());
  try{
            DocumentSnapshot data=await FirebaseFirestore.instance.collection('Cart Data').doc(Productname).get();
            // checking if data in cart already ecists are not
            if(data.exists){
              int currentQuantity = data.get('Selected quantity').toInt();
              double currentTotalPrice = data.get('Total Price').toDouble();

              int newQuantity = currentQuantity + quantity;
              double newTotalPrice = currentTotalPrice + price;
              await FirebaseFirestore.instance.collection('Cart Data').doc(Productname).update({
                'Total Price':newTotalPrice,
                'Selected quantity':newQuantity,
                'Date':DateTime.now(),
              });
              Get.back();
              showSuccessSnackbar('Data added to cart successfully');
            }else
              {
                await FirebaseFirestore.instance.collection('Cart Data').doc(Productname).set({
                  'Product Name':Productname,
                  'Total Price':price,
                  'Selected quantity':quantity,
                  'Date':DateTime.now(),
                });
                Get.back();
                showSuccessSnackbar('Data added to cart successfully');
              }
            isSucessful=true;
        }
        catch(e){
           isSucessful=false;
          showErrorSnackbar(e.toString());
        }
        finally{
            Get.back();
        }
     if(isSucessful==true){
       await  FirebaseFirestore.instance
           .collection('MainCategories')
           .doc(MainCategory)
           .collection('subcategories')
           .doc(CategoryName)
           .collection('Products')
           .doc(Productname)
           .update({
         'Stock':remaningquantity,
       });
       showSuccessSnackbar('Data added to cart successfully');
       Get.back();
     }
     else
     {
       showErrorSnackbar('error occur');
     }
}
