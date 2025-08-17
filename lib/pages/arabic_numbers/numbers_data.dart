import 'package:flutter/material.dart';

import '../arabic_letters/letter_data.dart';

// final List<Map<String, dynamic>> numbers = [
//   {
//     'image': 'assets/images/letter&numbers/1.png',
//     'sound': 'assets/sounds/numbers_sound/واحد.mp3',
//     'name': 'واحد',
//     'color': Colors.amber,
//   },
//   {
//     'image': 'assets/images/letter&numbers/2.png',
//     'sound': 'assets/sounds/numbers_sound/اثنان.mp3',
//     'name': 'اثنان',
//     'color': Colors.deepPurpleAccent,
//   },
//   {
//     'image': 'assets/images/letter&numbers/3.png',
//     'sound': 'assets/sounds/numbers_sound/ثلاثة.mp3',
//     'name': 'ثلاثة',
//     'color': Colors.lightGreenAccent,
//   },
//   {
//     'image': 'assets/images/letter&numbers/4.png',
//     'sound': 'assets/sounds/numbers_sound/اربعة.mp3',
//     'name': 'أربعة',
//     'color': Colors.redAccent,
//   },
//   {
//     'image': 'assets/images/letter&numbers/5.png',
//     'sound': 'assets/sounds/numbers_sound/خمسة.mp3',
//     'name': 'خمسة',
//     'color': Colors.orangeAccent,
//   },
//   {
//     'image': 'assets/images/letter&numbers/6.png',
//     'sound': 'assets/sounds/numbers_sound/ستة.mp3',
//     'name': 'ستة',
//     'color': Colors.lightGreen,
//   },
//   {
//     'image': 'assets/images/letter&numbers/7.png',
//     'sound': 'assets/sounds/numbers_sound/سبعة.mp3',
//     'name': 'سبعة',
//     'color': Colors.blueAccent,
//   },
//   {
//     'image': 'assets/images/letter&numbers/8.png',
//     'sound': 'assets/sounds/numbers_sound/ثمانية.mp3',
//     'name': 'ثمانية',
//     'color': Colors.yellow,
//   },
//   {
//     'image': 'assets/images/letter&numbers/9.png',
//     'sound': ' assets/sounds/numbers_sound/تسعة.mp3',
//     'name': 'تسعة',
//     'color': Colors.pinkAccent,
//   },
//   {
//     'image': 'assets/images/letter&numbers/10.png',
//     'sound': 'assets/sounds/numbers_sound/عشرة.mp3',
//     'name': 'عشرة',
//     'color': Colors.pinkAccent,
//   },
// ];


final List<Item> numbers = [
  Item(image: 'assets/images/letter&numbers/1.png', name: 'واحد', color: Colors.amber, sound: 'assets/sounds/numbers_sound/واحد.mp3'),
  Item(image: 'assets/images/letter&numbers/2.png', name: 'اثنان', color: Colors.deepPurpleAccent, sound: 'assets/sounds/numbers_sound/اثنان.mp3'),
  Item(image: 'assets/images/letter&numbers/3.png', name: 'ثلاثة', color: Colors.lightGreenAccent, sound: 'assets/sounds/numbers_sound/ثلاثة.mp3'),
  Item(image: 'assets/images/letter&numbers/4.png', name: 'أربعة', color: Colors.redAccent, sound: 'assets/sounds/numbers_sound/اربعة.mp3'),
  Item(image: 'assets/images/letter&numbers/5.png', name: 'خمسة', color: Colors.orangeAccent, sound: 'assets/sounds/numbers_sound/خمسة.mp3'),
  Item(image: 'assets/images/letter&numbers/6.png', name: 'ستة', color: Colors.lightGreen, sound: 'assets/sounds/numbers_sound/ستة.mp3'),
  Item(image: 'assets/images/letter&numbers/7.png', name: 'سبعة', color: Colors.blueAccent, sound: 'assets/sounds/numbers_sound/سبعة.mp3'),
  Item(image: 'assets/images/letter&numbers/8.png', name: 'ثمانية', color: Colors.yellow, sound: 'assets/sounds/numbers_sound/ثمانية.mp3'),
  Item(image: 'assets/images/letter&numbers/9.png', name: 'تسعة', color: Colors.pinkAccent, sound: 'assets/sounds/numbers_sound/تسعة.mp3'),
  Item(image: 'assets/images/letter&numbers/10.png', name: 'عشرة', color: Colors.pinkAccent, sound: 'assets/sounds/numbers_sound/عشرة.mp3'),
];

