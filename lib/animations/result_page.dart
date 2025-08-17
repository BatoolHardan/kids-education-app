 import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pro5/pages/onboarding/custom_buttom.dart';

class ResultScreen extends StatelessWidget {
  final String animationPath;
  final String congratsImagePath;
  final VoidCallback onRestart;

  const ResultScreen({
    super.key,
    required this.animationPath,
    required this.congratsImagePath,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return _ResultScreenBody(
      animationPath: animationPath,
      congratsImagePath: congratsImagePath,
      onRestart: onRestart,
    );
  }
}

class _ResultScreenBody extends StatefulWidget {
  final String animationPath;
  final String congratsImagePath;
  final VoidCallback onRestart;

  const _ResultScreenBody({
    super.key,
    required this.animationPath,
    required this.congratsImagePath,
    required this.onRestart,
  });

  @override
  State<_ResultScreenBody> createState() => _ResultScreenBodyState();
}

class _ResultScreenBodyState extends State<_ResultScreenBody> {
  bool showAnimation = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: showAnimation
            ? Lottie.asset(
                widget.animationPath,
                repeat: false,
                onLoaded: (composition) {
                  Future.delayed(composition.duration, () {
                    setState(() {
                      showAnimation = false;
                    });
                  });
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(widget.congratsImagePath, width: 250),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'إعادة اللعب',
                    color: Colors.purpleAccent,
                    onPressed: () {
                      // نفذ دالة إعادة التشغيل المرسلة من شاشة اللعبة
                      widget.onRestart();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
