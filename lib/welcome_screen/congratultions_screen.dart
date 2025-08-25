import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StageCompleteScreen extends StatelessWidget {
  final String stageName; // اسم المرحلة (مثل: الحروف، الأرقام)
  final VoidCallback onNextStage; // دالة للانتقال للمرحلة التالية
  final String animationPath; // مسار الأنيميشن (اختياري)

  const StageCompleteScreen({
    super.key,
    required this.stageName,
    required this.onNextStage,
    this.animationPath = 'assets/animations/party.json',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🎉 أنيميشن تشجيعي
                Lottie.asset(
                  animationPath,
                  width: 250,
                  height: 250,
                  repeat: false,
                ),
                const SizedBox(height: 20),
                // نص تهنئة
                Text(
                  'أحسنت! لقد أكملت مرحلة $stageName 🎉',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // زر الانتقال للمرحلة التالية
                ElevatedButton(
                  onPressed: onNextStage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'الانتقال للمرحلة التالية',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
