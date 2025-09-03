import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:pro5/animations/result_page.dart';
import 'package:pro5/animations/sound_play.dart';
import 'package:pro5/pages/exames/letters/letter_questions.dart';
import 'package:pro5/utils/score_manager.dart';

class LetterQuizScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;

  const LetterQuizScreen({super.key, required this.questions});

  @override
  State<LetterQuizScreen> createState() => _LetterQuizScreenState();
}

class _LetterQuizScreenState extends State<LetterQuizScreen>
    with SingleTickerProviderStateMixin {
  bool showHint = true;
  int currentIndex = 0;
  int _score = 0; // العلامة
  late TestScoreManager scoreLetter;

  String selectedLetter = '';
  bool showResult = false;
  String resultMessage = '';
  bool isCorrect = false;
  String scalingLetter = '';
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _controller;
  late Animation<double> _animation;

  late List<Map<String, dynamic>> quizQuestions;

  @override
  void initState() {
    super.initState();

    scoreLetter = TestScoreManager(
      10,
      testName: "LetterQuiz",
      gameName: 'الأحرف العربية',
    );
    scoreLetter.reset();
    startHintTimer(); // أول سؤال
    // نخلط الأسئلة ونأخذ أول 10 فقط
    quizQuestions = List<Map<String, dynamic>>.from(widget.questions);
    quizQuestions.shuffle();
    quizQuestions = quizQuestions.take(10).toList();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  // داخل checkAnswer أو initState لكل سؤال جديد
  void startHintTimer() {
    setState(() {
      showHint = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        showHint = false;
      });
    });
  }

  void _restartGame() {
    setState(() {
      currentIndex = 0;
      _score = 0;
      selectedLetter = '';
      showResult = false;
      scalingLetter = '';
      scoreLetter.reset();
    });
  }

  void checkAnswer(String letter) async {
    final correctAnswer = quizQuestions[currentIndex]['correct_answer'];

    setState(() {
      selectedLetter = letter;
      isCorrect = letter == correctAnswer;
      showResult = true;
      resultMessage = isCorrect ? "إجابة صحيحة!" : "إجابة خاطئة!";
    });

    _controller.reset();
    _controller.forward();

    // تحديث العلامة لكل سؤال
    if (isCorrect) {
      scoreLetter.addCorrect();
      SoundManager.playRandomCorrectSound();
    } else {
      scoreLetter.addWrong();
      SoundManager.playRandomWrongSound();
    }

    // الانتقال للسؤال التالي بعد 2 ثانية
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;

      if (currentIndex < quizQuestions.length - 1) {
        setState(() {
          currentIndex++;
          selectedLetter = '';
          showResult = false;
          scalingLetter = '';
        });
        startHintTimer(); // تشغيل التلميح للسؤال الجديد
      } else {
        // ✅ بعد آخر سؤال نحفظ النتيجة مرة وحدة في Firebase
        await scoreLetter.saveScore();

        Get.to(
          () => ResultScreen(
            result: scoreLetter.finalScour,
            animationPath: 'assets/animations/fly baloon slowly.json',
            congratsImagePath: 'assets/rewards/مشاركة رائعة.png',
            onRestart: _restartGame,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = quizQuestions[currentIndex];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            const Image(
              image: AssetImage(
                'assets/images/letter&numbers/letters/bacquiz.jpg',
              ),
              fit: BoxFit.cover,
            ),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // 🔹 التلميح أعلى الشاشة
                  if (showHint)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        question['word'] ?? '',
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 20),

                  // 📸 الصورة
                  Expanded(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  double scale = 1.0;
                                  Offset offset = Offset.zero;
                                  Color borderGlow = Colors.transparent;

                                  if (showResult && isCorrect) {
                                    scale = 1.0 + 0.3 * _controller.value;
                                    borderGlow = Colors.yellow.withOpacity(0.7);
                                  }

                                  if (showResult &&
                                      !isCorrect &&
                                      selectedLetter.isNotEmpty) {
                                    double dx =
                                        sin(_controller.value * 2 * pi * 4) * 8;
                                    offset = Offset(dx, 0);
                                    borderGlow = Colors.red.withOpacity(0.6);
                                  }

                                  return Transform.translate(
                                    offset: offset,
                                    child: Transform.scale(
                                      scale: scale,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: borderGlow,
                                            width: 5,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: child,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  question['image'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),

                            if (showResult)
                              Positioned.fill(
                                child: AnimatedOpacity(
                                  opacity: showResult ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 500),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        resultMessage,
                                        style: TextStyle(
                                          fontSize: 28,
                                          color:
                                              isCorrect
                                                  ? Colors.yellow
                                                  : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ✏️ خيارات الأحرف
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children:
                        question['options'].map<Widget>((letter) {
                          final isSelected = selectedLetter == letter;
                          final isWrong =
                              isSelected &&
                              letter != question['correct_answer'];
                          final isScaling = scalingLetter == letter;

                          return GestureDetector(
                            onTap: () {
                              if (showResult) return;

                              setState(() {
                                scalingLetter = letter;
                              });
                              checkAnswer(letter);

                              Future.delayed(
                                const Duration(milliseconds: 150),
                                () {
                                  if (mounted) {
                                    setState(() {
                                      scalingLetter = '';
                                    });
                                  }
                                },
                              );
                            },
                            child: AnimatedScale(
                              scale: isScaling ? 1.2 : 1.0,
                              duration: const Duration(milliseconds: 150),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                width: 80,
                                height: 80,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      isCorrect && isSelected
                                          ? Colors.green
                                          : isWrong
                                          ? Colors.red
                                          : Colors.white,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow:
                                      isCorrect && isSelected
                                          ? [
                                            BoxShadow(
                                              color: Colors.yellow.withOpacity(
                                                0.8,
                                              ),
                                              blurRadius: 20,
                                              spreadRadius: 4,
                                            ),
                                          ]
                                          : [],
                                ),
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    fontSize: 30,
                                    color:
                                        isWrong ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
