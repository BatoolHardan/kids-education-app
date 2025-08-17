import 'package:flutter/material.dart';
import 'package:pro5/welcome_screen/congratultions_screen.dart';
import 'package:pro5/welcome_screen/congratultions_model.dart';

final PageController _pageController = PageController();

/// دالة إغلاق الشاشة
void closeScreen(BuildContext context) {
  Navigator.pop(context);
}

/// دالة الذهاب للصفحة التالية
void goToNextPage({
  required BuildContext context,
  required PageController pageController,
  required int currentIndex,
  required int totalPages,
  required Widget onLastPageAction,
}) {
  if (currentIndex == totalPages - 1) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => onLastPageAction),
    );
  } else {
    pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
    );
  }
}

/// دالة الرجوع للصفحة السابقة
/// دالة الرجوع للصفحة السابقة مع التحويل للعنصر الأخير عند الوصول للأول
void goToPreviousPage({
  required PageController pageController,
  required int currentIndex,
  required int totalPages,
}) {
  if (currentIndex > 0) {
    pageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
    );
  } else {
    // إذا كان أول عنصر، نذهب لآخر عنصر
    pageController.jumpToPage(totalPages - 1);
  }
}
