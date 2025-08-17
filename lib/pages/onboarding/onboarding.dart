import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:pro5/pages/onboarding/login_page.dart';
import 'package:pro5/pages/onboarding/sign_up_full.dart';
import 'package:pro5/pages/stag_three_four.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _characterController;
  late AnimationController _starAnimationController;
  bool showCloud1 = false;
  bool showCloud2 = false;
  bool showCloud3 = false;
  double cloud1Scale = 1.0;
  double cloud2Scale = 1.0;
  double cloud3Scale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _characterController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _starAnimationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..forward();
    // ✅ تحقق من تسجيل الدخول
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // المستخدم مسجل دخول بالفعل → ننتقل مباشرة للصفحة الرئيسية
      Future.delayed(Duration.zero, () {
        Get.offAll(
          () => StageThreeFourScreen(),
        ); // بدليها باسم صفحتك الرئيسية الفعلية
      });
      return;
    }


    _startCloudSequence();
  }

  void _startCloudSequence() async {
    while (true) {
      // Cloud 1
      setState(() {
        showCloud1 = true;
        cloud1Scale = 0.0;
      });

      for (double scale = 0; scale <= 1; scale += 0.1) {
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() => cloud1Scale = scale);
      }

      await Future.delayed(const Duration(seconds: 3));

      for (double scale = 1; scale >= 0; scale -= 0.1) {
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() => cloud1Scale = scale);
      }
      setState(() => showCloud1 = false);

      // Cloud 2
      setState(() {
        showCloud2 = true;
        cloud2Scale = 0.0;
      });

      for (double scale = 0; scale <= 1; scale += 0.1) {
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() => cloud2Scale = scale);
      }

      await Future.delayed(const Duration(seconds: 3));

      for (double scale = 1; scale >= 0; scale -= 0.1) {
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() => cloud2Scale = scale);
      }
      setState(() => showCloud2 = false);

      // Cloud 3
      setState(() {
        showCloud3 = true;
        cloud3Scale = 0.0;
      });

      for (double scale = 0; scale <= 1; scale += 0.1) {
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() => cloud3Scale = scale);
      }

      await Future.delayed(const Duration(seconds: 3));

      for (double scale = 1; scale >= 0; scale -= 0.1) {
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() => cloud3Scale = scale);
      }
      setState(() => showCloud3 = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _characterController.dispose();
    _starAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            // النجوم المتحركة في الخلفية
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _starAnimationController,
                  builder: (_, __) {
                    return CustomPaint(
                      painter: _StarPainter(
                        _controller.value,
                        _starAnimationController,
                      ),
                    );
                  },
                ),
              ),
            ),

            // الشخصية الرئيسية
            Center(
              child: AnimatedBuilder(
                animation: _characterController,
                builder: (context, child) {
                  return Transform(
                    transform:
                        Matrix4.identity()
                          ..translate(0.0, -15 * _characterController.value)
                          ..rotateZ(0.02 * _characterController.value),
                    child: Lottie.asset(
                      'assets/animations/girl.json',
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                      controller: _controller,
                      animate: true,
                    ),
                  );
                },
              ),
            ),

            // الغيوم الثلاثة
            if (showCloud1)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: 50,
                left: 20,
                child: Transform.scale(
                  scale: cloud1Scale,
                  child: _SpeechBubble(
                    text: "يدعم اللغة العربية",
                    icon: Icons.translate,
                    color: Colors.orange[200]!,
                    tailDirection: TailDirection.right,
                  ),
                ),
              ),

            if (showCloud2)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: 80,
                right: 20,
                child: Transform.scale(
                  scale: cloud2Scale,
                  child: _SpeechBubble(
                    text: "تنمية السمع والبصر",
                    icon: Icons.hearing,
                    color: Colors.green[200]!,
                    tailDirection: TailDirection.left,
                  ),
                ),
              ),

            if (showCloud3)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                bottom: 120,
                left: MediaQuery.of(context).size.width / 2 - 80,
                child: Transform.scale(
                  scale: cloud3Scale,
                  child: _SpeechBubble(
                    text: "نظام مكافآت\nوللوحة تحكم أبوية",
                    icon: Icons.family_restroom,
                    color: Colors.purple[200]!,
                    tailDirection: TailDirection.bottom,
                  ),
                ),
              ),

            // الزر الرئيسي
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_controller.value * 0.1),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => LoginScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                          shadowColor: Colors.blue.withOpacity(0.5),
                        ),
                        child: const Text(
                          'انطلق إلى رحلة المتعة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final double animationValue;
  final AnimationController starAnimationController;

  _StarPainter(this.animationValue, this.starAnimationController);

  @override
  void paint(Canvas canvas, Size size) {
    final progress = starAnimationController.value;

    final paint =
        Paint()
          ..color = Colors.amber.withOpacity(0.3 * progress)
          ..style = PaintingStyle.fill;

    final starPath =
        Path()
          ..moveTo(0, -12)
          ..lineTo(3, -4)
          ..lineTo(12, 0)
          ..lineTo(3, 4)
          ..lineTo(0, 12)
          ..lineTo(-3, 4)
          ..lineTo(-12, 0)
          ..lineTo(-3, -4)
          ..close();

    final random = Random(42);

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      final starProgress = progress.clamp(0, 1) * 1.5 - (i / 100);
      if (starProgress <= 0) continue;

      final scale = (0.7 + (random.nextDouble() * 0.6)) * starProgress;

      canvas.save();
      canvas.translate(x, y);
      canvas.scale(scale);
      canvas.drawPath(starPath, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

enum TailDirection { left, right, bottom }

class _SpeechBubble extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final TailDirection tailDirection;

  const _SpeechBubble({
    required this.text,
    required this.icon,
    required this.color,
    required this.tailDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: const BoxConstraints(maxWidth: 160),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 24, color: Colors.white),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: tailDirection == TailDirection.left ? 10 : null,
            right: tailDirection == TailDirection.right ? 10 : null,
            bottom: tailDirection == TailDirection.bottom ? -8 : null,
            top: tailDirection != TailDirection.bottom ? null : 10,
            child: CustomPaint(
              size: const Size(20, 12),
              painter: _BubbleTailPainter(
                color: color,
                direction: tailDirection,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  final Color color;
  final TailDirection direction;

  _BubbleTailPainter({required this.color, required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    switch (direction) {
      case TailDirection.left:
        path.moveTo(0, size.height / 2);
        path.quadraticBezierTo(size.width, 0, size.width, size.height);
        break;
      case TailDirection.right:
        path.moveTo(size.width, size.height / 2);
        path.quadraticBezierTo(0, 0, 0, size.height);
        break;
      case TailDirection.bottom:
        path.moveTo(size.width / 2, size.height);
        path.quadraticBezierTo(0, 0, size.width, 0);
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
