import 'package:pro5/pages/HisaDetail/six_model.dart';

class Profession {
  final String title; // مثل DynamicItem.title
  final String desc; // مثل DynamicItem.desc
  final String hisaImage; // الصورة الرئيسية

  final String example; // مثال على المهنة
  final String soundPath; // مسار الصوت

  Profession({
    required this.title,
    required this.desc,
    required this.hisaImage,

    required this.example,
    required this.soundPath,
  });
  DynamicItem toDynamicItem() {
    return DynamicItem(
      title: title,
      desc: desc,
      hisaImage: hisaImage,

      example: example,
      soundPath: soundPath,
      objectImage: 'null',
    );
  }
}
