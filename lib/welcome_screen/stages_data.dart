import 'package:pro5/pages/arabic_letters/letter_data.dart';
import 'package:pro5/pages/arabic_numbers/numbers_data.dart';
import 'package:pro5/pages/colors/color_card.dart';
import 'package:pro5/pages/learning_screen.dart';
import 'package:pro5/welcome_screen/stage_model.dart';

final List<StageModel> stages = [
  StageModel(
    id: 'letters',
    name: 'الحروف',
    animationPath: 'assets/animations/party_letters.json',
    screen: LearningScreen(title: 'الحروف', items: letters),
  ),
  StageModel(
    id: 'numbers',
    name: 'الأرقام',
    animationPath: 'assets/animations/party_numbers.json',

    screen: LearningScreen(title: "الأرقام", items: numbers),
  ),
  StageModel(
    id: 'colors',
    name: 'الألوان',
    animationPath: 'assets/animations/party_colors.json',
    screen: ColorsScreen(),
  ),
  // 🔁 وهيك بتكملي لبقية المراحل (8 مراحل)
];
