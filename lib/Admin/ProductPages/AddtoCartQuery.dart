import 'package:ecommerce_app/Controllers/AddToCartController.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryAddition.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuantitySelector extends StatelessWidget {
  double priceperitem;
  int stock;
  var totalprice,quantity_buy,remainingquantity;
  String categoryName,MainCategory,ProductName;
  QuantitySelector({
    required this.priceperitem,
    required this.categoryName,
    required this.stock,
    required this.MainCategory,
    required this.ProductName,
  });
  CounterController _counterControlle=Get.put(CounterController());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
         title: TextWidget(title: 'Select Quantity',size: 16,weight: FontWeight.bold,),
         content:  Container(
           padding: EdgeInsets.all(16.0),
           decoration: BoxDecoration(
             border: Border.all(color: Colors.grey),
             borderRadius: BorderRadius.circular(10.0),
           ),
           child: SingleChildScrollView(
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Text(
                   'Select Quantity & User',
                   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                 ),
                 SizedBox(height: 16.0),
                 Obx((){
                   return Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       IconButton(
                         icon: Icon(Icons.remove),
                         onPressed: _counterControlle.decrementQuantity,
                       ),
                       Text(
                         '${_counterControlle.quantity}',
                         style: TextStyle(fontSize: 20.0),
                       ),
                       IconButton(
                         icon: Icon(Icons.add),
                         onPressed: _counterControlle.incrementQuantity,
                       ),
                     ],
                   );
                 }),
                 SizedBox(height: 16.0),
                 Obx((){
                  totalprice= _counterControlle.quantity * priceperitem;
                  int selected_quantity=int.parse(_counterControlle.quantity.toString());
                  quantity_buy=selected_quantity;
                  remainingquantity=stock-selected_quantity ;
                   return Text(
                     'Total Price: \$${totalprice}',
                     style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                   );
                 })
               ],
             ),
           ),
         ),
      actions: <Widget>[
        TextButton(
          child: TextWidget(title: 'Cancel',),
          onPressed:(){
            Get.back();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
        Elevated_button(
          text: 'Add to CART',
          color: Colors.white,
          path: (){
            addtoCart(
                this.categoryName,
                totalprice,quantity_buy,
                remainingquantity,
                this.MainCategory,
                this.ProductName
            );
             showSuccessSnackbar('product added to cart sucessfully');
             Get.back();
          },
          radius: 10,
          width: 130,
          height: 20,
          backcolor:Colors.black,
          padding: 10,
        ),
      ],
    );
  }
}
