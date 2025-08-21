import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pro5/animations/game_hint.dart';

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

  late Stopwatch stopwatch;
  late Timer timer;
  String elapsed = "00:00";
  int correctAttempts = 0;
  int wrongAttempts = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool showHint = true;
  @override
  void initState() {
    super.initState();
    seasons.shuffle();

    for (var s in seasons) {
      placedCorrectly[s['name']!] = false;
    }

    stopwatch = Stopwatch()..start();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        elapsed = _formatTime(stopwatch.elapsed);
      });
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
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
      wrongAttempts = 0; // إعادة تعيين الأخطاء
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
              SizedBox(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children:
                      seasons.map((season) {
                        // إظهار كل الصور الدوارة بدون حذف حتى بعد التثبيت
                        return placedCorrectly[season['name']] == true
                            ? Opacity(
                              opacity: 0.5,
                              child: buildSeasonImage(season['image']!),
                            )
                            : Draggable<String>(
                              data: season['name'],
                              feedback: buildSeasonImage(
                                season['image']!,
                                scale: 1.2,
                              ),
                              childWhenDragging: buildSeasonImage(
                                season['image']!,
                                opacity: 0.5,
                              ),
                              child: buildSeasonImage(season['image']!),
                            );
                      }).toList(),
                ),
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
                                  color: baseColor, // لون ثابت دائماً
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
                          onAcceptWithDetails: (details) {
                            if (!placedCorrectly[name]!) {
                              setState(() => placedCorrectly[name] = true);
                              if (placedCorrectly.values.every((v) => v)) {
                                stopwatch.stop();
                                timer.cancel();
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
                            }
                          },

                          onLeave: (data) {
                            if (data != name && !placedCorrectly[name]!) {
                              setState(
                                () => wrongAttempts = wrongAttempts + 1,
                              ); // زيادة العداد فقط عند الخطأ
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
                      'عدد الأخطاء: $wrongAttempts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 10),
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
          if (showCongrats)
            Container(
              color: Colors.black54,
              alignment: Alignment.center,
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                color: Colors.white,
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'assets/stars.json',
                        width: 150,
                        height: 150,
                        repeat: false,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'مبروك! لقد أنهيت اللعبة بنجاح 🎉',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: resetGame,
                        child: const Text('العب مرة أخرى'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildSeasonImage(String path, {double scale = 1, double opacity = 1}) {
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
