import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro5/animations/result_page.dart';
import 'package:pro5/animations/sound_play.dart';
import 'package:pro5/pages/exames/letters/letter_questions.dart';
import 'package:pro5/pages/exames/letters/letter_quiz.dart';
import 'package:pro5/pages/exames/letters/success.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final Set<int> completedGroups = {};
  int currentGroupIndex = -1;
  bool showNextButton = false;
  final List<bool> _isPressed = List.generate(questions.length, (_) => false);
  bool showCongratsScreen = false;

  final letterGroups = [
    {
      'id': 0,
      'start': 'أ',
      'end': 'خ',
      'image': 'assets/images/letter&numbers/letters/1.jpg',
    },
    {
      'id': 1,
      'start': 'د',
      'end': 'ش',
      'image': 'assets/images/letter&numbers/letters/2.jpg',
    },
    {
      'id': 2,
      'start': 'ص',
      'end': 'ق',
      'image': 'assets/images/letter&numbers/letters/3.jpg',
    },
    {
      'id': 3,
      'start': 'ك',
      'end': 'ي',
      'image': 'assets/images/letter&numbers/letters/4.jpg',
    },
  ];

  int arabicLetterOrder(String letter) {
    const letters = 'ابتثجحخدذرزسشصضطظعغفقكلمنهوي';
    return letters.indexOf(letter);
  }

  void _initializeCards() {
    print('Cards initialized');
  }

  void _showResultScreen() {
    setState(() {
      showCongratsScreen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/letter&numbers/letters/bac0.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: 350,
                    height: 400,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: letterGroups.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (context, index) {
                        final group = letterGroups[index];
                        final startLetter = group['start'] as String;
                        final endLetter = group['end'] as String;
                        final groupId = group['id'] as int;
                        final isCompleted = completedGroups.contains(groupId);

                        return GestureDetector(
                          onTap:
                              isCompleted
                                  ? null
                                  : () async {
                                    await SoundManager.playPopSound();
                                    setState(() {
                                      _isPressed[index] = true;
                                    });
                                    await Future.delayed(
                                      const Duration(milliseconds: 200),
                                    );
                                    setState(() {
                                      _isPressed[index] = false;
                                    });

                                    currentGroupIndex = index;
                                    final startIndex = arabicLetterOrder(
                                      startLetter,
                                    );
                                    final endIndex = arabicLetterOrder(
                                      endLetter,
                                    );

                                    final filteredQuestions =
                                        questions.where((q) {
                                          final firstLetter = q['word']
                                              .toString()
                                              .substring(0, 1);
                                          final letterIndex = arabicLetterOrder(
                                            firstLetter,
                                          );
                                          return letterIndex >= startIndex &&
                                              letterIndex <= endIndex;
                                        }).toList();

                                    for (var q in filteredQuestions) {
                                      q['options'].shuffle();
                                    }

                                    final result = await Get.to(
                                      () => LetterQuizScreen(
                                        startLetter: startLetter,
                                        endLetter: endLetter,
                                        groupId: groupId,
                                        questions: filteredQuestions,
                                      ),
                                    );

                                    if (result == true) {
                                      setState(() {
                                        completedGroups.add(groupId);
                                        showNextButton = true;
                                      });

                                      await Get.to(
                                        () => ResultScreen(
                                          result: 0,
                                          animationPath:
                                              'assets/animations/baloon_fly and star.json',
                                          congratsImagePath:
                                              'assets/rewards/انت متميز.png',
                                          onRestart: () {
                                            _initializeCards();
                                            setState(() {
                                              showCongratsScreen = false;
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    }
                                  },
                          child: AnimatedScale(
                            scale: _isPressed[index] ? 0.9 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            child: Stack(
                              children: [
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: ColorFiltered(
                                      colorFilter:
                                          isCompleted
                                              ? const ColorFilter.mode(
                                                Colors.grey,
                                                BlendMode.saturation,
                                              )
                                              : const ColorFilter.mode(
                                                Colors.transparent,
                                                BlendMode.multiply,
                                              ),
                                      child: Image.asset(
                                        group['image'] as String,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isCompleted)
                                  const Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (showNextButton)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          showNextButton = false;
                        });

                        if (completedGroups.length == letterGroups.length) {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            Get.offAll(() => const SuccessScreen());
                          });
                        } else {
                          final nextIndex = currentGroupIndex + 1;
                          if (nextIndex < letterGroups.length) {
                            final nextGroup = letterGroups[nextIndex];
                            final nextStart = nextGroup['start'] as String;
                            final nextEnd = nextGroup['end'] as String;
                            final nextId = nextGroup['id'] as int;

                            final startIndex = arabicLetterOrder(nextStart);
                            final endIndex = arabicLetterOrder(nextEnd);

                            final nextQuestions =
                                questions.where((q) {
                                  final firstLetter = q['word']
                                      .toString()
                                      .substring(0, 1);
                                  final letterIndex = arabicLetterOrder(
                                    firstLetter,
                                  );
                                  return letterIndex >= startIndex &&
                                      letterIndex <= endIndex;
                                }).toList();

                            for (var q in nextQuestions) {
                              q['options'].shuffle();
                            }

                            Get.to(
                              () => LetterQuizScreen(
                                startLetter: nextStart,
                                endLetter: nextEnd,
                                groupId: nextId,
                                questions: nextQuestions,
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        completedGroups.length == letterGroups.length
                            ? 'انتهى'
                            : 'التالي',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
