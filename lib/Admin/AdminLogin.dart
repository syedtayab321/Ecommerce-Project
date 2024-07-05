// import 'package:ecommerce_app/widgets/ElevatedButton.dart';
// import 'package:ecommerce_app/widgets/Icon_Button.dart';
// import 'package:ecommerce_app/widgets/Snakbar.dart';
// import 'package:ecommerce_app/widgets/TextFormField.dart';
// import 'package:ecommerce_app/widgets/TextWidget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// class AdminLogin extends StatefulWidget {
//   const AdminLogin({super.key});
//
//   @override
//   State<AdminLogin> createState() => _AdminLoginState();
// }
//
// class _AdminLoginState extends State<AdminLogin> {
//   final _emailController = TextEditingController();
//   final _passwordControlller = TextEditingController();
//
//   void Admin_login() async{
//     String email = _emailController.text;
//     String password = _passwordControlller.text;
//     if(email=='' || password=='')
//     {
//       showErrorSnackbar("Please Fill All cridentials");
//     }
//     else {
//       try  {
//         UserCredential userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(
//             email: email,
//             password: password
//         );
//         String uid=FirebaseAuth.instance.currentUser!.uid;
//         if(userCredential!='' && uid=='rEKWBRQyLTTBXf14LrYU13VMXXo2'){
//           Get.offNamedUntil('/admindahboard',(route)=>false);
//         }
//         else{
//           showErrorSnackbar('You are not an admin');
//         }
//       } on FirebaseAuthException catch(e){
//         showErrorSnackbar(e.code.toString());
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(
//           children: [
//             Image(
//               image: AssetImage('assets/images/back.jpg'),
//               fit: BoxFit.cover,
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//             ),
//             Center(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.all(16.0),
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16.0),
//                   ),
//                   elevation: 8.0,
//                   child: Padding(
//                     padding: EdgeInsets.all(24.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextWidget(
//                           title: "Let's sign you in",
//                           size: 24,
//                           weight: FontWeight.bold,
//                         ),
//                         SizedBox(height: 8),
//                         TextWidget(
//                           title: "Welcome back,\nYou've been missed!",
//                           size: 18,
//                           color: Colors.grey[600],
//                         ),
//                         SizedBox(height: 32),
//                         ResuableTextField(
//                           type: TextInputType.text,
//                           label: "Email",
//                           prefixicon: Icon(
//                             Icons.email,
//                             color: Colors.black38,
//                           ),
//                           controller: _emailController,
//                         ),
//                         SizedBox(height: 16),
//                         ResuableTextField(
//                           type: TextInputType.text,
//                           label: "Password",
//                           prefixicon: Icon(Icons.password),
//                           suffixicon: Icon_Button(
//                             onPressed: () {},
//                             icon: Icon(Icons.remove_red_eye),
//                           ),
//                           controller: _passwordControlller,
//
//                         ),
//                         SizedBox(height: 8),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () {
//                               // Handle "Forgot Password?"
//                             },
//                             child: TextWidget(
//                               title: "Forgot Password",
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         SizedBox(
//                           width: double.infinity,
//                           child: Elevated_button(
//                             text: "log In",
//                             color: Colors.white,
//                             padding: 8.0,
//                             fontsize: 16,
//                             radius: 12,
//                             backcolor: Colors.black,
//                             path: Admin_login,
//                             width: double.infinity,
//                             height: 60,
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         TextWidget(
//                           title: "Welcome to Our App",
//                           color: Colors.grey,
//                         ),
//                         SizedBox(height: 16),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }
// }
