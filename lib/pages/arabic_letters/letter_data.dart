// import 'package:flutter/material.dart';
//
// final List<Map<String, dynamic>> letters = [
//   {
//     'image': 'assets/images/letter&numbers/أ.png',
//     'word': 'أرنب',
//     'color': Colors.grey,
//     'sound': 'assets/sounds/letters_sound/ألف.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ب.png',
//     'word': 'برتقال',
//     'color': Colors.orangeAccent,
//     'sound': 'assets/sounds/letters_sound/باء.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ت.png',
//     'word': 'تفاح',
//     'color': Colors.redAccent,
//     'sound': 'assets/sounds/letters_sound/تاء.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ث.png',
//     'word': 'ثلج',
//     'color': Colors.blueAccent,
//     'sound': 'assets/sounds/letters_sound/ثاء.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ج.png',
//     'word': 'جزر',
//     'color': Colors.orangeAccent,
//     'sound': 'assets/sounds/letters_sound/جيم.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ح.png',
//     'word': 'حذاء',
//     'color': Colors.deepPurpleAccent,
//     'sound': 'assets/sounds/letters_sound/حاء.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/خ.png',
//     'word': 'خس',
//     'color': Colors.green,
//     'sound': 'assets/sounds/letters_sound/خاء.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/د.png',
//     'word': 'دب',
//     'color': Colors.brown,
//     'sound': 'assets/sounds/letters_sound/دال.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ذ.png',
//     'word': 'ذرة',
//     'color': Colors.yellow,
//     'sound': 'assets/sounds/letters_sound/ذال.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ر.png',
//     'word': 'رمّان',
//     'color': Colors.red,
//     'sound': 'assets/sounds/letters_sound/راء.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ز.png',
//     'word': 'زهرة',
//     'color': Colors.deepPurpleAccent,
//     'sound': 'assets/sounds/letters_sound/زاي.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/س.png',
//     'word': 'سمكة',
//     'color': Colors.orange,
//     'sound': 'assets/sounds/letters_sound/سين.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ش.png',
//     'word': 'شمس',
//     'color': Colors.amber,
//     'sound': 'assets/sounds/letters_sound/شين.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ص.png',
//     'word': 'صندوق',
//     'color': Colors.green,
//     'sound': 'assets/sounds/letters_sound/صاد.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ض.png',
//     'word': 'ضرس',
//     'color': Colors.blueGrey,
//     'sound': 'assets/sounds/letters_sound/ضاد.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ط.png',
//     'word': 'طماطم',
//     'color': Colors.redAccent,
//     'sound': 'assets/sounds/letters_sound/طاء.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ظ.png',
//     'word': 'ظرف',
//     'color': Colors.grey,
//     'sound': 'assets/sounds/letters_sound/ظاء.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ع.png',
//     'word': 'عصفور',
//     'color': Colors.deepPurpleAccent,
//     'sound': 'assets/sounds/letters_sound/عين.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/غ.png',
//     'word': 'غيمة',
//     'color': Colors.blue,
//     'sound': 'assets/sounds/letters_sound/غين.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ف.png',
//     'word': 'فراولة',
//     'color': Colors.redAccent,
//     'sound': 'assets/sounds/letters_sound/فاء.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ق.png',
//     'word': 'قلم',
//     'color': Colors.amber,
//     'sound': 'assets/sounds/letters_sound/قاف.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ك.png',
//     'word': 'كتاب',
//     'color': Colors.brown,
//     'sound': 'assets/sounds/letters_sound/كاف.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ل.png',
//     'word': 'ليمون',
//     'color': Colors.yellow,
//     'sound': 'assets/sounds/letters_sound/لام.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/م.png',
//     'word': 'منطاد',
//     'color': Colors.orange,
//     'sound': 'assets/sounds/letters_sound/ميم.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ن.png',
//     'word': 'نحلة',
//     'color': Colors.yellow,
//     'sound': 'assets/sounds/letters_sound/نون.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ه.png',
//     'word': 'هرّة',
//     'color': Colors.orange,
//     'sound': 'assets/sounds/letters_sound/هاء.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/و.png',
//     'word': 'ورقة',
//     'color': Colors.grey,
//     'sound': 'assets/sounds/letters_sound/واو.mp3',
//   },
//   {
//     'image': 'assets/images/letter&numbers/ي.png',
//     'word': 'يد',
//     'color': Colors.green,
//     'sound': 'assets/sounds/letters_sound/ياء.mp3',
//   },
// ];
import 'package:flutter/material.dart';

class Item {
  final String image;
  final String sound;
  final Color color;

  /// for letters
  final String? word;

  /// for numbers
  final String? name;

  const Item({
    required this.image,
    required this.sound,
    required this.color,
    this.word,
    this.name,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      image: map['image'] as String,
      sound: map['sound'] as String,
      color: map['color'] as Color,
      word: map['word'] as String?, // nullable
      name: map['name'] as String?, // nullable
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'sound': sound,
      'color': color,
      'word': word,
      'name': name,
    };
  }
}

