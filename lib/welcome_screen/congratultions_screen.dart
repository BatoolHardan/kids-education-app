import 'package:flutter/material.dart';
import 'package:pro5/welcome_screen/congratultions_model.dart';
import 'welcome_data.dart';

class CongratulationsScreen extends StatelessWidget {
  final List<CongratulationsModel> stages;
  final int stageIndex;

  const CongratulationsScreen({
    super.key,
    required this.stages,
    required this.stageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final stage = stages[stageIndex];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: stage.backgroundColor,
          image:
              stage.backgroundImagePath != null
                  ? DecorationImage(
                    image: AssetImage(stage.backgroundImagePath!),
                    fit: BoxFit.cover,
                  )
                  : null,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(stage.imagePath, height: 250),
              const SizedBox(height: 20),
              Text(
                stage.title,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                stage.subtitle,
                style: const TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // مثال: الانتقال للمرحلة التالية أو الرجوع للرئيسية
                  if (stageIndex < stages.length - 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CongratulationsScreen(
                              stages: stages,
                              stageIndex: stageIndex + 1,
                            ),
                      ),
                    );
                  } else {
                    Navigator.pop(context); // أو أي شاشة رئيسية
                  }
                },
                child: Text(stage.buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
