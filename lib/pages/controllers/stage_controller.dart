import 'package:get/get.dart';

class StageController extends GetxController {
  // متغير لمراقبة إذا تم اجتياز الاختبار النهائي
  var isFinalTestPassed = false.obs;

  // دالة لتغيير الحالة عندما ينجح الطفل في الاختبار
  void passFinalTest() {
    isFinalTestPassed.value = true;
  }
}
