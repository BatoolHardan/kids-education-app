import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class GameHintOverlay extends StatefulWidget {
  final String hintText; // نص الإرشاد
  final String hintImage; // صورة الإرشاد
  final Duration showHintFor; // مدة عرض الإرشاد قبل بدء اللعبة
  final Duration delayBeforeHint; // الوقت قبل عرض التلميح
  final VoidCallback? onSuccess; // عند النجاح

  const GameHintOverlay({
    super.key,
    required this.hintText,
    required this.hintImage,
    this.showHintFor = const Duration(seconds: 3),
    this.delayBeforeHint = const Duration(seconds: 5),
    this.onSuccess,
  });

  @override
  State<GameHintOverlay> createState() => _GameHintOverlayState();
}

class _GameHintOverlayState extends State<GameHintOverlay>
    with SingleTickerProviderStateMixin {
  bool _showInitialHint = true;
  bool _showHintGlow = false;
  bool _showBalloons = false;
  late AnimationController _glowController;

  final AudioPlayer _player = AudioPlayer();
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // تحكم بالوميض
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // بعد مدة عرض الإرشاد، نخفيه
    Future.delayed(widget.showHintFor, () {
      setState(() => _showInitialHint = false);

      // بعد مدة ثانية، نبدأ الوميض كتلميح
      Future.delayed(widget.delayBeforeHint, () {
        if (!_showBalloons) {
          setState(() => _showHintGlow = true);
        }
      });
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _player.dispose();
    super.dispose();
  }

  // هذه تستدعيها اللعبة عند النجاح
  void showSuccessEffect() {
    widget.onSuccess?.call();
    setState(() {
      _showHintGlow = false;
      _showBalloons = true;
    });

    // تشغيل الصوت
    _player.play(AssetSource('sounds/success.mp3'));

    // إخفاء البالونات بعد 3 ثواني
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => _showBalloons = false);
    });
  }

  Widget _buildBalloon(Color color, double startLeft) {
    double sway = _random.nextDouble() * 30 + 10; // مدى التأرجح
    int duration = _random.nextInt(2000) + 2000; // مدة الحركة

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: MediaQuery.of(context).size.height, end: -100),
      duration: Duration(milliseconds: duration),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        double horizontalOffset = sin(value / 50) * sway;
        return Positioned(
          left: startLeft + horizontalOffset,
          top: value,
          child: child!,
        );
      },
      child: Icon(Icons.circle, color: color, size: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الطبقة الشفافة فوق اللعبة
        if (_showInitialHint)
          Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(widget.hintImage, height: 100),
                      const SizedBox(height: 10),
                      Text(
                        widget.hintText,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // التلميح اللامع بعد التأخير
        if (_showHintGlow)
          Positioned(
            top: 200,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: FadeTransition(
              opacity: _glowController,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange, width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

        // بالونات النجاح الملونة المتأرجحة
        if (_showBalloons)
          ...List.generate(8, (index) {
            double startLeft =
                _random.nextDouble() * MediaQuery.of(context).size.width;
            Color color =
                [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                  Colors.cyan,
                ][index % 8];
            return _buildBalloon(color, startLeft);
          }),
      ],
    );
  }
}
