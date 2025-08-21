import 'package:flutter/material.dart';
import 'package:pro5/animations/game_hint.dart';
import 'package:pro5/animations/result_page.dart';
import 'package:pro5/animations/sound_play.dart';

class Question {
  final String imageAsset;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.imageAsset,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class SensesQuizPage extends StatefulWidget {
  const SensesQuizPage({super.key});

  @override
  _SensesQuizPageState createState() => _SensesQuizPageState();
}

class _SensesQuizPageState extends State<SensesQuizPage> {
  final List<Question> questions = [
    Question(
      imageAsset: 'assets/images/حواس/اختبار حواس/قوس.png',
      questionText: 'لكي نرى هذا القوس نستخدم حاسة:',
      options: ['النظر', 'الشم', 'السمع', 'اللمس', 'التذوق'],
      correctAnswerIndex: 0,
    ),
    Question(
      imageAsset: 'assets/images/حواس/اختبار حواس/راديو.png',
      questionText: 'لكي نسمع الأصوات نستخدم حاسة:',
      options: ['اللمس', 'الشم', 'السمع', 'النظر', 'التذوق'],
      correctAnswerIndex: 2,
    ),
    Question(
      imageAsset: 'assets/images/حواس/اختبار حواس/وردة.png',
      questionText: 'لكي نشم هذه الوردة نستخدم حاسة:',
      options: ['الشم', 'النظر', 'اللمس', 'السمع', 'التذوق'],
      correctAnswerIndex: 0,
    ),
    Question(
      imageAsset: 'assets/images/حواس/اختبار حواس/مكعبات.png',
      questionText: 'لكي نلمس هذه المكعبات نستخدم حاسة:',
      options: ['اللمس', 'السمع', 'النظر', 'الشم', 'التذوق'],
      correctAnswerIndex: 0,
    ),
    Question(
      imageAsset: 'assets/images/حواس/اختبار حواس/ايسكريم ايسكريم.png',
      questionText: 'لكي نتذوق هذه التفاحة نستخدم حاسة:',
      options: ['التذوق', 'اللمس', 'النظر', 'الشم', 'السمع'],
      correctAnswerIndex: 0,
    ),
  ];

  bool showCongratsScreen = false;
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  bool answered = false;
  bool showHint = true;

  void nextQuestion() {
    setState(() {
      selectedOptionIndex = null;
      answered = false;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        showCongratsScreen = true;
      }
    });
  }

  void selectOption(int index) {
    setState(() {
      selectedOptionIndex = index;
      answered = true;
    });
    if (index == questions[currentQuestionIndex].correctAnswerIndex) {
      SoundManager.playRandomCorrectSound();
      Future.delayed(const Duration(milliseconds: 1000), () {
        nextQuestion();
      });
    } else {
      SoundManager.playRandomWrongSound();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showCongratsScreen) {
      return ResultScreen(
        animationPath: 'assets/animations/heart_fly.json',
        congratsImagePath: 'assets/rewards/انت متميز.png',
        onRestart: () {
          setState(() {
            currentQuestionIndex = 0;
            selectedOptionIndex = null;
            answered = false;
            showCongratsScreen = false;
            showHint = true;
          });
        },
      );
    }

    final question = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('اختبار الحواس'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // الخلفية
          Positioned.fill(
            child: Image.asset(
              'assets/images/حواس/خلفية.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          // شاشة التلميح
          // 👇 طبقة التلميح
          if (showHint)
            GameHintOverlay(
              hintText: "استخدم الحواس لتتعرف على الصور 👁️👂👅👃✋",
              hintAnimation: "assets/animations/baby girl.json",
              onConfirm: () {
                setState(() {
                  showHint = false;
                });
              },
            ),
          // محتوى الأسئلة
          if (!showHint)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Image.asset(question.imageAsset, height: 220),
                  const SizedBox(height: 20),
                  Text(
                    question.questionText,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(question.options.length, (index) {
                    Color optionColor = Colors.blue.shade100.withOpacity(0.8);
                    if (selectedOptionIndex != null) {
                      if (index == selectedOptionIndex) {
                        optionColor =
                            (index == question.correctAnswerIndex)
                                ? Colors.green.shade300.withOpacity(0.8)
                                : Colors.red.shade300.withOpacity(0.8);
                      }
                    }
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: optionColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () => selectOption(index),
                        child: Text(
                          question.options[index],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  }),
                  const Spacer(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
