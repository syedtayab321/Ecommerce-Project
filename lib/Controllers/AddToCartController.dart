import 'package:get/get.dart';

class CounterController extends GetxController {
  var quantity = 1.obs;
  var discount = 0.0.obs;
  var isLoading = false.obs;

  void incrementQuantity() {
    if (quantity.value < 10) {
      quantity.value++;
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void updateDiscount(String value) {
    discount.value = value.isEmpty ? 0.0 : double.parse(value);
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }
}
