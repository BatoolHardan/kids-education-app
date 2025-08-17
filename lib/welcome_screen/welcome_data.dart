import 'package:flutter/material.dart';
import 'package:pro5/welcome_screen/congratultions_model.dart';

class WelcomeData {
  static final List<CongratulationsModel> stages = [
    CongratulationsModel(
      title: 'ممتاز!',
      subtitle: 'لقد أنهيت الحروف بنجاح!',
      buttonText: 'ابدأ الأرقام',
      imagePath: 'assets/images/backgrounds/girl.png',
      backgroundColor: Colors.lightBlueAccent,
    ),
    CongratulationsModel(
      title: 'رائع!',
      subtitle: 'لقد أنهيت الأرقام بنجاح!',
      buttonText: 'ابدأ بتعلم الألوان',
      imagePath: 'assets/images/backgrounds/girl.png',
      backgroundColor: const Color.fromRGBO(124, 77, 255, 1),
      backgroundImagePath: 'assets/images/backgrounds/bacColor.jpg',
    ),
    CongratulationsModel(
      title: 'أحسنت!',
      subtitle: 'لقد أنهيت الألوان بنجاح!',
      buttonText: 'ابدأ بتعلم الحيوانات',
      imagePath: 'assets/images/backgrounds/boy.png',
      backgroundColor: Colors.green,
      backgroundImagePath: 'assets/images/backgrounds/test7.jpg',
    ),
    CongratulationsModel(
      title: 'ممتاز!',
      subtitle: 'لقد أنهيت الحيوانات بنجاح!',
      buttonText: 'اذهب للرئيسية',
      imagePath: 'assets/images/backgrounds/boy.png',
      backgroundColor: Colors.orange,
    ),
  ];
}
