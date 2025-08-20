import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pro5/animations/sound_play.dart';

class GameHintOverlay extends StatefulWidget {
  final String hintText; // نص الإرشاد
  final String hintAnimation; // ملف Lottie
  final VoidCallback? onConfirm; // عند الضغط على زر "حسناً"

  const GameHintOverlay({
    super.key,
    required this.hintText,
    required this.hintAnimation,
    this.onConfirm,
  });

  @override
  State<GameHintOverlay> createState() => _GameHintOverlayState();
}

class _GameHintOverlayState extends State<GameHintOverlay> {
  bool _showHint = true;
  final AudioPlayer _player = AudioPlayer(); // مشغل الصوت

  @override
  void initState() {
    super.initState();
    SoundManager.play('assets/sounds/hello_sound/cartoon-music.mp3');
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _confirmHint() {
    setState(() => _showHint = false);
    widget.onConfirm?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_showHint)
          Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🎭 صورة الشخصية (Lottie)
                      Lottie.asset(widget.hintAnimation, height: 150),

                      const SizedBox(height: 15),

                      // 📝 النص
                      Text(
                        widget.hintText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Ghayaty',
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      // ✅ زر "حسناً"
                      ElevatedButton(
                        onPressed: _confirmHint,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "حسناً",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
