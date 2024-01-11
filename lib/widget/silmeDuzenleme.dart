import 'package:get/get.dart';

class BoolController extends GetxController {
  var ust = false.obs; // Observable olarak bool değeri tanımlıyoruz
var isLong = RxBool(false);
  void updateBool(bool value) {
    ust.value = value; // bool değerini güncelliyoruz
  }
    void updateBoolLong(bool value) {
    isLong.value = value; // bool değerini güncelliyoruz
  }
}