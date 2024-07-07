import 'package:get/get.dart';

class Password_controller extends GetxController{

  RxBool show=true.obs;

  void show_password(){
    show.value=!show.value;
  }
}