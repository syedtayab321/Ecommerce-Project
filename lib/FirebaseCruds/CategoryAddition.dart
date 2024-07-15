import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Controllers/AddToCartController.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
Future<void> addSubCategory(String mainCategoryName, String subCategoryName) async {
   try{
     await FirebaseFirestore.instance
         .collection('MainCategories')
         .doc(mainCategoryName)
         .collection('subcategories')
         .doc(subCategoryName)
         .set({});
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
Future<void> addtoCart(String SubCategoryName,double price,int quantity_buy,int remaningquantity,String MainCategory,String Productname,double priceperitem) async {
        bool isSucessful=false;
        final CounterController _counterController = Get.put(CounterController());
        String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  try{
            DocumentSnapshot data=await FirebaseFirestore.instance.collection('Cart Data').doc(Productname).get();
            // checking if data in cart already ecists are not
            if(data.exists){
              int currentQuantity = data.get('Selected quantity').toInt();
              double currentoldPrice = data.get('Total Price').toDouble();

              int newQuantity = currentQuantity + quantity_buy;
              double totalprice=currentoldPrice + price;

              await FirebaseFirestore.instance.collection('Cart Data').doc(Productname).update({
                'Remaining Quantity':remaningquantity,
                'Total Price':totalprice,
                'Selected quantity':newQuantity,
                'Date':formattedDate,
              });
              _counterController.quantity.value=1;
              Get.back();
            }else
              {
                await FirebaseFirestore.instance.collection('Cart Data').doc(Productname).set({
                  'Main Category':MainCategory,
                  'Sub Category':SubCategoryName,
                  'Product Name':Productname,
                  'Total Price':price,
                  'Selected quantity':quantity_buy,
                  'Remaining Quantity':remaningquantity,
                  'Price Per Item':priceperitem,
                  'Date':formattedDate,
                });
                Get.back();
                _counterController.quantity.value=1;
              }
            isSucessful=true;
        }
        catch(e){
           isSucessful=false;
          showErrorSnackbar(e.toString());
        }
     if(isSucessful==true){
       await  FirebaseFirestore.instance
           .collection('MainCategories')
           .doc(MainCategory)
           .collection('subcategories')
           .doc(SubCategoryName)
           .collection('Products')
           .doc(Productname)
           .update({
         'Stock':remaningquantity,
       });
     }
     else
     {
       showErrorSnackbar('error occur');
     }
}
