import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pro5/animations/pressable_card.dart';
import 'package:pro5/animations/slidIn_card.dart';

import 'package:pro5/pages/HisaDetail/six_data.dart';
import 'package:pro5/pages/Profession/sample_data.dart';
import 'package:pro5/pages/Seasons/seasons_page.dart';
import 'package:pro5/pages/arabic_letters/letter_data.dart';
import 'package:pro5/pages/exames/Hisa_test/sens_card.dart';
import 'package:pro5/pages/exames/seasons_test/seasons_test.dart';
import 'package:pro5/pages/learning_screen.dart';
import 'package:pro5/pages/learnscreen2.dart';
import 'package:pro5/pages/onboarding/custom_drawer.dart';
import 'package:pro5/pages/onboarding/main_child_page.dart';
import 'package:pro5/pages/onboarding/pulsing_screen.dart';
import 'package:pro5/services/auth_service.dart';

class StageFiveToSixScreen extends StatefulWidget {
  const StageFiveToSixScreen({super.key});

  @override
  State<StageFiveToSixScreen> createState() => _StageFiveToSixScreenState();
}

class _StageFiveToSixScreenState extends State<StageFiveToSixScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late List<bool> _isVisibleList;
  bool _isDarkMode = false;
  final AuthController authController = Get.find<AuthController>();
  String? childName;
  bool isLoading = true;
  late AudioPlayer player;

  final List<Map<String, dynamic>> sections = [
    {
      "title": "الحواس الخمس",
      "background": "assets/images/حواس/2.jpeg",
      "color": Colors.redAccent,
      "soundPath": "assets/sounds/hello_sound/الحواس ترحيبي.mp3",
      "page": LearnScreen(
        items: senses,
        title: "الحواس الخمسة",
        fixedBackground: true,
        fixedBackgroundImage: "assets/images/حواس/خلفية.jpeg",
      ),
    },
    {
      "title": "المهن",
      "background": "assets/images/المهن/خلفية الكارد.png",
      "color": Colors.orange,
      "soundPath": "assets/sounds/hello_sound/المهن.mp3",
      "page": LearnScreen(
        items: dummyItems,
        title: "المهن",
        fixedBackground: true,
        fixedBackgroundImage: "assets/images/المهن/خلفية.jpeg",
      ),
    },
    {
      "title": "الفصول الأربعة",
      "background": "assets/images/backgrounds/خلفية_فصول-removebg-preview.png",
      "color": Colors.green,
      "soundPath": "assets/sounds/hello_sound/الفصول ترحيبي.mp3",
      "page": SeasonsHomePage(),
    },
    {
      "title": "الأشكال الهندسية",
      "background": "assets/images/shapes/bac.jpeg",
      "color": Colors.blue,
      "soundPath": "assets/sounds/hello_sound/الاشكال.mp3",
      "page": LearningScreen(title: "الأشكال الهندسية", items: shapes),
    },
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    fetchChildName();
    _isVisibleList = List.generate(sections.length, (_) => false);

    // بدء الانيميشن عند تحميل الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimations();
    });
  }

  Future<void> fetchChildName() async {
    final data = await authController.getUserDataFromFirestore();
    setState(() {
      childName = data?['name'] ?? 'طفل';
      isLoading = false;
    });
  }

  late List<AnimationController> _slideControllers = [];
  late List<Animation<Offset>> _slideAnimations = [];

  Future<void> _startAnimations() async {
    _slideControllers =
        sections.map((e) {
          return AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 500),
          );
        }).toList();

    _slideAnimations =
        _slideControllers.map((controller) {
          return Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
        }).toList();

    for (int i = 0; i < _slideControllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      _slideControllers[i].forward();
      setState(() {
        _isVisibleList[i] = true;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _slideControllers) {
      controller.dispose();
    }
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
            'المرحلة 5-6 سنوات',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange.shade900,
              shadows: const [
                Shadow(
                  color: Colors.deepOrangeAccent,
                  blurRadius: 8,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.orange[100],
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
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                    ),
                    icon: const Text('🏁', style: TextStyle(fontSize: 22)),
                    label: const Text(
                      'النهاية',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    onPressed: () async {
                      Get.offAll(
                        () => MainChildPage(),
                        transition: Transition.fadeIn,
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
