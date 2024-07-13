import 'package:cloud_firestore/cloud_firestore.dart';
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
Future<void> addtoCart(String Discount,String CategoryName,double oldprice,double Discountprice,int quantity_buy,int remaningquantity,String MainCategory,String Productname) async {
        bool isSucessful=false;
        String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  try{
            DocumentSnapshot data=await FirebaseFirestore.instance.collection('Cart Data').doc(Productname).get();
            // checking if data in cart already ecists are not
            if(data.exists){
              int currentQuantity = data.get('Selected quantity').toInt();
              double currentTotalPrice = data.get('Price After Discount').toDouble();
              double currentoldPrice = data.get('Price Before Discount').toDouble();

              int newQuantity = currentQuantity + quantity_buy;
              double newTotalPrice = currentTotalPrice + Discountprice;
              double oldtotalprice=currentoldPrice + oldprice;

              await FirebaseFirestore.instance.collection('Cart Data').doc(Productname).update({
                'Price Before Discount':oldtotalprice,
                'Price After Discount':newTotalPrice,
                'Dicount on Items':Discount,
                'Selected quantity':newQuantity,
                'Date':formattedDate,
              });
            }else
              {
                await FirebaseFirestore.instance.collection('Cart Data').doc(Productname).set({
                  'Product Name':Productname,
                  'Price Before Discount':oldprice,
                  'Price After Discount':Discountprice,
                  'Dicount on Items':Discount,
                  'Selected quantity':quantity_buy,
                  'Date':formattedDate,
                });
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
           .doc(CategoryName)
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
