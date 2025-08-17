import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:pro5/animations/result_page.dart';
import 'package:pro5/animations/sound_play.dart';

// تأكد من استيراد ResultScreen إذا كانت في ملف منفصل
// import 'path_to_result_screen/result_screen.dart';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  final int gridSize = 18;

  List<String> images = [
    'assets/images/animalPicture/animal_game/اسد.png',
    'assets/images/animalPicture/animal_game/افعى.png',
    'assets/images/animalPicture/animal_game/بعرفش اسمو.png',
    'assets/images/animalPicture/animal_game/بومة.png',
    'assets/images/animalPicture/animal_game/تمساح.png',
    'assets/images/animalPicture/animal_game/ثعلب.png',
    'assets/images/animalPicture/animal_game/حمار وحشي.png',
    'assets/images/animalPicture/animal_game/دب الباندا.png',
    'assets/images/animalPicture/animal_game/طاووس.png',
  ];

  String backImage = 'assets/images/animalPicture/animal_game/bac2.png';

  List<Map<String, dynamic>> cards = [];
  List<int> selectedIndexes = [];
  int score = 0;
  bool allowClick = true;

  bool showAnimation = false;
  bool showCongratsScreen = false;
  bool showLikeAnimation = false; // متغير جديد

  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) {
        print('[DEBUG] ${DateTime.now()}: $message');
      }
    };
    _initializeCards();
  }

  void _initializeCards() {
    List<String> cardImages = [...images, ...images];
    cardImages.shuffle(Random());

    cards = List.generate(gridSize, (index) {
      return {'image': cardImages[index], 'revealed': false, 'matched': false};
    });

    setState(() {
      score = 0;
      selectedIndexes = [];
      allowClick = true;
      showAnimation = false;
      showCongratsScreen = false;
    });
  }

  Future<void> _handleCardTap(int index) async {
    if (!allowClick || cards[index]['revealed'] || cards[index]['matched']) {
      return;
    }

    setState(() {
      cards[index]['revealed'] = true;
      selectedIndexes.add(index);
    });

    if (selectedIndexes.length == 2) {
      allowClick = false;

      int first = selectedIndexes[0];
      int second = selectedIndexes[1];
      bool isMatch = cards[first]['image'] == cards[second]['image'];

      if (isMatch) {
        await SoundManager.playRandomCorrectSound();
        setState(() {
          cards[first]['matched'] = true;
          cards[second]['matched'] = true;
          score++;
          showLikeAnimation = true;
        });
        Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() => showLikeAnimation = false);
          }
        });
      } else {
        await SoundManager.playRandomWrongSound();
        await Future.delayed(
          const Duration(milliseconds: 1000),
        ); // وقت لرؤية البطاقات

        setState(() {
          cards[first]['revealed'] = false;
          cards[second]['revealed'] = false;
        });
      }

      selectedIndexes.clear();
      allowClick = true;

      if (cards.every((card) => card['matched'])) {
        setState(() => showAnimation = true);
        Timer(const Duration(seconds: 3), () {
          setState(() => showCongratsScreen = true);
        });
      }
    }
  }

  Widget _buildCard(int index) {
    var card = cards[index];
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlipCard(
          frontImage: card['image'],
          backImage: backImage,
          isFlipped: card['revealed'] || card['matched'],
          onTap: () => _handleCardTap(index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showAnimation) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Lottie.asset('assets/animations/baloon_fly and star.json'),
        ),
      );
    }

    if (showCongratsScreen) {
      return ResultScreen(
        animationPath: 'assets/animations/baloon_fly and star.json',
        congratsImagePath: 'assets/rewards/انت متميز.png',
        onRestart: () {
          _initializeCards();
          setState(() {
            showCongratsScreen = false;
          });
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('لعبة الذاكرة'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 16),
              Text('النقاط: $score', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: cards.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (_, index) => _buildCard(index),
                ),
              ),
            ],
          ),

          // عرض الانيميشن عند التطابق
          if (showLikeAnimation)
            Center(
              child: Lottie.asset(
                'assets/animations/like.json',
                width:
                    MediaQuery.of(context).size.width *
                    0.8, // 80% من عرض الشاشة
                height:
                    MediaQuery.of(context).size.height *
                    0.4, // 40% من ارتفاع الشاشة
                repeat: true,
                fit: BoxFit.contain,
              ),
            ),
        ],
      ),
    );
  }
}

// كلاس FlipCard كما هو في كودك السابق
class FlipCard extends StatefulWidget {
  final String frontImage;
  final String backImage;
  final bool isFlipped;
  final VoidCallback onTap;

  const FlipCard({
    super.key,
    required this.frontImage,
    required this.backImage,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: pi).animate(_controller);

    if (widget.isFlipped) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!widget.isFlipped) {
          await SoundManager.playPopSound();
        }
        widget.onTap(); // بعدين يكمل المنطق تبع اللعبة
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          bool isFront = _animation.value <= pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_animation.value),
            child:
                isFront
                    ? Image.asset(widget.backImage, fit: BoxFit.cover)
                    : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: Image.asset(widget.frontImage, fit: BoxFit.cover),
                    ),
          );
        },
      ),
    );
  }
}
