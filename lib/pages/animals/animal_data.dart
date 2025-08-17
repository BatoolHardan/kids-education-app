// final List<Map<String, String>> animals = [
//   {
//     'name': 'اسد',
//     'image': 'assets/images/animalPicture/اسد.png',
//     'sound': 'assets/sounds/animalSound/اسد.mp3',
//   },
//   {
//     'name': 'ارنب',
//     'image': 'assets/images/animalPicture/ارنب.png',
//     'sound': 'assets/sounds/animalSound/ارنب.mp3',
//   },
//   {
//     'name': 'فيل',
//     'image': 'assets/images/animalPicture/فيل.png',
//     'sound': 'assets/sounds/animalSound/فيل.mp3',
//   },
//   {
//     'name': 'بطة',
//     'image': 'assets/images/animalPicture/بطة.png',
//     'sound': 'assets/sounds/animalSound/بطة.mp3',
//   },
//   {
//     'name': 'بطريق',
//     'image': 'assets/images/animalPicture/بطريق.png',
//     'sound': 'assets/sounds/animalSound/بطريق.mp3',
//   },
//   {
//     'name': 'بقرة',
//     'image': 'assets/images/animalPicture/بقرة.png',
//     'sound': 'assets/sounds/animalSound/بقرة.mp3',
//   },
//   {
//     'name': 'بومة',
//     'image': 'assets/images/animalPicture/بومة.png',
//     'sound': 'assets/sounds/animalSound/بومة.mp3',
//   },
//   {
//     'name': 'تمساح',
//     'image': 'assets/images/animalPicture/تمساح.png',
//     'sound': 'assets/sounds/animalSound/تمساح.mp3',
//   },
//   {
//     'name': 'جمل',
//     'image': 'assets/images/animalPicture/جمل.png',
//     'sound': 'assets/sounds/animalSound/جمل.mp3',
//   },
//   {
//     'name': 'خروف',
//     'image': 'assets/images/animalPicture/خروف.png',
//     'sound': 'assets/sounds/animalSound/خروف.mp3',
//   },
//   {
//     'name': 'دب',
//     'image': 'assets/images/animalPicture/دب.png',
//     'sound': 'assets/sounds/animalSound/دب.mp3',
//   },
//   {
//     'name': 'ديك',
//     'image': 'assets/images/animalPicture/ديك.png',
//     'sound': 'assets/sounds/animalSound/ديك.mp3',
//   },
//   {
//     'name': 'زرافة',
//     'image': 'assets/images/animalPicture/زرافة.png',
//     'sound': 'assets/sounds/animalSound/زرافة.mp3',
//   },
//   {
//     'name': 'عصفور',
//     'image': 'assets/images/animalPicture/عصفور.png',
//     'sound': 'assets/sounds/animalSound/عصفور.mp3',
//   },
//   {
//     'name': 'قرد',
//     'image': 'assets/images/animalPicture/قرد.png',
//     'sound': 'assets/sounds/animalSound/قرد.mp3',
//   },
//   {
//     'name': 'قطة',
//     'image': 'assets/images/animalPicture/قطة.png',
//     'sound': 'assets/sounds/animalSound/قطة.mp3',
//   },
//   {
//     'name': 'كلب',
//     'image': 'assets/images/animalPicture/كلب.png',
//     'sound': 'assets/sounds/animalSound/كلب.mp3',
//   },
//   {
//     'name': 'ماعز',
//     'image': 'assets/images/animalPicture/ماعز.png',
//     'sound': 'assets/sounds/animalSound/ماعز.mp3',
//   },
//   {
//     'name': 'نمر',
//     'image': 'assets/images/animalPicture/نمر.png',
//     'sound': 'assets/sounds/animalSound/نمر.mp3',
//   },
//   {
//     'name': 'وحيد القرن',
//     'image': 'assets/images/animalPicture/وحيد القرن.png',
//     'sound': 'assets/sounds/animalSound/وحيد القرن.mp3',
//   },
// ];



import 'package:flutter/material.dart';

import '../arabic_letters/letter_data.dart';

final List<Item> animals = [
  Item(image: 'assets/images/animalPicture/اسد.png', name: 'اسد', color: Colors.orange, sound: 'assets/sounds/animalSound/اسد.mp3'),
  Item(image: 'assets/images/animalPicture/ارنب.png', name: 'ارنب', color: Colors.grey, sound: 'assets/sounds/animalSound/ارنب.mp3'),
  Item(image: 'assets/images/animalPicture/فيل.png', name: 'فيل', color: Colors.blueGrey, sound: 'assets/sounds/animalSound/فيل.mp3'),
  Item(image: 'assets/images/animalPicture/بطة.png', name: 'بطة', color: Colors.lightBlue, sound: 'assets/sounds/animalSound/بطة.mp3'),
  Item(image: 'assets/images/animalPicture/بطريق.png', name: 'بطريق', color: Colors.cyan, sound: 'assets/sounds/animalSound/بطريق.mp3'),
  Item(image: 'assets/images/animalPicture/بقرة.png', name: 'بقرة', color: Colors.brown, sound: 'assets/sounds/animalSound/بقرة.mp3'),
  Item(image: 'assets/images/animalPicture/بومة.png', name: 'بومة', color: Colors.deepPurpleAccent, sound: 'assets/sounds/animalSound/بومة.mp3'),
  Item(image: 'assets/images/animalPicture/تمساح.png', name: 'تمساح', color: Colors.green, sound: 'assets/sounds/animalSound/تمساح.mp3'),
  Item(image: 'assets/images/animalPicture/جمل.png', name: 'جمل', color: Colors.orangeAccent, sound: 'assets/sounds/animalSound/جمل.mp3'),
  Item(image: 'assets/images/animalPicture/خروف.png', name: 'خروف', color: Colors.grey, sound: 'assets/sounds/animalSound/خروف.mp3'),
  Item(image: 'assets/images/animalPicture/دب.png', name: 'دب', color: Colors.brown, sound: 'assets/sounds/animalSound/دب.mp3'),
  Item(image: 'assets/images/animalPicture/ديك.png', name: 'ديك', color: Colors.redAccent, sound: 'assets/sounds/animalSound/ديك.mp3'),
  Item(image: 'assets/images/animalPicture/زرافة.png', name: 'زرافة', color: Colors.yellow, sound: 'assets/sounds/animalSound/زرافة.mp3'),
  Item(image: 'assets/images/animalPicture/عصفور.png', name: 'عصفور', color: Colors.blue, sound: 'assets/sounds/animalSound/عصفور.mp3'),
  Item(image: 'assets/images/animalPicture/قرد.png', name: 'قرد', color: Colors.orange, sound: 'assets/sounds/animalSound/قرد.mp3'),
  Item(image: 'assets/images/animalPicture/قطة.png', name: 'قطة', color: Colors.pinkAccent, sound: 'assets/sounds/animalSound/قطة.mp3'),
  Item(image: 'assets/images/animalPicture/كلب.png', name: 'كلب', color: Colors.blueAccent, sound: 'assets/sounds/animalSound/كلب.mp3'),
  Item(image: 'assets/images/animalPicture/ماعز.png', name: 'ماعز', color: Colors.green, sound: 'assets/sounds/animalSound/ماعز.mp3'),
  Item(image: 'assets/images/animalPicture/نمر.png', name: 'نمر', color: Colors.orangeAccent, sound: 'assets/sounds/animalSound/نمر.mp3'),
  Item(image: 'assets/images/animalPicture/وحيد القرن.png', name: 'وحيد القرن', color: Colors.grey, sound: 'assets/sounds/animalSound/وحيد القرن.mp3'),
];
