// import 'package:ecommerce_app/Admin/Dashboard.dart';
// import 'package:ecommerce_app/User/UserDashboard.dart';
// import 'package:ecommerce_app/welcome.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
//
// class AuthController extends GetxController {
//   static AuthController instance = Get.find();
//   FirebaseAuth auth = FirebaseAuth.instance;
//   Rx<User?> firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);
//
//   @override
//   void onInit() {
//     super.onInit();
//     firebaseUser.bindStream(auth.userChanges());
//     ever(firebaseUser, _initialScreen);
//   }
//
//   _initialScreen(User? user) {
//     if (user == null) {
//       Get.offAll(() => Welcome());
//     } else {
//       _checkUserRole(user.uid);
//     }
//   }
//
//   void _checkUserRole(String uid) async {
//     if (uid == 'admin_uid') {
//       Get.offAll(() => AdminDashboard());
//     } else {
//       Get.offAll(() => Userdashboard());
//     }
//   }
//
//   void signOut() async {
//     await auth.signOut();
//   }
// }
