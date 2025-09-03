import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pro5/animations/game_hint.dart';
import 'package:pro5/animations/result_page.dart';
import 'package:pro5/animations/sound_play.dart';
import 'package:pro5/utils/score_manager.dart';

class ColorQuiz extends StatefulWidget {
  const ColorQuiz({super.key});

  @override
  _ColorQuizState createState() => _ColorQuizState();
}

class _ColorQuizState extends State<ColorQuiz> with TickerProviderStateMixin {
  final List<String> quizColors = [
    'red',
    'blue',
    'green',
    'orange',
    'black',
    'white',
    'yellow',
    'brown',
    'pink',
  ];

  int currentColorIndex = 0;
  String targetColor = 'red';
  bool showHint = true;
  late TestScoreManager scoreColor;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  List<ColorItem> items = [];
  late AnimationController targetColorAnimationController;
  late Animation<double> scaleAnimation;
  late Animation<double> bounceAnimation;
  late Animation<Color?> glowAnimation;

  @override
  void initState() {
    super.initState();
    targetColor = quizColors[currentColorIndex];
    _setupItems();
    _setupTargetColorAnimation();
    scoreColor = TestScoreManager(
      quizColors.length, // عدد الألوان الكلّي
      testName: "ColorQuiz",
      gameName: 'الألوان',
    );
    scoreColor.reset();
  }

  void _setupItems() {
    final otherColors =
        quizColors.where((c) => c != targetColor).toList()..shuffle();
    final correctItems = List.generate(3, (_) => ColorItem(targetColor));
    final wrongItems = otherColors.take(6).map((c) => ColorItem(c)).toList();
    items = [...correctItems, ...wrongItems]..shuffle();

    for (var item in items) {
      item.initAnimation(this);
    }
  }

  void _setupTargetColorAnimation() {
    targetColorAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: targetColorAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    bounceAnimation = Tween(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(
        parent: targetColorAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    glowAnimation = ColorTween(
      begin: ColorItem(targetColor).toColor(),
      end: ColorItem(targetColor).toColor().withOpacity(0.7),
    ).animate(
      CurvedAnimation(
        parent: targetColorAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: 700), () {
      if (mounted) targetColorAnimationController.repeat(reverse: true);
    });
  }

  void handleTap(int index) async {
    final item = items[index];
    if (!item.visible) return;

    if (item.color == targetColor) {
      // ✅ إجابة صحيحة
      setState(() {
        _correctAnswers++;
        scoreColor.addCorrect();
      });
      SoundManager.playRandomCorrectSound();
      await item.controller.forward();
      setState(() => item.visible = false);

      final remainingCorrect = items.any(
        (e) => e.visible && e.color == targetColor,
      );

      if (!remainingCorrect) {
        await Future.delayed(Duration(milliseconds: 400));
        if (currentColorIndex < quizColors.length - 1) {
          setState(() {
            currentColorIndex++;
            targetColor = quizColors[currentColorIndex];
            _setupItems();
            targetColorAnimationController.reset();
            targetColorAnimationController.repeat(reverse: true);
          });
        } else {
          _showFinalCelebration();
        }
      }
    } else {
      // ❌ إجابة غلط
      setState(() {
        _wrongAnswers++;
        scoreColor.addWrong();
      });
      SoundManager.playRandomWrongSound();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 10),
              Text('هذا اللون غير صحيح!'),
            ],
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _showFinalCelebration() async {
    await scoreColor.saveScore();
    Get.to(
      () => ResultScreen(
        result: scoreColor.finalScour,
        animationPath: 'assets/animations/fly baloon slowly.json',
        congratsImagePath: 'assets/rewards/مشاركة رائعة.png',
        onRestart: () {
          setState(() {
            currentColorIndex = 0;
            targetColor = quizColors[0];
            _setupItems();
            _correctAnswers = 0;
            _wrongAnswers = 0;
            scoreColor.reset(); // ✅ تم التعديل هنا
            targetColorAnimationController.reset();
            targetColorAnimationController.repeat(reverse: true);
          });
        },
      ),
    );
  }

  Widget buildTargetColor() {
    return AnimatedBuilder(
      animation: targetColorAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, bounceAnimation.value),
          child: Transform.scale(
            scale: scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: glowAnimation.value ?? Colors.transparent,
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 45,
                backgroundColor: ColorItem(targetColor).toColor(),
                child:
                    targetColor == 'white'
                        ? Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                            color: ColorItem(targetColor).toColor(),
                          ),
                        )
                        : null,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    for (var item in items) {
      item.controller.dispose();
    }
    targetColorAnimationController.dispose();
    super.dispose();
  }

  Widget buildColorCircle(int index) {
    final item = items[index];
    final color = item.toColor();

    return AnimatedBuilder(
      animation: item.controller,
      builder: (_, __) {
        final scale = item.visible ? item.scale.value : 0.0;
        return Transform.scale(
          scale: scale,
          child:
              item.visible
                  ? GestureDetector(
                    onTap: () => handleTap(index),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: color,
                      child:
                          item.color == 'white'
                              ? Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                  color: color,
                                ),
                              )
                              : null,
                    ),
                  )
                  : SizedBox(width: 70, height: 70),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 👇 الخلفية
            Image.asset(
              'assets/images/color/colors/bac.jpg',
              fit: BoxFit.cover,
            ),

            // 👇 المحتوى
            Column(
              children: [
                SizedBox(height: 24),
                Text('اختر اللون:', style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                buildTargetColor(),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: LinearProgressIndicator(
                    value: (currentColorIndex + 1) / quizColors.length,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.yellow.shade700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${currentColorIndex + 1} / ${quizColors.length}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(
                  currentColorIndex < quizColors.length
                      ? 'اللون الحالي: ${_arabicColorName(targetColor)}'
                      : '🎉 انتهى الاختبار! أحسنت!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        currentColorIndex < quizColors.length
                            ? Colors.black
                            : Colors.green.shade700,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 300,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 8),
                        ],
                      ),
                      child: GridView.builder(
                        itemCount: items.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemBuilder: (_, i) => buildColorCircle(i),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // 👇 طبقة التلميح
            if (showHint)
              GameHintOverlay(
                hintText: "🎨 اضغط على الدوائر واختر اللون المطلوب!",
                hintAnimation: "assets/animations/baby girl.json",
                onConfirm: () {
                  setState(() {
                    showHint = false;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

String _arabicColorName(String color) {
  final names = {
    'red': 'أحمر',
    'blue': 'أزرق',
    'green': 'أخضر',
    'orange': 'برتقالي',
    'black': 'أسود',
    'white': 'أبيض',
    'yellow': 'أصفر',
    'brown': 'بني',
    'pink': 'وردي',
  };
  return names[color] ?? color;
}

class ColorItem {
  final String color;
  bool visible;
  late AnimationController controller;
  late Animation<double> scale;

  ColorItem(this.color, {this.visible = true});

  void initAnimation(TickerProvider vsync) {
    controller = AnimationController(
      vsync: vsync,
      duration: Duration(milliseconds: 400),
    );

    scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  Color toColor() {
    switch (color) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'yellow':
        return Colors.yellow;
      case 'brown':
        return Colors.brown;
      case 'pink':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}
