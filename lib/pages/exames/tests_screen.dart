import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pro5/animations/pressable_card.dart';
import 'package:pro5/animations/slidIn_card.dart';
import 'package:pro5/pages/exames/Hisa_test/sens_card.dart';
import 'package:pro5/pages/exames/Shapes/shapes_quiz_screen.dart';
import 'package:pro5/pages/exames/animal_test/animal_card.dart';
import 'package:pro5/pages/exames/color_test/color_card.dart';
import 'package:pro5/pages/exames/letters/exam_card.dart';
import 'package:pro5/pages/exames/number_test/numbe_card.dart';
import 'package:pro5/pages/exames/professions/professions_test.dart';
import 'package:pro5/pages/exames/seasons_test/seasons_test.dart';
import 'package:pro5/pages/onboarding/pulsing_screen.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  final AudioPlayer player = AudioPlayer();
  final bool isDarkMode = false;

  final List<Map<String, dynamic>> cardsData = [
    {
      "title": "الحيوانات",
      "image": "assets/images/واجهة الاختبارات/حيوانات.png",
      "borderColor": Colors.orange,
      "page": MemoryGameScreen(),
      "sound": "sounds/hello_sound/ترحيبي الحروف.mp3",
    },
    {
      "title": "الأرقام",
      "image": "assets/images/واجهة الاختبارات/ارقام.jpeg",
      "borderColor": Colors.blue,
      "page": NumberDragDropGame(),
      "sound": "sounds/hello_sound/ترحيبي الأرقام.mp3",
    },
    {
      "title": "الأحرف",
      "image": "assets/images/واجهة الاختبارات/حروف.png",
      "borderColor": Colors.red,
      "page": ExamScreen(),
      "sound": "sounds/hello_sound/ترحيبي الحروف.mp3",
    },
    {
      "title": "الألوان",
      "image": "assets/images/واجهة الاختبارات/الالوان.png",
      "borderColor": Colors.green,
      "page": ColorQuiz(),
      "sound": "assets/sounds/hello_sound/الالوان.mp3",
    },
    {
      "title": "الحواس",
      "image": "assets/images/واجهة الاختبارات/حواس.jpeg",
      "borderColor": Colors.purple,
      "page": SensesQuizPage(),
      "sound": "assets/sounds/hello_sound/الحواس ترحيبي.mp3",
    },
    {
      "title": "الفصول",
      "image": "assets/images/واجهة الاختبارات/فصول.png",
      "borderColor": Colors.teal,
      "page": DragDropSeasonsEnhanced(),
      "sound": "assets/sounds/hello_sound/الفصول ترحيبي.mp3",
    },
    {
      "title": "المهن",
      "image": "assets/images/واجهة الاختبارات/مهن2.png",
      "borderColor": Colors.brown,
      "page": JobsMatchingGame(),
      "sound": "assets/sounds/hello_sound/المهن.mp3",
    },
    {
      "title": "الأشكال",
      "image": "assets/images/واجهة الاختبارات/الاشكال.jpeg",
      "borderColor": Colors.indigo,
      "page": ShapeMatchingGame(),
      "sound": "assets/sounds/hello_sound/الاشكال.mp3",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "اختبارات الأطفال",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Ghayaty',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/واجهة الاختبارات/خلفية.jpeg"),
            fit: BoxFit.cover,
            opacity: 0.7,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: kToolbarHeight + 16,
            left: 16,
            right: 16,
            bottom: 16,
          ),
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
                fromRight: index % 2 == 0,
                delayMilliseconds: index * 150,
                child: PulsingWidget(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: PressableCard(
                      title: card["title"],
                      backgroundImage: card["image"],
                      borderColor: card["borderColor"],
                      page: card["page"],
                      player: player,
                      isDarkMode: isDarkMode,
                      soundPath: card["sound"],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
