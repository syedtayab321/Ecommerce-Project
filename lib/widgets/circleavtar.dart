import 'package:flutter/material.dart';

class circleavatar extends StatelessWidget {
  String image;
  double?  radius;
  Color? color;
  circleavatar({required this.image,this.radius,this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(image),
            radius: radius,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
