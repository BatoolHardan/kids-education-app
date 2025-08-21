import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestScoreManager {
  double score = 0.0;
  final int totalQuestions;
  final String testName;
  final String gameName; // اسم اللعبة

  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TestScoreManager(
    this.totalQuestions, {
    required this.testName,
    required this.gameName,
  });

  double get stepValue => 10 / totalQuestions;

  void reset() {
    score = 0.0;
  }

  void addCorrect() {
    score += stepValue;
    if (score > 10) score = 10;
  }

  void addWrong() {
    score -= stepValue;
    if (score < 0) score = 0;
  }

  double get currentScore => double.parse(score.toStringAsFixed(1));
  Future<bool> saveScore() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print('✅ المستخدم مصادق: ${user.uid}');

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('scores')
            .doc(testName)
            .set({
              'score': currentScore,
              'totalQuestions': totalQuestions,
              'gameName': gameName,
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

        print('✅ تم حفظ النجاح بنجاح: $currentScore');
        return true;
      } else {
        print('❌ لم يتم مصادقة المستخدم');
        return false;
      }
    } catch (e) {
      print("❌ خطأ أثناء حفظ العلامة: $e");
      return false;
    }
  }
}
