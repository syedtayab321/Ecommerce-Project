import 'package:ecommerce_app/widgets/Icon_Button.dart';
import 'package:ecommerce_app/widgets/TextWidget.dart';
import 'package:flutter/material.dart';

class ResuableTextField extends StatelessWidget {

  final TextInputType type;
  final TextEditingController? controller;
  final String label;
  final Icon_Button? suffixicon;
  final Icon? prefixicon;
  final double? radius;
  final bool? value;
  final Color? fillcolor;
  final String? Function(String?)? validator;
  const ResuableTextField({
    required this.type,
    this.controller,
    required this.label,
    this.prefixicon,
    this.suffixicon,
    this.radius=8.0,
    this.value=false,
    this.validator,
    this.fillcolor,
});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
       keyboardType: type,
       controller:controller,
       decoration: InputDecoration(
         label: TextWidget(title: label,),
         prefixIcon: prefixicon,
         suffixIcon: suffixicon,
         fillColor: fillcolor,
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(radius!),
         ),
       ),
        obscureText: value!,
        validator: validator,
    );
  }
}
