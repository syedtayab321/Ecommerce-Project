import 'package:ecommerce_app/Admin/ProductPages/ProductDetailCard.dart';
import 'package:ecommerce_app/FirebaseCruds/CategoryDelete.dart';
import 'package:ecommerce_app/widgets/DialogBoxes/DialogBox.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListTileWidget extends StatelessWidget {
  final String title,MainCategory;
  final IconData leadicon;
  final IconButton icon;
  final VoidCallback onIconPressed;
  const ListTileWidget({
    Key? key,
    required this.leadicon,
    required this.title,
    required this.icon,
    required this.onIconPressed,
    required this.MainCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Icon(leadicon,size:50,color: Colors.white,),
              ),
              SizedBox(width: screenWidth * 0.05),
              Expanded(
                child: TextWidget(
                  title: title,
                  size: 17,
                  color: Colors.white,
                )
              ),
              IconButton(
                icon: icon,
                onPressed: onIconPressed,
                splashRadius: 24.0,
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: (){
                  Get.dialog(ConfirmDialog(
                    title: 'Delete Category',
                    content: 'Warning:All Data Inside this Category will be Deleted',
                    confirmText: 'Delete',
                    cancelText: 'Cancel',
                    confirmColor: Colors.red,
                    cancelColor: Colors.green,
                    onConfirm: (){
                      deleteSubCategory(this.MainCategory, this.title);
                      Get.back();
                    },
                  ),
                  );
                },
                splashRadius: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}