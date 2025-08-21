import 'package:flutter/material.dart';
import 'package:pro5/animations/game_hint.dart';

import 'package:pro5/animations/result_page.dart';
import 'dart:math';

import 'package:pro5/animations/sound_play.dart';

class NumberDragDropGame extends StatefulWidget {
  @override
  _NumberDragDropGameState createState() => _NumberDragDropGameState();
}

class _NumberDragDropGameState extends State<NumberDragDropGame> {
  final int itemCount = 10;
  final List<int> correctNumbers = List.generate(10, (i) => i + 1);

  late List<int> draggableNumbers;
  Map<int, int?> placedNumbers = {};
  bool showHintOverlay = true; // متغير للتحكم بعرض التلميح
  @override
  void dispose() {
    super.dispose();
  }

  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    draggableNumbers = List.from(correctNumbers);
    draggableNumbers.shuffle(Random());
    placedNumbers = Map.fromIterable(
      correctNumbers,
      key: (e) => e,
      value: (_) => null,
    );
    showHintOverlay = true; // إعادة عرض التلميح عند إعادة اللعبة
    setState(() {});
  }

  String convertToArabicNumber(int number) {
    final arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    final digits = number.toString().split('');
    return digits.map((d) => arabicNumbers[int.parse(d)]).join();
  }

  Color pinkColor = Colors.pink.shade300;

  bool isGameFinished() {
    return placedNumbers.values.every((element) => element != null);
  }

  // دالة لإخفاء التلميح
  void _hideHintOverlay() {
    setState(() {
      showHintOverlay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isGameFinished()) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => ResultScreen(
                  animationPath: 'assets/animations/baloon_fly yellow.json',
                  congratsImagePath: 'assets/rewards/بارك الله فيك.png',
                  onRestart: () {
                    Navigator.pop(context);
                  },
                ),
          ),
        ).then((_) {
          // بعد رجوعنا من شاشة النتائج، نعيد تهيئة اللعبة
          resetGame();
        });
      });

      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('لعبة السحب والإفلات - الأرقام'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/animalPicture/animal_game/bac.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  height: 140,
                  child: GridView.count(
                    crossAxisCount: 5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    physics: NeverScrollableScrollPhysics(),
                    children:
                        correctNumbers.map((number) {
                          int? placed = placedNumbers[number];
                          bool filled = placed != null;
                          return DragTarget<int>(
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color:
                                      filled
                                          ? Colors.green.shade300.withOpacity(
                                            0.8,
                                          )
                                          : Colors.white.withOpacity(0.8),
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  filled
                                      ? convertToArabicNumber(placed!)
                                      : convertToArabicNumber(number),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: filled ? Colors.white : Colors.grey,
                                  ),
                                ),
                              );
                            },
                            onWillAccept: (data) {
                              bool isCorrect = data == number;
                              if (!isCorrect) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  SoundManager.playRandomWrongSound();
                                });
                              }
                              return isCorrect;
                            },
                            onAccept: (data) async {
                              if (data == number) {
                                await SoundManager.playRandomCorrectSound();
                              }
                              setState(() {
                                placedNumbers[number] = data;
                                draggableNumbers.remove(data);
                              });
                            },
                          );
                        }).toList(),
                  ),
                ),

                Spacer(),

                Container(
                  height: 140,
                  child: GridView.count(
                    crossAxisCount: 5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    physics: NeverScrollableScrollPhysics(),
                    children:
                        draggableNumbers.map((num) {
                          return Draggable<int>(
                            data: num,
                            feedback: buildDraggableNumber(num, opacity: 0.7),
                            childWhenDragging: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: pinkColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: buildDraggableNumber(num),
                          );
                        }).toList(),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
          if (showHintOverlay)
            GameHintOverlay(
              hintText:
                  "اسحب الأرقام وضعها في المكان الصحيح حسب الترتيب من ١ إلى ١٠",
              hintAnimation: "assets/animations/baby girl.json",
              onConfirm: _hideHintOverlay,
            ),
        ],
      ),
    );
  }

  Widget buildDraggableNumber(int num, {double opacity = 1}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: pinkColor.withOpacity(opacity),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(1, 2)),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        convertToArabicNumber(num),
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(opacity),
        ),
      ),
    );
  }
}
