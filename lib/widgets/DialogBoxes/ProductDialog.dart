import 'package:ecommerce_app/Controllers/DateController.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryAddition.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/Snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ProductDialog extends StatefulWidget {
   String MainCategory,SubCategory;
  ProductDialog({required this.MainCategory,required this.SubCategory,});
  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
   final _formkey=GlobalKey<FormState>();
   DateController dateController=Get.put(DateController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
   void CategoryAddition()async{
        String name=_nameController.text;
        String price=_priceController.text;
        String stock=_stockController.text;

        if(name!='' && price!='' && stock!='' && dateController.expiryController!='') {
          Map<String, dynamic> Products = {
            'MainCategory': widget.MainCategory,
            'SubCategory': widget.SubCategory,
            'name': name,
            'Price': price,
            'Stock': stock,
            'ExpiryDate': dateController.expiryController.text,
          };
          User? user = FirebaseAuth.instance.currentUser;
          if (user!.uid == '') {
            showErrorSnackbar('User is not authenticated');
          }
          else {
            addProduct(name,widget.MainCategory, widget.SubCategory, Products,);
          }
        }
        else
          {
            showErrorSnackbar('Please Fill all the fields');
          }
   }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Product'),
      content: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Category Name'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Total Stock'),
                keyboardType: TextInputType.number,

              ),
              Obx(() => Text(
                ' ${dateController.selectedDate.value.toLocal()}'.split(' ')[0],
              )),
              TextFormField(
                controller: dateController.expiryController,
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => dateController.selectDate(context),
                  ),
                ),
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Get.back();
          },
        ),
        Elevated_button(
            text: "Add",
            color: Colors.white,
            path:(){
              CategoryAddition();
            }, padding: 10, radius: 10, width: 100, height: 20, backcolor: Colors.green,
        ),
      ],
    );
  }
}
