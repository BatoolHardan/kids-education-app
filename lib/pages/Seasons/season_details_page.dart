import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pro5/animations/sound_play.dart';

class SeasonDetailsPage extends StatefulWidget {
  final String name;

  const SeasonDetailsPage({
    super.key,
    required this.name,
    required color,
    required image,
  });

  @override
  State<SeasonDetailsPage> createState() => _SeasonDetailsPageState();
}

class _SeasonDetailsPageState extends State<SeasonDetailsPage>
    with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AnimationController _titleController;
  late Animation<double> _titleAnimation;
  List<String> _words = [];
  List<bool> _showWord = [];
  AudioPlayer? _popPlayer;
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // تحضير العنوان مع حركة تكبير
    _titleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _titleAnimation = CurvedAnimation(
      parent: _titleController,
      curve: Curves.bounceOut,
    );
    _titleController.forward();

    // تحضير النص للكارد الأبيض
    _words = _descriptionFor(widget.name).split(' ');
    _showWord = List.filled(_words.length, false);

    // تشغيل صوت الفصل عند دخول الصفحة
    _playSeasonSound();

    // بدء إظهار الكلمات تدريجيًا بعد نصف ثانية من العنوان
    Future.delayed(Duration(milliseconds: 500), () {
      _showWordsSequentially();
    });
  }

  Future<void> _playSeasonSound() async {
    try {
      await _audioPlayer.stop();
      // تشغيل الصوت حسب الفصل
      await _audioPlayer.play(AssetSource(_audioForSeason(widget.name)));
    } catch (e) {
      debugPrint('Error playing season sound: $e');
      Get.snackbar('خطأ', 'تعذر تشغيل صوت الفصل');
    }
  }

  Future<void> _showWordsSequentially() async {
    for (int i = 0; i < _words.length; i++) {
      await Future.delayed(Duration(milliseconds: 300));
      setState(() {
        _showWord[i] = true;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(_backgroundFor(widget.name), fit: BoxFit.cover),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // العنوان
                  ScaleTransition(
                    scale: _titleAnimation,
                    child: Text(
                      'فصل ${widget.name}',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black87,
                            offset: Offset(3, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // كارد النص
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: List.generate(_words.length, (index) {
                          return AnimatedScale(
                            scale: _showWord[index] ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.bounceOut,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              child: Text(
                                _words[index],
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _colorFor(widget.name),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                    },

                    child: Text(
                      'رجوع',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// دوال المساعدة
String _backgroundFor(String season) {
  switch (season) {
    case 'الربيع':
      return 'assets/images/الفصول الأربعة/ربيع1.jpg';
    case 'الصيف':
      return 'assets/images/الفصول الأربعة/صيف1.jpg';
    case 'الخريف':
      return 'assets/images/الفصول الأربعة/خريف1.jpg';
    case 'الشتاء':
      return 'assets/images/الفصول الأربعة/شتاء1.jpg';
    default:
      return 'assets/images/الفصول الأربعة/ربيع1.jpg';
  }
}

String _descriptionFor(String season) {
  switch (season) {
    case 'الربيع':
      return 'في الربيع تتفتح الأزهار وتعتدل الأجواء.';
    case 'الصيف':
      return 'في الصيف نلعب على الشاطئ والجو حار.';
    case 'الخريف':
      return 'في الخريف تتساقط أوراق الأشجار.';
    case 'الشتاء':
      return 'في الشتاء يكون الطقس باردًا وقد تتساقط الثلوج.';
    default:
      return '';
  }
}

Color _colorFor(String season) {
  switch (season) {
    case 'الربيع':
      return Colors.greenAccent.shade700;
    case 'الصيف':
      return Colors.deepOrangeAccent.shade700;
    case 'الخريف':
      return Colors.brown.shade700;
    case 'الشتاء':
      return Colors.lightBlueAccent.shade700;
    default:
      return Colors.black;
  }
}

String _audioForSeason(String season) {
  switch (season) {
    case 'الربيع':
      return 'sounds/sean_sound/الربيع.mp3';
    case 'الصيف':
      return 'sounds/sean_sound/الصيف.mp3';
    case 'الخريف':
      return 'sounds/sean_sound/الخريف.mp3';
    case 'الشتاء':
      return 'sounds/sean_sound/الشتاء.mp3';
    default:
      return 'assets/sounds/hello_sound/ding-cartoon.mp3';
  }
}
