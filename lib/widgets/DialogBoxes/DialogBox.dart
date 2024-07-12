import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color confirmColor;
  final Color cancelColor;

  ConfirmDialog({
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.confirmColor = Colors.black,
    this.cancelColor = Colors.redAccent,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:TextWidget(title: title,color: confirmColor,size: 15,) ,
      content: TextWidget(title: title,color: confirmColor,size: 15,),
      actions: <Widget>[
        TextButton(
          child: Text(cancelText),
          onPressed: onCancel ?? () => Get.back(),
          style: TextButton.styleFrom(
            foregroundColor: cancelColor,
          ),
        ),
        Elevated_button(
            text: confirmText,
            color: Colors.white,
            path: onConfirm ?? () => Get.back(),
            radius: 10,
            width: 80,
            height: 20,
            backcolor:confirmColor,
             padding: 10,
        ),
      ],
    );
  }
}