final List<Item> letters = [
  Item(
    image: 'assets/images/letter&numbers/أ.png',
    word: 'أرنب',
    color: Colors.grey,
    sound: 'assets/sounds/letters_sound/ألف.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ب.png',
    word: 'برتقال',
    color: Colors.orangeAccent,
    sound: 'assets/sounds/letters_sound/باء.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ت.png',
    word: 'تفاح',
    color: Colors.redAccent,
    sound: 'assets/sounds/letters_sound/تاء.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ث.png',
    word: 'ثلج',
    color: Colors.blueAccent,
    sound: 'assets/sounds/letters_sound/ثاء.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ج.png',
    word: 'جزر',
    color: Colors.orangeAccent,
    sound: 'assets/sounds/letters_sound/جيم.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ح.png',
    word: 'حذاء',
    color: Colors.deepPurpleAccent,
    sound: 'assets/sounds/letters_sound/حاء.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/خ.png',
    word: 'خس',
    color: Colors.green,
    sound: 'assets/sounds/letters_sound/خاء.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/د.png',
    word: 'دب',
    color: Colors.brown,
    sound: 'assets/sounds/letters_sound/دال.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ذ.png',
    word: 'ذرة',
    color: Colors.yellow,
    sound: 'assets/sounds/letters_sound/ذال.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ر.png',
    word: 'رمّان',
    color: Colors.red,
    sound: 'assets/sounds/letters_sound/راء.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ز.png',
    word: 'زهرة',
    color: Colors.deepPurpleAccent,
    sound: 'assets/sounds/letters_sound/زاي.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/س.png',
    word: 'سمكة',
    color: Colors.orange,
    sound: 'assets/sounds/letters_sound/سين.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ش.png',
    word: 'شمس',
    color: Colors.amber,
    sound: 'assets/sounds/letters_sound/شين.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ص.png',
    word: 'صندوق',
    color: Colors.green,
    sound: 'assets/sounds/letters_sound/صاد.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ض.png',
    word: 'ضرس',
    color: Colors.blueGrey,
    sound: 'assets/sounds/letters_sound/ضاد.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ط.png',
    word: 'طماطم',
    color: Colors.redAccent,
    sound: 'assets/sounds/letters_sound/طاء.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ظ.png',
    word: 'ظرف',
    color: Colors.grey,
    sound: 'assets/sounds/letters_sound/ظاء.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ع.png',
    word: 'عصفور',
    color: Colors.deepPurpleAccent,
    sound: 'assets/sounds/letters_sound/عين.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/غ.png',
    word: 'غيمة',
    color: Colors.blue,
    sound: 'assets/sounds/letters_sound/غين.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ف.png',
    word: 'فراولة',
    color: Colors.redAccent,
    sound: 'assets/sounds/letters_sound/فاء.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ق.png',
    word: 'قلم',
    color: Colors.amber,
    sound: 'assets/sounds/letters_sound/قاف.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ك.png',
    word: 'كتاب',
    color: Colors.brown,
    sound: 'assets/sounds/letters_sound/كاف.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ل.png',
    word: 'ليمون',
    color: Colors.yellow,
    sound: 'assets/sounds/letters_sound/لام.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/م.png',
    word: 'منطاد',
    color: Colors.orange,
    sound: 'assets/sounds/letters_sound/ميم.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ن.png',
    word: 'نحلة',
    color: Colors.yellow,
    sound: 'assets/sounds/letters_sound/نون.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ه.png',
    word: 'هرّة',
    color: Colors.orange,
    sound: 'assets/sounds/letters_sound/هاء.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/و.png',
    word: 'ورقة',
    color: Colors.grey,
    sound: 'assets/sounds/letters_sound/واو.mp3',
  ),
  Item(
    image: 'assets/images/letter&numbers/ي.png',
    word: 'يد',
    color: Colors.green,
    sound: 'assets/sounds/letters_sound/ياء.mp3',
  ),
];
final List<Item> shapes = [
  Item(
    image: 'assets/images/shapes/مستطيل.png',
    word: 'مستطيل',
    color: Colors.redAccent,
    sound: 'assets/sounds/shapes_sound/مستطيل.mp3',
  ),
  Item(
    image: 'assets/images/shapes/مربع.png',
    word: 'مربع',
    color: Colors.pinkAccent,
    sound: 'assets/sounds/shapes_sound/مربع.mp3',
  ),
  Item(
    image: 'assets/images/shapes/مثلث.png',
    word: 'مثلث',
    color: Colors.amberAccent,
    sound: 'assets/sounds/shapes_sound/مثلث.mp3',
  ),
  Item(
    image: 'assets/images/shapes/دائرة.png',
    word: 'دائرة',
    color: Colors.greenAccent,
    sound: 'assets/sounds/shapes_sound/دائرة.mp3',
  ),
  Item(
    image: 'assets/images/shapes/بيضاوي.png',
    word: 'بيضاوي',
    color: Colors.redAccent,
    sound: 'assets/sounds/shapes/oval.mp3',
  ),
  Item(
    image: 'assets/images/shapes/star.png',
    word: 'نجمة',
    color: Colors.yellow,
    sound: 'assets/sounds/shapes_sound/نجمة.mp3',
  ),
];
