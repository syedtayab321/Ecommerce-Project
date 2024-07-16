import 'package:get/get.dart';

class CounterController extends GetxController {
  var quantity = 1.obs;
  var discount = 0.0.obs;
  var isLoading = false.obs;
  var discountedPrice=0.0.obs;
  var PricePaid=0.0.obs;
  var PriceRemains=0.0.obs;

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

  void updateDiscount(String value,double Totalprice) {
    discount.value = value.isEmpty ? 0.0 : double.parse(value);
    discountedPrice.value = Totalprice - (Totalprice * (discount.value / 100));
  }

  void MoneyPaid(String value,double Totalprice,double discountedprice)
  {
     PricePaid.value=value.isEmpty?Totalprice:double.parse(value);
     if(discountedprice==0.0){
       PriceRemains.value=Totalprice-PricePaid.value;
     }
     else if(discountedprice!=0.0){
       PriceRemains.value=discountedprice-PricePaid.value;
     }
  }
  void setLoading(bool value) {
    isLoading.value = value;
  }
}
