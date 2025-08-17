import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:pro5/animations/sound_play.dart';

class LetterQuizScreen extends StatefulWidget {
  final String startLetter;
  final String endLetter;
  final int groupId;
  final List<Map<String, dynamic>> questions;

  const LetterQuizScreen({
    super.key,
    required this.startLetter,
    required this.endLetter,
    required this.groupId,
    required this.questions,
  });

  @override
  State<LetterQuizScreen> createState() => _LetterQuizScreenState();
}

class _LetterQuizScreenState extends State<LetterQuizScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  String selectedLetter = '';
  bool showResult = false;
  String resultMessage = '';
  bool isCorrect = false;
  String scalingLetter = '';
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<String> positiveMessages = ['تبارك الله', 'رائعة', 'ما شاء الله'];
  final List<String> negativeMessages = [
    'جرب مرة أخرى',
    'الإجابة خاطئة',
    'حاول مجددًا',
  ];

  double scaleFactor = 1.5;

  String getRandomMessage(List<String> messages) =>
      messages[Random().nextInt(messages.length)];

  void checkAnswer(String letter) {
    final correctAnswer = widget.questions[currentIndex]['correct_answer'];

    setState(() {
      selectedLetter = letter;
      isCorrect = letter == correctAnswer;
      showResult = true;
      resultMessage = getRandomMessage(
        isCorrect ? positiveMessages : negativeMessages,
      );
    });
    _controller.reset();
    _controller.forward();
    if (isCorrect) {
      SoundManager.playRandomCorrectSound(); // الإجابة صحيحة
    } else {
      SoundManager.playRandomWrongSound(); // الإجابة خاطئة
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      if (isCorrect && currentIndex < widget.questions.length - 1) {
        setState(() {
          currentIndex++;
          selectedLetter = '';
          showResult = false;
          scalingLetter = '';
        });
      } else if (isCorrect && currentIndex == widget.questions.length - 1) {
        Get.back(result: true);
      } else {
        setState(() {
          selectedLetter = '';
          showResult = false;
          scalingLetter = '';
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // إعداد التغير في الحجم
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentIndex];

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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 190),
                      Container(
                        height: 250,
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
                            // داخل Stack اللي فيه صورة السؤال
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  double scale = 1.0;
                                  Offset offset = Offset.zero;
                                  Color borderGlow = Colors.transparent;

                                  if (showResult && isCorrect) {
                                    // تكبير الصورة عند الإجابة الصحيحة
                                    scale = 1.0 + 0.3 * _controller.value;
                                    borderGlow = Colors.yellow.withOpacity(0.7);
                                  }

                                  if (showResult &&
                                      !isCorrect &&
                                      selectedLetter.isNotEmpty) {
                                    // اهتزاز الصورة عند الإجابة الخاطئة
                                    double dx =
                                        sin(_controller.value * 2 * pi * 4) * 8;
                                    offset = Offset(dx, 0);
                                    borderGlow = Colors.red.withOpacity(0.6);
                                  }

                                  return Transform.translate(
                                    offset: offset, // تطبيق الاهتزاز
                                    child: Transform.scale(
                                      scale: scale, // تطبيق التكبير/تصغير
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: borderGlow, // توهج اللون
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
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.8,
                                            ),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
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
                      const SizedBox(height: 190),
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
                                                  color: Colors.yellow
                                                      .withOpacity(0.8),
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
                                            isWrong
                                                ? Colors.white
                                                : Colors.black,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
