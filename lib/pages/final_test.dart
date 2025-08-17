import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinalTestPage extends StatelessWidget {
  const FinalTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الاختبار النهائي"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "هل أنت مستعد لاجتياز الاختبار النهائي؟",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // اعتبرنا الطفل نجح، نرجع true
                Get.back(result: true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text("✅ اجتزت الاختبار", style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // اعتبرنا الطفل لم ينجح، نرجع false
                Get.back(result: false);
              },
              child: Text("❌ لم أنجح", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
