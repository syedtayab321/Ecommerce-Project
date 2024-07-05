import 'package:ecommerce_app/widgets/ProductDialog.dart';
import 'package:ecommerce_app/widgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/Icon_Button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final double price;
  final int stock;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.stock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                     Icon_Button(icon: Icon(Icons.keyboard_backspace_rounded), onPressed: (){Get.back();}),
                  Elevated_button(
                    path: (){
                      Get.dialog(ProductDialog());
                    },
                    color: Colors.white,
                    text: 'Add Product',
                    radius: 10,
                    padding: 10,
                    width: 200,
                    height: 20,
                    backcolor: Colors.green,
                  ),
                ],
            ),
      ),
      body: ListView.builder(
        itemCount: 6, // Replace with your dynamic item count
        itemBuilder: (context, index) {
          return Card(
            elevation: 4.0,
            margin: EdgeInsets.all(12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                      child: Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 150.0,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            productName,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Stock: $stock',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: stock > 0 ? Colors.black : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Elevated_button(
                          path: (){

                          }, color: Colors.green, text: 'Update', radius: 7, padding: 10, width: 100, height: 20, backcolor: Colors.white,
                        ),
                        Elevated_button(
                          path: (){

                          }, color: Colors.white, text: 'Add to cart', radius: 10, padding: 10, width: 110, height: 20, backcolor: Colors.green,
                        ),
                        Elevated_button(
                          path: (){

                          }, color: Colors.white, text: 'Delete', radius: 7, padding: 10, width: 100, height: 20, backcolor: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}