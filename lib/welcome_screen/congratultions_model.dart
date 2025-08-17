import 'dart:ui';

class CongratulationsModel {
  final String title;
  final String subtitle;
  final String buttonText;
  final String imagePath;
  final Color backgroundColor;
  final String? backgroundImagePath;

  CongratulationsModel({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imagePath,
    required this.backgroundColor,
    this.backgroundImagePath,
  });
}
