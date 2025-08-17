import 'package:flutter/material.dart';
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
  // قائمة الأسئلة مع التفاصيل (الصورة، النص، الخيارات، الإجابة الصحيحة)
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
  int currentQuestionIndex = 0; // السؤال الحالي
  int? selectedOptionIndex; // الخيار المختار
  bool answered = false; // هل تم الإجابة على السؤال

  // الانتقال للسؤال التالي أو عرض رسالة الانتهاء
  void nextQuestion() {
    setState(() {
      selectedOptionIndex = null;
      answered = false;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        setState(() {
          showCongratsScreen = true; // عرض شاشة الاحتفال بدلاً من AlertDialog
        });
      }
    });
  }

  // اختيار خيار والإعلام أن السؤال تم الإجابة عليه
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
          });
        },
      );
    }
    final question = questions[currentQuestionIndex];

    return Scaffold(
      // شفاف الخلفية عشان تظهر الصورة كاملة
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('اختبار الحواس'),
        centerTitle: true,
        backgroundColor: Colors.transparent, // شفافية AppBar
        elevation: 0,
      ),
      extendBodyBehindAppBar: true, // لتمديد الخلفية تحت الـ AppBar
      body: Stack(
        children: [
          // صورة الخلفية العنابية تغطي كل الشاشة
          Positioned.fill(
            child: Image.asset(
              'assets/images/حواس/خلفية.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // المحتوى فوق الخلفية
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
                    color: Colors.black, // نص أبيض يناسب الخلفية العنابية
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // عرض الخيارات مع تلوين حسب الإجابة الصحيحة والخاطئة
                ...List.generate(question.options.length, (index) {
                  Color optionColor = Colors.blue.shade100.withOpacity(0.8);
                  if (selectedOptionIndex != null) {
                    // فقط إذا تم اختيار إجابة
                    if (index == selectedOptionIndex) {
                      // إذا كان هذا هو الخيار المختار
                      optionColor =
                          (index == question.correctAnswerIndex)
                              ? Colors.green.shade300.withOpacity(
                                0.8,
                              ) // إذا كانت الإجابة صحيحة
                              : Colors.red.shade300.withOpacity(
                                0.8,
                              ); // إذا كانت الإجابة خاطئة
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
