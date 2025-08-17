import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pro5/animations/pressable_card.dart';
import 'package:pro5/animations/slidIn_card.dart';
import 'package:pro5/animations/sound_play.dart';

import 'package:pro5/pages/animals/animal_data.dart';
import 'package:pro5/pages/arabic_letters/letter_data.dart';
import 'package:pro5/pages/arabic_numbers/numbers_data.dart';
import 'package:pro5/pages/colors/color_card.dart';
import 'package:pro5/pages/exames/animal_test/animal_card.dart';
import 'package:pro5/pages/exames/color_test/color_card.dart';
import 'package:pro5/pages/exames/letters/exam_card.dart';
import 'package:pro5/pages/exames/number_test/numbe_card.dart';
import 'package:pro5/pages/exames/tests_screen.dart';
import 'package:pro5/pages/learning_screen.dart';
import 'package:pro5/pages/onboarding/custom_drawer.dart';
import 'package:pro5/pages/onboarding/main_child_page.dart';
import 'package:pro5/pages/onboarding/pulsing_screen.dart';
import 'package:pro5/pages/stag_five_six.dart';
import 'package:pro5/services/auth_service.dart';

class StageThreeFourScreen extends StatefulWidget {
  const StageThreeFourScreen({super.key});

  @override
  State<StageThreeFourScreen> createState() => _StageThreeFourScreenState();
}

class _StageThreeFourScreenState extends State<StageThreeFourScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AudioPlayer player;

  bool _isDarkMode = false;
  final AuthController authController = Get.find<AuthController>();
  String? childName;
  bool isLoading = true;

  final List<Map<String, dynamic>> sections = [
    {
      "title": "الحروف",
      "background": "assets/images/backgrounds/letterbac.png",
      "color": Colors.redAccent,
      "soundPath": "sounds/hello_sound/ترحيبي الحروف.mp3",
      "page": LearningScreen(title: "الحروف", items: letters),
      "testPage": ExamScreen(),
    },
    {
      "title": "الألوان",
      "background": "assets/images/backgrounds/colorbac.png",
      "color": Colors.orange,
      "soundPath": "sounds/hello_sound/ترحيبي الألوان.mp3",
      "page": ColorsScreen(),
      "testPage": ColorQuiz(),
    },
    {
      "title": "الأرقام",
      "background": "assets/images/backgrounds/numbac.png",
      "color": Colors.green,
      "soundPath": "sounds/hello_sound/ترحيبي الأرقام.mp3",
      "page": LearningScreen(title: "الأرقام", items: numbers),
      "testPage": NumberDragDropGame(),
    },
    {
      "title": "الحيوانات",
      "background": "assets/images/backgrounds/animalbac.png",
      "color": Colors.blue,
      "soundPath": "sounds/hello_sound/الحيوانات ترحيبي.mp3",
      "page": LearningScreen(
        title: "الحيوانات",
        items: animals,
        fixedBackground: true,
        fixedBackgroundImage: "assets/images/backgrounds/test.jpg",
      ),
      "testPage": MemoryGameScreen(),
    },
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    fetchChildName();

    SoundManager.preload(
      sections.map((s) => s["soundPath"] as String?).toList(),
    );
  }

  Future<void> fetchChildName() async {
    final data = await authController.getUserDataFromFirestore();
    setState(() {
      childName = data?['name'] ?? 'طفل';
      isLoading = false;
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => MainChildPage());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'المرحلة 3-4',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade900,
              shadows: const [
                Shadow(
                  color: Colors.deepPurpleAccent,
                  blurRadius: 8,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.blue[100],
        ),
        drawer: CustomDrawer(
          isDarkMode: _isDarkMode,
          onDarkModeToggle: (val) {
            setState(() {
              _isDarkMode = val;
            });
          },
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/backgrounds/bacMain.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.builder(
                    itemCount: sections.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                    itemBuilder: (context, index) {
                      final section = sections[index];
                      return SlideInCard(
                        fromRight: index % 2 == 0,
                        delayMilliseconds: index * 150,

                        child: PulsingWidget(
                          child: PressableCard(
                            isDarkMode: _isDarkMode,
                            title: section["title"],
                            backgroundImage: section["background"],
                            borderColor: section["color"],
                            page: section["page"],
                            player: player,
                            soundPath: section["soundPath"],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                PulsingWidget(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                    ),
                    icon: const Text('🎯', style: TextStyle(fontSize: 10)),
                    label: const Text(
                      'المرحلة 5-6',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    onPressed: () {
                      Get.to(
                        () => StageFiveToSixScreen(),
                        transition: Transition.rightToLeftWithFade,
                        preventDuplicates: false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
