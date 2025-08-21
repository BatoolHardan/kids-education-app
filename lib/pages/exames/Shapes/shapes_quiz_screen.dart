import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:get/get_core/src/get_main.dart';
import 'package:pro5/animations/game_hint.dart';
import 'package:pro5/animations/result_page.dart';

class ShapeMatchingGame extends StatefulWidget {
  const ShapeMatchingGame({super.key});

  @override
  _ShapeMatchingGameState createState() => _ShapeMatchingGameState();
}

class _ShapeMatchingGameState extends State<ShapeMatchingGame>
    with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<String> _wrongSounds = [
    'sounds/wrong1.mp3',
    'sounds/wrong2.mp3',
    'sounds/wrong3.mp3',
  ];
  final Random _random = Random();

  // بيانات الأشكال والصور الأصلية
  final List<Map<String, dynamic>> _originalItems = [
    {
      'shape': 'assets/images/shapes/rectangle.png',
      'image': 'assets/images/shapes/door.png',
      'shapeName': 'مستطيل',
      'sound': 'sounds/shapes/rectangle.mp3',
    },
    {
      'shape': 'assets/images/shapes/square.png',
      'image': 'assets/images/shapes/مثال مربع.png',
      'shapeName': 'مربع',
      'sound': 'sounds/shapes/square.mp3',
    },
    {
      'shape': 'assets/images/shapes/triangle.png',
      'image': 'assets/images/shapes/slice.png',
      'shapeName': 'مثلث',
      'sound': 'sounds/shapes/triangle.mp3',
    },
    {
      'shape': 'assets/images/shapes/circle.png',
      'image': 'assets/images/shapes/pizza.png',
      'shapeName': 'دائرة',
      'sound': 'sounds/shapes/circle.mp3',
    },
    {
      'shape': 'assets/images/shapes/بيضاوي.png',
      'image': 'assets/images/shapes/مثال بيضاوي.png',
      'shapeName': 'بيضاوي',
      'sound': 'sounds/shapes/oval.mp3',
    },
    {
      'shape': 'assets/images/shapes/star.png',
      'image': 'assets/images/shapes/starfish.png',
      'shapeName': 'نجمة',
      'sound': 'sounds/shapes/star.mp3',
    },
  ];

  List<Map<String, dynamic>> _items = [];
  List<int> _imageOrder = [];
  List<int> _shapeOrder = [];
  List<bool> _matchedItems = [];
  final List<ConnectionLine> _connectionLines = [];
  int? _selectedShapeIndex;
  int? _selectedImageIndex;
  bool showHint = true;
  // مفاتيح لتحديد موقع الصور والأشكال
  List<GlobalKey> _imageKeys = [];
  List<GlobalKey> _shapeKeys = [];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  @override
  void dispose() {
    for (var line in _connectionLines) {
      line.controller.dispose();
    }
    super.dispose();
  }

  void _initializeGame() {
    _items = List.from(_originalItems);

    _imageOrder = List.generate(_items.length, (index) => index);
    _shapeOrder = List.generate(_items.length, (index) => index);

    _imageOrder.shuffle();

    _matchedItems = List.filled(_items.length, false);

    _imageKeys = List.generate(_items.length, (_) => GlobalKey());
    _shapeKeys = List.generate(_items.length, (_) => GlobalKey());

    setState(() {});
  }

  void playRandomWrongSound() {
    int randomIndex = _random.nextInt(_wrongSounds.length);
    _audioPlayer.play(AssetSource(_wrongSounds[randomIndex]));
  }

  void _onShapeTap(int displayedIndex) {
    int realShapeIndex = _shapeOrder[displayedIndex];
    if (_matchedItems[realShapeIndex]) return;

    setState(() {
      if (_selectedShapeIndex == displayedIndex) {
        _selectedShapeIndex = null;
      } else {
        _selectedShapeIndex = displayedIndex;
        _selectedImageIndex = null;
      }
    });
  }

  void _onImageTap(int displayedIndex) {
    int realImageIndex = _imageOrder[displayedIndex];
    if (_matchedItems[realImageIndex]) return;

    setState(() {
      if (_selectedImageIndex == displayedIndex) {
        _selectedImageIndex = null;
      } else {
        _selectedImageIndex = displayedIndex;
        if (_selectedShapeIndex != null) {
          _tryConnect(_selectedShapeIndex!, displayedIndex);
        }
      }
    });
  }

  void _tryConnect(int displayedShapeIndex, int displayedImageIndex) {
    int realShapeIndex = _shapeOrder[displayedShapeIndex];
    int realImageIndex = _imageOrder[displayedImageIndex];

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    final connectionLine = ConnectionLine(
      shapeIndex: displayedShapeIndex,
      imageIndex: displayedImageIndex,
      isCorrect: realShapeIndex == realImageIndex,
      realShapeIndex: realShapeIndex,
      controller: controller,
      animation: animation,
    );

    setState(() {
      _connectionLines.add(connectionLine);
      _selectedShapeIndex = null;
      _selectedImageIndex = null;
    });

    controller.forward().whenComplete(() {
      if (!connectionLine.isCorrect) {
        setState(() {
          _connectionLines.remove(connectionLine);
          controller.dispose();
        });
      }
    });

    if (realShapeIndex == realImageIndex) {
      _audioPlayer.play(AssetSource(_items[realShapeIndex]['sound']));
      setState(() {
        _matchedItems[realShapeIndex] = true;

        // تحقق إذا كانت كل العناصر مطابقة

        if (_matchedItems.every((matched) => matched)) {
          Future.delayed(const Duration(milliseconds: 300), () {
            // استخدمي GetX لفتح ResultScreen
            Get.to(
              () => ResultScreen(
                animationPath: 'assets/animations/Star Success.json',
                congratsImagePath: 'assets/rewards/مشاركة رائعة.png',
                onRestart: _resetGame,
              ),
            );
          });
        }
      });
    } else {
      playRandomWrongSound();
    }
  }

  void _resetGame() {
    setState(() {
      _connectionLines.clear();
      _matchedItems = List.filled(_items.length, false);
      _selectedShapeIndex = null;
      _selectedImageIndex = null;
      _imageOrder.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/واجهة الاختبارات/خلفية2.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            ..._drawConnectionLines(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
                  child: Text(
                    ' توصيل الأشكال',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ghayaty',
                      color: Colors.deepPurple,
                      shadows: const [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(_items.length, (
                              displayedIndex,
                            ) {
                              int realIndex = _imageOrder[displayedIndex];
                              return GestureDetector(
                                onTap: () => _onImageTap(displayedIndex),
                                child: Container(
                                  key: _imageKeys[displayedIndex],
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border:
                                        _selectedImageIndex == displayedIndex
                                            ? Border.all(
                                              color: Colors.orange,
                                              width: 3,
                                            )
                                            : null,
                                    color:
                                        _matchedItems[realIndex]
                                            ? Colors.green.withOpacity(0.3)
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    _items[realIndex]['image'],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onDoubleTap: _resetGame,
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _selectedShapeIndex != null
                                      ? 'اختر الصورة المناسبة'
                                      : 'اختر شكلاً أولاً',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Ghayaty',
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'انقر نقرتين لإعادة الخلط',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontFamily: 'Ghayaty',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(_items.length, (
                              displayedIndex,
                            ) {
                              int realIndex = _shapeOrder[displayedIndex];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => _onShapeTap(displayedIndex),
                                    child: Container(
                                      key: _shapeKeys[displayedIndex],
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        border:
                                            _selectedShapeIndex ==
                                                    displayedIndex
                                                ? Border.all(
                                                  color: Colors.blue,
                                                  width: 3,
                                                )
                                                : null,
                                        color:
                                            _matchedItems[realIndex]
                                                ? Colors.green.withOpacity(0.3)
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.asset(
                                        _items[realIndex]['shape'],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _items[realIndex]['shapeName'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Ghayaty',
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // 👇 شاشة التلميح كطبقة فوق اللعبة
            if (showHint)
              Positioned.fill(
                child: GameHintOverlay(
                  // hintText: "استخدم الحواس لتتعرف على الصور 👁️👂👅👃✋",
                  hintText:
                      "وصل الشكل الصحيح مع صورته المناسبة ✏️\n\nمثال: ◯ → 🔵",
                  hintAnimation: "assets/animations/baby girl.json",
                  onConfirm: () {
                    setState(() {
                      showHint = false; // يخفي التلميح ويبدأ اللعب
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _drawConnectionLines() {
    List<Widget> lines = [];
    for (var line in _connectionLines) {
      final shapeBox =
          _shapeKeys[line.shapeIndex].currentContext?.findRenderObject()
              as RenderBox?;
      final imageBox =
          _imageKeys[line.imageIndex].currentContext?.findRenderObject()
              as RenderBox?;
      if (shapeBox != null && imageBox != null) {
        final shapePos = shapeBox.localToGlobal(Offset.zero);
        final imagePos = imageBox.localToGlobal(Offset.zero);

        final start =
            imagePos +
            Offset(imageBox.size.width / 2, imageBox.size.height / 2);
        final end =
            shapePos +
            Offset(shapeBox.size.width / 2, shapeBox.size.height / 2);

        lines.add(
          AnimatedBuilder(
            animation: line.animation,
            builder: (context, _) {
              return Positioned.fill(
                child: CustomPaint(
                  painter: LinePainter(
                    start: start,
                    end: end,
                    color: line.isCorrect ? Colors.green : Colors.red,
                    isDashed: !line.isCorrect,
                    progress: line.animation.value, // 💡 التغيير
                  ),
                ),
              );
            },
          ),
        );
      }
    }
    return lines;
  }
}

class ConnectionLine {
  final int shapeIndex;
  final int imageIndex;
  final bool isCorrect;
  final int realShapeIndex;
  final AnimationController controller;
  final Animation<double> animation;
  ConnectionLine({
    required this.shapeIndex,
    required this.imageIndex,
    required this.isCorrect,
    required this.realShapeIndex,
    required this.controller,
    required this.animation,
  });
}

class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;
  final bool isDashed;
  final double progress;
  LinePainter({
    required this.start,
    required this.end,
    required this.color,
    this.isDashed = false,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

    final Offset currentEnd = Offset.lerp(start, end, progress)!;

    if (isDashed) {
      final double dashWidth = 10;
      final double dashSpace = 5;
      double distance = (currentEnd - start).distance;
      int dashes = (distance / (dashWidth + dashSpace)).floor();
      for (int i = 0; i < dashes; i++) {
        final double t = i / dashes;
        final double nextT = (i + dashWidth / (dashWidth + dashSpace)) / dashes;
        final Offset dashStart = Offset.lerp(start, currentEnd, t)!;
        final Offset dashEnd = Offset.lerp(start, currentEnd, nextT)!;
        canvas.drawLine(dashStart, dashEnd, paint);
      }
    } else {
      canvas.drawLine(start, currentEnd, paint);
    }
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.color != color ||
        oldDelegate.isDashed != isDashed;
  }
}
