import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pro5/animations/pressable_card.dart';
import 'package:pro5/animations/slidIn_card.dart';
import 'package:pro5/pages/exames/Hisa_test/sens_card.dart';
import 'package:pro5/pages/exames/animal_test/animal_card.dart';
import 'package:pro5/pages/exames/color_test/color_card.dart';
import 'package:pro5/pages/exames/letters/exam_card.dart';
import 'package:pro5/pages/exames/number_test/numbe_card.dart';
import 'package:pro5/pages/exames/seasons_test/seasons_test.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  final AudioPlayer player = AudioPlayer();

  final bool isDarkMode = false;
  // ممكن تغيّري حسب الوضع الليلي
  final List<Map<String, dynamic>> cardsData = [
    {
      "title": "الحيوانات",
      "image": "assets/images/animals.jpg",
      "borderColor": Colors.orange,
      "page": MemoryGameScreen(),
      "sound": "assets/sounds/animals.mp3",
    },
    {
      "title": "الأرقام",
      "image": "assets/images/numbers.jpg",
      "borderColor": Colors.blue,
      "page": NumberDragDropGame(),
      "sound": "assets/sounds/numbers.mp3",
    },
    {
      "title": "الأحرف",
      "image": "assets/images/letters.jpg",
      "borderColor": Colors.red,
      "page": ExamScreen(),
      "sound": "assets/sounds/letters.mp3",
    },
    {
      "title": "الألوان",
      "image": "assets/images/colors.jpg",
      "borderColor": Colors.green,
      "page": ColorQuiz(),
      "sound": "assets/sounds/colors.mp3",
    },
    {
      "title": "الحواس",
      "image": "assets/images/senses.jpg",
      "borderColor": Colors.purple,
      "page": SensesQuizPage(),
      "sound": "assets/sounds/senses.mp3",
    },
    {
      "title": "الفصول",
      "image": "assets/images/seasons.jpg",
      "borderColor": Colors.teal,
      "page": DragDropSeasonsEnhanced(),
      "sound": "assets/sounds/seasons.mp3",
    },
    {
      "title": "المهن",
      "image": "assets/images/jobs.jpg",
      "borderColor": Colors.brown,
      //"page": JobsPage(),
      "sound": "assets/sounds/jobs.mp3",
    },
    {
      "title": "الأشكال",
      "image": "assets/images/shapes.jpg",
      "borderColor": Colors.indigo,
      //"page": ShapesPage(),
      "sound": "assets/sounds/shapes.mp3",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("اختبارات الأطفال")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: cardsData.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            final card = cardsData[index];
            return SlideInCard(
              fromRight:
                  index % 2 ==
                  0, // الكارد من اليمين إذا رقم زوجي، من اليسار إذا فردي
              delayMilliseconds: index * 150, // تأخير متزايد لكل كارد
              child: PressableCard(
                title: card["title"],
                backgroundImage: card["image"],
                borderColor: card["borderColor"],
                page: card["page"],
                player: player,
                isDarkMode: isDarkMode,
                soundPath: card["sound"],
              ),
            );
          },
        ),
      ),
    );
  }
}
