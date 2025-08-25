import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pro5/animations/game_hint.dart';
import 'package:pro5/animations/pluse_seanso.dart';
import 'package:pro5/animations/result_page.dart';
import 'package:pro5/animations/sound_play.dart';
import 'package:pro5/utils/score_manager.dart';

class DragDropSeasonsEnhanced extends StatefulWidget {
  const DragDropSeasonsEnhanced({super.key});

  @override
  State<DragDropSeasonsEnhanced> createState() =>
      _DragDropSeasonsEnhancedState();
}

class _DragDropSeasonsEnhancedState extends State<DragDropSeasonsEnhanced>
    with TickerProviderStateMixin {
  final List<Map<String, String>> seasons = [
    {'name': 'الربيع', 'image': 'assets/images/الفصول الأربعة/ربيع.jpg'},
    {'name': 'الصيف', 'image': 'assets/images/الفصول الأربعة/صيف.jpg'},
    {'name': 'الخريف', 'image': 'assets/images/الفصول الأربعة/خريف.jpg'},
    {'name': 'الشتاء', 'image': 'assets/images/الفصول الأربعة/شتاء.jpg'},
  ];

  final Map<String, Color> seasonColors = {
    'الربيع': Colors.lightGreenAccent,
    'الصيف': Colors.orangeAccent,
    'الخريف': Colors.deepOrangeAccent,
    'الشتاء': Colors.lightBlueAccent,
  };

  Map<String, bool> placedCorrectly = {};
  int attempts = 0;
  bool showCongrats = false;
  late TestScoreManager scoreSeas; // لإدارة النقاط
  int correctAttempts = 0; // عدد الصور الصحيحة
  int wrongAttempts = 0; // عدد الأخطاء

  late Stopwatch stopwatch;
  late Timer timer;
  String elapsed = "00:00";

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool showHint = true;
  bool showScrollHint = true; // لإظهار سهم التلميح

  @override
  void initState() {
    super.initState();
    scoreSeas = TestScoreManager(
      seasons.length,
      testName: 'SeasonsMatchingGame',
      gameName: 'الألوان والفصول',
    );
    scoreSeas.reset();

    seasons.shuffle();

    // تهيئة الحالة لكل فصل
    for (var s in seasons) {
      placedCorrectly[s['name']!] = false;
    }

    // ساعة اللعبة
    stopwatch = Stopwatch()..start();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        elapsed = _formatTime(stopwatch.elapsed);
      });
    });

    // أنيميشن السهم
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // إخفاء التلميح بعد 5 ثواني
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          showScrollHint = false;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(Duration d) {
    return "${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}";
  }

  void resetGame() {
    setState(() {
      seasons.shuffle();
      for (var key in placedCorrectly.keys) {
        placedCorrectly[key] = false;
      }
      attempts = 0;
      showCongrats = false;

      scoreSeas.reset();
      correctAttempts = 0;
      wrongAttempts = 0;
      // إعادة تعيين الأخطاء
      stopwatch.reset();
      stopwatch.start();
      timer.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          elapsed = _formatTime(stopwatch.elapsed);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لعبة الفصول'),
        centerTitle: true,
        backgroundColor: Colors.teal.shade600,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              PulseSeasonDragSelector(
                seasons: [
                  {
                    'name': 'الربيع',
                    'image': 'assets/images/الفصول الأربعة/ربيع.jpg',
                  },
                  {
                    'name': 'الصيف',
                    'image': 'assets/images/الفصول الأربعة/صيف.jpg',
                  },
                  {
                    'name': 'الخريف',
                    'image': 'assets/images/الفصول الأربعة/خريف.jpg',
                  },
                  {
                    'name': 'الشتاء',
                    'image': 'assets/images/الفصول الأربعة/شتاء.jpg',
                  },
                ],
                onDrop: (season, correct) {
                  if (correct) {
                    print('$season تم سحبه بشكل صحيح!');
                  } else {
                    print('$season تم سحبه بشكل خاطئ.');
                  }
                },
              ),

              const SizedBox(height: 40),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(20),
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  children:
                      seasons.map((season) {
                        final name = season['name']!;
                        final accepted = placedCorrectly[name]!;
                        final baseColor = seasonColors[name]!;
                        return DragTarget<String>(
                          builder: (context, candidateData, rejectedData) {
                            return AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: accepted ? _pulseAnimation.value : 1.0,
                                  child: child,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: baseColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: accepted ? 12 : 6,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipOval(
                                      child: Image.asset(
                                        season['image']!,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black54,
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },

                          // ما نحسب أخطاء هنا
                          onWillAcceptWithDetails: (details) {
                            return true; // نقبل محاولة السحب ونفحص لاحقاً عند الإفلات
                          },

                          // هون الحساب
                          onAcceptWithDetails: (details) {
                            if (details.data == name &&
                                !placedCorrectly[name]!) {
                              setState(() {
                                placedCorrectly[name] = true;
                                correctAttempts++;
                                scoreSeas
                                    .addCorrect(); // زيادة النقاط عند الصحيح
                              });
                              SoundManager.playRandomCorrectSound();

                              if (placedCorrectly.values.every((v) => v)) {
                                stopwatch.stop();
                                timer.cancel();
                                scoreSeas
                                    .saveScore(); // حفظ النقاط عند انتهاء اللعبة
                                setState(() => showCongrats = true);
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'صحيح! تم وضع $name في المكان الصحيح 🎉',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              setState(() {
                                wrongAttempts++;
                                scoreSeas.addWrong(); // حساب الخطأ
                              });
                              SoundManager.playRandomWrongSound();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'هذه ليست المكان الصحيح، حاول مرة أخرى!',
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },
                        );
                      }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'عدد المطابقات: $correctAttempts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'عدد الأخطاء: $wrongAttempts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text('الوقت: $elapsed', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
          // شاشة التلميح 👇
          if (showHint)
            Positioned.fill(
              child: GameHintOverlay(
                hintText: "اسحب صورة الفصل إلى مكانه الصحيح 🌸☀🍂❄",
                hintAnimation: "assets/animations/baby girl.json",
                onConfirm: () {
                  setState(() {
                    showHint = false; // يخفي التلميح ويبدأ اللعب
                  });
                },
              ),
            ),
          // شاشة التهنئة
          if (showCongrats)
            Positioned.fill(
              child: ResultScreen(
                result: scoreSeas.finalScour,
                animationPath: 'assets/animations/baloon.json',
                congratsImagePath: 'assets/rewards/انت متميز.png',
                onRestart: () {
                  resetGame();
                  setState(() => showCongrats = false);
                },
              ),
            ),
        ],
      ),
    );
  }
}
