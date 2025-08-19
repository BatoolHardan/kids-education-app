import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';

class ShapesQuizGame extends StatefulWidget {
  @override
  _ShapesQuizGameState createState() => _ShapesQuizGameState();
}

class _ShapesQuizGameState extends State<ShapesQuizGame> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentQuestion = 0;
  int _score = 0;
  int _wrongAttempts = 0;
  bool _showFeedback = false;
  bool _isCorrect = false;

  final List<Map<String, dynamic>> _shapes = [
    {
      'name': 'مُربَّع',
      'image': 'assets/images/shapes/square.png',
      'sound': ' ',
      'options': ['مُربَّع', 'مُستطيل', 'دائرة', 'مُثلث'],
    },
    {
      'name': 'دائرة',
      'image': 'assets/images/shapes/circle.png',
      'sound': 'assets/sounds/shapes_sound/دائرة.mp3',
      'options': ['دائرة', 'مُربَّع', 'نجمة', 'قلب'],
    },
    {
      'name': 'مُثلث',
      'image': 'assets/sounds/shapes_sound/مثلث.mp3',
      'sound': 'sounds/shapes/triangle.mp3',
      'options': ['مُثلث', 'مُستطيل', 'دائرة', 'سداسي'],
    },
    {
      'name': 'مُستطيل',
      'image': 'assets/sounds/shapes_sound/مستطيل.mp3',
      'sound': 'sounds/shapes/rectangle.mp3',
      'options': ['مُستطيل', 'مُربَّع', 'دائرة', 'بيضاوي'],
    },
    {
      'name': 'نجمة',
      'image': 'assets/sounds/shapes_sound/نجمة.mp3',
      'sound': 'sounds/shapes/star.mp3',
      'options': ['نجمة', 'قلب', 'دائرة', 'مُثلث'],
    },
    {
      'name': 'قلب',
      'image': 'assets/images/الأشكال/قلب.png',
      'sound': 'sounds/shapes/heart.mp3',
      'options': ['قلب', 'نجمة', 'دائرة', 'مُربَّع'],
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  void _checkAnswer(String selectedAnswer) {
    bool isCorrect = selectedAnswer == _shapes[_currentQuestion]['name'];

    setState(() {
      _showFeedback = true;
      _isCorrect = isCorrect;

      if (isCorrect) {
        _score++;
        _audioPlayer.play(AssetSource('sounds/correct.mp3'));
      } else {
        _wrongAttempts++;
        _audioPlayer.play(AssetSource('sounds/wrong.mp3'));
      }
    });

    Future.delayed(Duration(seconds: 2), () {
      if (_currentQuestion < _shapes.length - 1) {
        setState(() {
          _currentQuestion++;
          _showFeedback = false;
        });
      } else {
        // نهاية اللعبة
        _showResults();
      }
    });
  }

  void _showResults() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(child: Text('🎉 النتائج النهائية')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/animations/confetti.json', height: 100),
                SizedBox(height: 20),
                Text(
                  'الإجابات الصحيحة: $_score',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'الأخطاء: $_wrongAttempts',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  _score >= _shapes.length / 2
                      ? 'ممتاز! 👏'
                      : 'حاول مرة أخرى! 💪',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _restartGame();
                },
                child: Text('العب مرة أخرى'),
              ),
            ],
          ),
    );
  }

  void _restartGame() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _wrongAttempts = 0;
      _showFeedback = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعلم الأشكال'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.purple.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // شريط التقدم
            LinearProgressIndicator(
              value: (_currentQuestion + 1) / _shapes.length,
              backgroundColor: Colors.white30,
              valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
            ),

            // السؤال الحالي
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ما اسم هذا الشكل؟',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        _shapes[_currentQuestion]['image'],
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // الخيارات
            Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.5,
                ),
                itemCount: _shapes[_currentQuestion]['options'].length,
                itemBuilder: (ctx, index) {
                  String option = _shapes[_currentQuestion]['options'][index];
                  return ElevatedButton(
                    onPressed:
                        _showFeedback ? null : () => _checkAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor(option),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),

            // النتائج
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Chip(
                    label: Text('الصحيح: $_score'),
                    backgroundColor: Colors.green[100],
                  ),
                  Chip(
                    label: Text('الأخطاء: $_wrongAttempts'),
                    backgroundColor: Colors.red[100],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _getButtonColor(String option) {
    if (!_showFeedback) return Colors.white;

    if (option == _shapes[_currentQuestion]['name']) {
      return Colors.green; // الإجابة الصحيحة
    } else if (option != _shapes[_currentQuestion]['name'] &&
        _isCorrect == false) {
      return Colors.red; // الإجابة الخاطئة
    }
    return Colors.white; // اللون الطبيعي
  }
}
