 import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pro5/pages/onboarding/custom_buttom.dart';

class ResultScreen extends StatelessWidget {
  final String animationPath;
  final String congratsImagePath;
  final VoidCallback onRestart;
  final double result;

  const ResultScreen({
    super.key,
    required this.animationPath,
    required this.congratsImagePath,
    required this.onRestart, required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return _ResultScreenBody(
      animationPath: animationPath,
      congratsImagePath: congratsImagePath,
      onRestart: onRestart,
      result: result,
    );
  }
}

class _ResultScreenBody extends StatefulWidget {
  final String animationPath;
  final String congratsImagePath;
  final VoidCallback onRestart;
  final result;

  const _ResultScreenBody({
    super.key,
    required this.animationPath,
    required this.congratsImagePath,
    required this.onRestart, this.result,
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
                  Text('نتيجتك:'),
                   Text(widget.result.toStringAsFixed(1)),
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
