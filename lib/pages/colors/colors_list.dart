import 'package:flutter/material.dart';

class ColorItem {
  final String name;
  final String splashImage;
  final String objectImage;
  final String sound;
  final Color backgroundColor; // لون الخلفية عند اختيار اللون
  final Color shadowColor; // لون الظل حول الصورة

  ColorItem({
    required this.name,
    required this.splashImage,
    required this.objectImage,
    required this.sound,
    required this.backgroundColor,
    required this.shadowColor,
  });
}

List<ColorItem> colors = [
  ColorItem(
    name: 'احمر',
    splashImage: 'assets/images/color/colorSplash/احمر.png',
    objectImage: 'assets/images/color/colorPicture/احمر.png',
    sound: 'assets/sounds/colors_sound/احمر.mp3',
    backgroundColor: Colors.red.shade100,
    shadowColor: Colors.redAccent,
  ),
  ColorItem(
    name: 'ازرق',
    splashImage: 'assets/images/color/colorSplash/ازرق.png',
    objectImage: 'assets/images/color/colorPicture/ازرق.png',
    sound: 'assets/sounds/colors_sound/ازرق.mp3',
    backgroundColor: Colors.blue.shade100,
    shadowColor: Colors.blueAccent,
  ),
  ColorItem(
    name: 'ابيض',
    splashImage: 'assets/images/color/colorSplash/ابيض.png',
    objectImage: 'assets/images/color/colorPicture/ابيض.png',
    sound: 'assets/sounds/colors_sound/ابيض.mp3',
    backgroundColor: Colors.grey.shade200,
    shadowColor: Colors.grey,
  ),
  ColorItem(
    name: 'برتقالي',
    splashImage: 'assets/images/color/colorSplash/برتقالي.png',
    objectImage: 'assets/images/color/colorPicture/برتقالي.png',
    sound: 'assets/sounds/colors_sound/برتقالي.mp3',
    backgroundColor: Colors.orange.shade100,
    shadowColor: Colors.deepOrangeAccent,
  ),
  ColorItem(
    name: 'اسود',
    splashImage: 'assets/images/color/colorSplash/اسود.png',
    objectImage: 'assets/images/color/colorPicture/اسود.png',
    sound: 'assets/sounds/colors_sound/اسود.mp3',
    backgroundColor: Colors.black12,
    shadowColor: Colors.black45,
  ),
  ColorItem(
    name: 'اصفر',
    splashImage: 'assets/images/color/colorSplash/اصفر.png',
    objectImage: 'assets/images/color/colorPicture/اصفر.png',
    sound: 'assets/sounds/colors_sound/اصفر.mp3',
    backgroundColor: Colors.yellow.shade100,
    shadowColor: Colors.yellowAccent,
  ),
  ColorItem(
    name: 'اخضر',
    splashImage: 'assets/images/color/colorSplash/اخضر.png',
    objectImage: 'assets/images/color/colorPicture/اخضر.png',
    sound: 'assets/sounds/colors_sound/اخضر.mp3',
    backgroundColor: Colors.green.shade100,
    shadowColor: Colors.greenAccent,
  ),
  ColorItem(
    name: 'بني',
    splashImage: 'assets/images/color/colorSplash/بني.png',
    objectImage: 'assets/images/color/colorPicture/بني.png',
    sound: 'assets/sounds/colors_sound/بني.mp3',
    backgroundColor: Colors.brown.shade100,
    shadowColor: Colors.brown,
  ),
  ColorItem(
    name: 'وردي',
    splashImage: 'assets/images/color/colorSplash/زهري.png',
    objectImage: 'assets/images/color/colorPicture/زهري.png',
    sound: 'assets/sounds/colors_sound/وردي.mp3',
    backgroundColor: Colors.pink.shade100,
    shadowColor: Colors.pinkAccent,
  ),
];
