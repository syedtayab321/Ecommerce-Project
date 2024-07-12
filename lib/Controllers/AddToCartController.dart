import 'package:get/get.dart';

class CounterController extends GetxController{
     RxInt quantity=1.obs;
     void incrementQuantity() {
         quantity++;
     }
     void decrementQuantity() {
       if (quantity > 1) {
         quantity--;
       }
     }
}