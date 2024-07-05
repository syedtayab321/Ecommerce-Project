import 'package:ecommerce_app/Controllers/DateController.dart';
import 'package:ecommerce_app/widgets/ElevatedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ProductDialog extends StatefulWidget {
  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
   final _formkey=GlobalKey<FormState>();
   DateController dateController=Get.put(DateController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
   void CategoryAddition() async{
        String name=_nameController.text;
        String price=_priceController.text;
        String stock=_stockController.text;

        // if(_formkey.currentState!.validate()){
        //     await FirebaseFirestore.instance.
        // }
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Category name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Category price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Total Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total stock';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select expiry date';
                  }
                  return null;
                },
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
