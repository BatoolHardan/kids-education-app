import 'package:flutter/material.dart';
import 'package:pro5/welcome_screen/congratultions_screen.dart';
import 'package:pro5/welcome_screen/stages_data.dart';

/// دالة إغلاق الشاشة
void closeScreen(BuildContext context) {
  Navigator.pop(context);
}

/// دالة الذهاب للصفحة التالية

/// دالة الرجوع للصفحة
void goToNextPage({
  required BuildContext context,
  required PageController pageController,
  required int currentIndex,
  required int totalPages,
}) {
  if (currentIndex == totalPages - 1) {
    // ✅ جبنا بيانات المرحلة الحالية
    final currentStage = stages[currentIndex];

    // 👉 إذا آخر صفحة: نروح لواجهة التهنئة الخاصة بهالمرحلة
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => StageCompleteScreen(
              stageName: currentStage.name,
              animationPath: currentStage.animationPath,
              onNextStage: () {
                // هون بتحددي شو بصير بعد التهنئة
                Navigator.pop(context); // مثلاً رجوع للقائمة أو للمرحلة الجاية
              },
            ),
      ),
    );
  } else {
    // 👉 غير ذلك: الانتقال للصفحة التالية
    pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

void goToPreviousPage({
  required PageController pageController,
  required int currentIndex,
  required int totalPages,
}) {
  if (currentIndex > 0) {
    // 👉 إذا مو بأول صفحة: يرجع عادي
    pageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  } else {
    // 👉 إذا بأول صفحة: يقفز للصفحة الأخيرة (داخل PageView)
    pageController.jumpToPage(totalPages - 1);
  }
}
