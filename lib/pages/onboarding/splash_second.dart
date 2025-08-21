import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:pro5/animations/sound_play.dart';
import 'dart:async';
import 'package:pro5/pages/onboarding/onboarding.dart';

class SplashWorldScreen extends StatefulWidget {
  const SplashWorldScreen({super.key});

  @override
  State<SplashWorldScreen> createState() => _SplashWorldScreenState();
}

class _SplashWorldScreenState extends State<SplashWorldScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // تهيئة متحكم الرسوم المتحركة
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // تكوين تأثير النبض (التكبير والتصغير)
    _scaleAnimation = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 1.05),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.05, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // تكوين تأثير تذبذب الشفافية
    _opacityAnimation = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.7, end: 1.0),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 0.7),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    SoundManager.play('assets/sounds/hello_sound/الواجهة الأولى.mp3');

    // بدء تأثير النبض بشكل متكرر
    _controller.repeat(reverse: true);

    // الانتقال لشاشة الترحيب بعد 10 ثواني
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    // SoundManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة التطبيق مع تأثير النبض
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/images/backgrounds/ايقونة التطبيق.png',
                width: 300,
                height: 300,
              ),
            ),

            const SizedBox(height: 12),

            // 🔄 Lottie Animation مع تأثير النبض الخفيف
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.95 + (_scaleAnimation.value - 1.0) * 0.5,
                  child: child,
                );
              },
              child: Lottie.asset(
                'assets/animations/الساعة الرملية.json',
                width: 300,
                height: 300,
                repeat: true,
              ),
            ),

            const SizedBox(height: 20),

            // نص جاري التحميل مع تأثير النبض
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.8 + (_opacityAnimation.value - 0.7) * 0.5,
                  child: child,
                );
              },
              child: const Text(
                'جاري التحميل... يرجى الانتظار',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'Ghayaty',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
